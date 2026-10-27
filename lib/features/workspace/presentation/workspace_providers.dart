import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/workspace/data/workspace_repository.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';

class HomeView {
  const HomeView({required this.workspaces, this.snapshot});

  /// Empty when offline (the list needs the network) or not invited yet.
  final List<Membership> workspaces;
  final WorkspaceSnapshot? snapshot;

  bool get hasWorkspace => snapshot != null;
}

/// Home screen state: the chosen workspace and its contents, with an offline
/// fallback to the last snapshot when the API is unreachable.
class HomeController extends AsyncNotifier<HomeView> {
  String? _selected;

  @override
  Future<HomeView> build() => _load(_selected);

  WorkspaceRepository get _repository => ref.read(workspaceRepositoryProvider);

  Future<HomeView> _load(String? requested) async {
    final List<Membership> workspaces;
    final Me me;
    try {
      me = await _repository.me();
      workspaces = await _repository.workspaces(me);
    } on ApiException catch (error) {
      // No network: render the last workspace from the device if we have one.
      final last = await _repository.lastWorkspaceId();
      if (error.statusCode != null || last == null) rethrow;
      return HomeView(
        workspaces: const [],
        snapshot: await _repository.workspace(last),
      );
    }
    if (workspaces.isEmpty) return const HomeView(workspaces: []);

    final ids = workspaces.map((workspace) => workspace.clientId).toSet();
    final last = await _repository.lastWorkspaceId();
    final chosen = [
      requested,
      last,
      me.defaultClientId,
    ].whereType<String>().where(ids.contains).firstOrNull;
    final id = chosen ?? workspaces.first.clientId;
    _selected = id;
    await _repository.rememberLocally(id);
    return HomeView(
      workspaces: workspaces,
      snapshot: await _repository.workspace(id),
    );
  }

  Future<void> switchTo(String clientId) async {
    _selected = clientId;
    state = const AsyncLoading<HomeView>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _load(clientId));
    // Best effort: the web hub opens the same workspace next time.
    unawaited(
      _repository.setDefaultWorkspace(clientId).catchError((Object _) {}),
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(_selected));
  }
}

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeView>(
  HomeController.new,
);

class ProjectDetail {
  const ProjectDetail({
    required this.project,
    required this.products,
    required this.deliverables,
  });

  final Project project;
  final List<Product> products;
  final List<Deliverable> deliverables;
}

final projectDetailProvider = FutureProvider.autoDispose
    .family<ProjectDetail, String>((ref, id) async {
      final repository = ref.watch(workspaceRepositoryProvider);
      final project = await repository.project(id);
      final results = await Future.wait<Object>([
        repository.projectProducts(project),
        repository.deliverables(project.id),
      ]);
      return ProjectDetail(
        project: project,
        products: results[0] as List<Product>,
        deliverables: results[1] as List<Deliverable>,
      );
    });

/// Signed image URLs expire after an hour; autoDispose refetches them.
final assetUrlProvider = FutureProvider.autoDispose.family<Uri, String>(
  (ref, assetId) => ref.watch(workspaceRepositoryProvider).assetUrl(assetId),
);
