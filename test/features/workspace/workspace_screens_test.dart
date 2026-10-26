import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/storage/snapshot_cache.dart';
import 'package:mobile_app/features/workspace/data/workspace_repository.dart';
import 'package:mobile_app/features/workspace/presentation/app_launcher.dart';
import 'package:mobile_app/features/workspace/presentation/project_detail_screen.dart';
import 'package:mobile_app/features/workspace/presentation/workspace_home_screen.dart';

import '../../helpers/fake_api.dart';
import '../../helpers/pump_app.dart';
import 'workspace_repository_test.dart' show workspaceRoutes;

Map<String, FakeHandler> homeRoutes({
  List<Map<String, dynamic>> memberships = const [
    {
      'client_id': 'c1',
      'client_name': 'Riverside Academy',
      'primary_sector': 'education',
      'role': 'member',
    },
  ],
  int status = 200,
}) => {
  'GET /api/v1/users/me': (_) => FakeReply(status, {
    'id': 'u1',
    'full_name': 'Hana Head',
    'email': 'hana@riverside.example',
    'role': 'user',
    'memberships': memberships,
  }),
  ...workspaceRoutes(status: status),
  'GET /api/v1/products': (_) => FakeReply(status, {
    'items': [
      {
        'id': 'prd1',
        'slug': 'learning-portal',
        'name': 'Learning Portal',
        'kind': 'pwa',
        'status': 'live',
        'summary': 'Courses and homework',
        'launch_url': 'https://learn.example',
      },
      {
        'id': 'prd3',
        'slug': 'old-portal',
        'name': 'Old Portal',
        'kind': 'web',
        'status': 'retired',
        'launch_url': 'https://old.example',
      },
      {
        'id': 'prd4',
        'slug': 'coming',
        'name': 'Coming Soon',
        'kind': 'pwa',
        'status': 'planned',
      },
    ],
  }),
};

void main() {
  late MemorySnapshotCache cache;
  late List<Uri> opened;

  setUp(() {
    cache = MemorySnapshotCache();
    opened = [];
  });

  Future<void> pumpHome(WidgetTester tester, FakeApi api) => tester.pumpApp(
    const WorkspaceHomeScreen(),
    overrides: [
      workspaceRepositoryProvider.overrideWithValue(
        WorkspaceRepository(fakeDio(api), cache),
      ),
      openUrlProvider.overrideWithValue((url) async {
        opened.add(url);
        return true;
      }),
    ],
  );

  testWidgets('shows apps, projects and team; planned apps stay hidden', (
    tester,
  ) async {
    await pumpHome(tester, FakeApi(homeRoutes()));
    await tester.pumpAndSettle();

    expect(find.text('Riverside Academy'), findsWidgets);
    expect(find.text('Learning Portal'), findsOneWidget);
    expect(find.text('Coming Soon'), findsNothing);
    expect(find.text('Learning portal'), findsOneWidget);
    expect(find.text('Next: Pilot cohort · 1 Oct 2026'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Hana Head'), 200);
    expect(find.text('Hana Head'), findsOneWidget);
  });

  testWidgets('retired apps are announced and cannot be opened', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpHome(tester, FakeApi(homeRoutes()));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Old Portal, retired'), findsOneWidget);
    await tester.tap(find.text('Old Portal'));
    await tester.pump();
    expect(opened, isEmpty);

    await tester.tap(find.text('Learning Portal'));
    await tester.pumpAndSettle();
    expect(opened.single.path, '/go/learning-portal');
    semantics.dispose();
  });

  testWidgets('people without a workspace get a friendly explanation', (
    tester,
  ) async {
    await pumpHome(tester, FakeApi(homeRoutes(memberships: const [])));
    await tester.pumpAndSettle();

    expect(find.text('No workspace yet'), findsOneWidget);
    await tester.tap(find.text('Contact SGS AI'));
    expect(opened.single.scheme, 'mailto');
  });

  testWidgets('offline start renders the last snapshot with a notice', (
    tester,
  ) async {
    // Real async: Dio's timers do not run inside the widget test's fake clock.
    await tester.runAsync(() async {
      final online = WorkspaceRepository(fakeDio(FakeApi(homeRoutes())), cache);
      await online.rememberLocally('c1');
      await online.workspace('c1');
    });

    await pumpHome(tester, FakeApi(homeRoutes(status: 0)));
    await tester.pumpAndSettle();

    expect(find.textContaining('You are offline'), findsOneWidget);
    expect(find.text('Learning Portal'), findsOneWidget);
    await tester.tap(find.text('Learning Portal'));
    await tester.pump();
    expect(opened, isEmpty);
    expect(
      find.text('You are offline. Try again once connected.'),
      findsOneWidget,
    );
  });

  testWidgets('project detail highlights overdue milestones', (tester) async {
    final api = FakeApi({
      'GET /api/v1/projects/p1': (_) => const FakeReply(200, {
        'id': 'p1',
        'client_id': 'c1',
        'name': 'Learning portal',
        'status': 'in_progress',
        'sector': 'education',
        'milestones': [
          {'title': 'Needs analysis', 'due': '2026-09-01', 'done': true},
          {'title': 'Pilot cohort', 'due': '2026-10-01', 'done': false},
          {'title': 'Rollout', 'due': '2027-01-10', 'done': false},
        ],
      }),
      'GET /api/v1/products': (_) =>
          const FakeReply(200, {'items': <Object>[]}),
      'GET /api/v1/assets': (_) => const FakeReply(200, {
        'items': [
          {
            'id': 'a1',
            'filename': 'scope.pdf',
            'kind': 'document',
            'size_bytes': 1048576,
          },
        ],
      }),
      'GET /api/v1/assets/a1/url': (_) =>
          const FakeReply(200, {'url': 'https://storage.example/scope.pdf'}),
    });
    await tester.pumpApp(
      ProjectDetailScreen(projectId: 'p1', today: DateTime(2026, 10, 27)),
      overrides: [
        workspaceRepositoryProvider.overrideWithValue(
          WorkspaceRepository(fakeDio(api), cache),
        ),
        openUrlProvider.overrideWithValue((url) async {
          opened.add(url);
          return true;
        }),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Overdue · 1 Oct 2026'), findsOneWidget);
    expect(find.text('10 Jan 2027'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('scope.pdf'), 200);
    await tester.tap(find.byTooltip('Open scope.pdf'));
    await tester.pumpAndSettle();
    expect(opened.single.host, 'storage.example');
  });
}
