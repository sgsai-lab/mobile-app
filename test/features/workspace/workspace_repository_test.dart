import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/storage/snapshot_cache.dart';
import 'package:mobile_app/features/workspace/data/workspace_repository.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';

import '../../helpers/fake_api.dart';

Map<String, FakeHandler> workspaceRoutes({int status = 200}) => {
  'GET /api/v1/clients/c1': (_) => FakeReply(
    status,
    status == 200
        ? {
            'id': 'c1',
            'name': 'Riverside Academy',
            'primary_sector': 'education',
            'my_role': 'member',
            'branding': {'logo_asset_id': null},
          }
        : error('NOT_FOUND', 'Workspace not found.'),
  ),
  'GET /api/v1/projects': (_) => FakeReply(status, {
    'items': [
      {
        'id': 'p1',
        'client_id': 'c1',
        'name': 'Learning portal',
        'status': 'in_progress',
        'sector': 'education',
        'sector_profile': {'programme': 'Year 9', 'academic_year': '2026/27'},
        'milestones': [
          {'title': 'Needs analysis', 'due': '2026-09-01', 'done': true},
          {'title': 'Pilot cohort', 'due': '2026-10-01', 'done': false},
        ],
      },
    ],
  }),
  'GET /api/v1/products': (_) => FakeReply(status, {
    'items': [
      {
        'id': 'prd1',
        'slug': 'learning-portal',
        'name': 'Learning Portal',
        'kind': 'pwa',
        'status': 'live',
        'launch_url': 'https://learn.example',
      },
      {
        'id': 'prd2',
        'slug': 'bad',
        'name': 'Bad link',
        'kind': 'web',
        'status': 'live',
        'launch_url': 'javascript:alert(1)',
      },
    ],
  }),
  'GET /api/v1/clients/c1/members': (_) => FakeReply(status, {
    'items': [
      {'full_name': 'Hana Head', 'role': 'admin'},
    ],
  }),
  'POST /api/v1/products/prd1/launch-token': (_) => const FakeReply(201, {
    'url': 'https://www.sgsaitechnology.com/go/learning-portal?t=x&src=android',
  }),
};

void main() {
  late MemorySnapshotCache cache;

  WorkspaceRepository repositoryFor(FakeApi api) =>
      WorkspaceRepository(fakeDio(api), cache, now: () => DateTime.utc(2026));

  setUp(() => cache = MemorySnapshotCache());

  test('loads a workspace and caches a token-free snapshot', () async {
    final repository = repositoryFor(FakeApi(workspaceRoutes()));
    final snapshot = await repository.workspace('c1');

    expect(snapshot.offline, isFalse);
    expect(snapshot.client.name, 'Riverside Academy');
    expect(snapshot.client.role, WorkspaceRole.member);
    expect(snapshot.projects.single.subtitle, 'Education · Year 9 · 2026/27');
    expect(snapshot.projects.single.nextMilestone!.title, 'Pilot cohort');
    expect(
      snapshot.products.last.launchUrl,
      isNull,
      reason: 'non-HTTPS links are dropped',
    );
    expect(cache.entries['workspace.c1'].toString(), isNot(contains('token')));
  });

  test('offline: falls back to the cached snapshot and marks it', () async {
    await repositoryFor(FakeApi(workspaceRoutes())).workspace('c1');
    final offline = repositoryFor(FakeApi(workspaceRoutes(status: 0)));

    final snapshot = await offline.workspace('c1');
    expect(snapshot.offline, isTrue);
    expect(snapshot.products.first.name, 'Learning Portal');
  });

  test('removed access discards the cached snapshot', () async {
    await repositoryFor(FakeApi(workspaceRoutes())).workspace('c1');
    final revoked = repositoryFor(FakeApi(workspaceRoutes(status: 404)));

    await expectLater(
      revoked.workspace('c1'),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
    expect(cache.entries.containsKey('workspace.c1'), isFalse);
  });

  test(
    'launching asks for a single-use link and opens it externally',
    () async {
      final api = FakeApi(workspaceRoutes());
      final opened = <Uri>[];
      final launcher = AppLauncher(repositoryFor(api), (url) async {
        opened.add(url);
        return true;
      }, platform: TargetPlatform.android);
      final snapshot = await repositoryFor(api).workspace('c1');

      await launcher.open(snapshot.products.first);
      expect(opened.single.path, '/go/learning-portal');
      expect(opened.single.queryParameters['src'], 'android');
    },
  );

  test(
    'store-only apps open the right store listing without a token',
    () async {
      final api = FakeApi({});
      final opened = <Uri>[];
      final product = Product.fromJson({
        'id': 'a1',
        'slug': 'ops',
        'name': 'Ops',
        'kind': 'android',
        'status': 'live',
        'store_urls': {
          'android': 'https://play.google.com/store/apps/details?id=x',
          'ios': 'https://apps.apple.com/app/id1',
        },
      });
      final ios = AppLauncher(repositoryFor(api), (url) async {
        opened.add(url);
        return true;
      }, platform: TargetPlatform.iOS);
      await ios.open(product);
      expect(opened.single.host, 'apps.apple.com');
      expect(api.requests, isEmpty);

      final retired = Product.fromJson({
        ...product.toJson(),
        'status': 'retired',
      });
      await expectLater(ios.open(retired), throwsA(isA<ApiException>()));
    },
  );

  test('launch links must be HTTPS except a local development API', () {
    expect(isAllowedLaunchUrl(Uri.parse('https://x.example/go/a')), isTrue);
    expect(isAllowedLaunchUrl(Uri.parse('http://10.0.2.2:8080/go/a')), isTrue);
    expect(isAllowedLaunchUrl(Uri.parse('http://evil.example/go/a')), isFalse);
    expect(isAllowedLaunchUrl(Uri.parse('intent://x')), isFalse);
  });

  test('milestones before today and not done are overdue', () {
    final milestone = Milestone.fromJson({
      'title': 'Rollout',
      'due': '2026-10-01',
    });
    expect(milestone.isOverdue(DateTime(2026, 10, 27)), isTrue);
    expect(milestone.isOverdue(DateTime(2026, 9, 30)), isFalse);
    expect(
      Milestone.fromJson({'title': 'x', 'due': '2026-10-01', 'done': true})
          .isOverdue(DateTime(2027)),
      isFalse,
    );
  });
}
