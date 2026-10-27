import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/api_endpoints.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/core/storage/snapshot_cache.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';

/// Reads the client hub through the SGS API and keeps a last-known snapshot
/// per workspace so the launcher still renders offline.
class WorkspaceRepository {
  WorkspaceRepository(this._dio, this._cache, {this._now = DateTime.now});

  final Dio _dio;
  final SnapshotCache _cache;
  final DateTime Function() _now;

  static String _snapshotKey(String clientId) => 'workspace.$clientId';
  static const String _lastClientKey = 'workspace.last';

  Future<T> _get<T>(
    String path,
    T Function(Map<String, dynamic>) parse, {
    Map<String, Object>? query,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return parse(response.data ?? const <String, dynamic>{});
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  static List<T> _items<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parse,
  ) => (json['items'] as List<dynamic>? ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(parse)
      .toList(growable: false);

  Future<Me> me() => _get(ApiEndpoints.me, Me.fromJson);

  /// Workspaces the user can open; SGS staff see every client.
  Future<List<Membership>> workspaces(Me me) async {
    if (!me.isSgsAdmin) return me.memberships;
    return _get(
      ApiEndpoints.clients,
      (json) => _items(json, Membership.fromJson),
      query: {'page_size': 50, 'sort': 'name'},
    );
  }

  /// Remembers the last opened workspace on this device (for offline start).
  Future<void> rememberLocally(String clientId) =>
      _cache.write(_lastClientKey, {'client_id': clientId});

  /// Persists the choice to the profile so the web hub opens it too.
  Future<void> setDefaultWorkspace(String clientId) async {
    try {
      await _dio.patch<void>(
        ApiEndpoints.me,
        data: {'default_client_id': clientId},
      );
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  Future<String?> lastWorkspaceId() async =>
      (await _cache.read(_lastClientKey))?['client_id'] as String?;

  /// Loads a workspace; on network failure falls back to the cached snapshot.
  /// A 403/404 means access was removed, so the cached copy is discarded.
  Future<WorkspaceSnapshot> workspace(String clientId) async {
    try {
      final results = await Future.wait<Object>([
        _get(ApiEndpoints.client(clientId), Client.fromJson),
        _get(
          ApiEndpoints.projects,
          (json) => _items(json, Project.fromJson),
          query: {
            'client_id': clientId,
            'page_size': 50,
            'sort': '-updated_at',
          },
        ),
        _get(
          ApiEndpoints.products,
          (json) => _items(json, Product.fromJson),
          query: {'client_id': clientId, 'page_size': 100},
        ),
        _get(
          ApiEndpoints.members(clientId),
          (json) => _items(json, TeamMember.fromJson),
        ),
      ]);
      final snapshot = WorkspaceSnapshot(
        client: results[0] as Client,
        projects: results[1] as List<Project>,
        products: results[2] as List<Product>,
        team: results[3] as List<TeamMember>,
        savedAt: _now(),
      );
      await _cache.write(_snapshotKey(clientId), snapshot.toJson());
      return snapshot;
    } on ApiException catch (error) {
      final status = error.statusCode;
      if (status == 403 || status == 404) {
        await _cache.remove(_snapshotKey(clientId));
        rethrow;
      }
      if (status != null && status < 500) rethrow;
      final cached = await _cache.read(_snapshotKey(clientId));
      if (cached == null) rethrow;
      return WorkspaceSnapshot.fromJson(cached);
    }
  }

  Future<Project> project(String id) =>
      _get(ApiEndpoints.project(id), Project.fromJson);

  Future<List<Product>> projectProducts(Project project) => _get(
    ApiEndpoints.products,
    (json) => _items(json, Product.fromJson),
    query: {'client_id': project.clientId, 'project_id': project.id},
  );

  Future<List<Deliverable>> deliverables(String projectId) => _get(
    ApiEndpoints.assets,
    (json) => _items(json, Deliverable.fromJson),
    query: {
      'owner_type': 'project',
      'owner_id': projectId,
      'purpose': 'deliverable',
    },
  );

  /// Short-lived signed URL (1 hour) for an image or deliverable.
  Future<Uri> assetUrl(String assetId) => _get(
    ApiEndpoints.assetUrl(assetId),
    (json) => Uri.parse(json['url'] as String),
  );

  Future<Product> productBySlug(String slug) =>
      _get(ApiEndpoints.productBySlug(slug), Product.fromJson);

  /// Single-use 60-second link through /go/{slug}; the server records the
  /// launch and redirects to the client's app.
  Future<Uri> launchUrl(Product product) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.launchToken(product.id),
      );
      final url = Uri.tryParse(response.data?['url'] as String? ?? '');
      if (url == null || !isAllowedLaunchUrl(url)) {
        throw const ApiException(
          code: 'INVALID_LAUNCH_URL',
          message: 'This app could not be opened. Please try again.',
        );
      }
      return url;
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }
}

/// HTTPS only, except plain HTTP to a local development API.
bool isAllowedLaunchUrl(Uri url) =>
    url.scheme == 'https' ||
    (url.scheme == 'http' &&
        const {'localhost', '127.0.0.1', '10.0.2.2'}.contains(url.host));

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => WorkspaceRepository(
    ref.watch(dioProvider),
    ref.watch(snapshotCacheProvider),
  ),
);
