import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/workspace/data/workspace_repository.dart';
import 'package:mobile_app/features/workspace/domain/workspace_models.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

typedef OpenUrl = Future<bool> Function(Uri url);

Future<bool> _openExternally(Uri url) =>
    launcher.launchUrl(url, mode: launcher.LaunchMode.externalApplication);

/// Opens client apps outside this app (system browser or store), never in an
/// in-app web view (APP-11 decision).
class AppLauncher {
  AppLauncher(this._repository, this._open, {TargetPlatform? platform})
    : _platform = platform ?? defaultTargetPlatform;

  final WorkspaceRepository _repository;
  final OpenUrl _open;
  final TargetPlatform _platform;

  /// Throws [ApiException] with a user-facing message on failure.
  Future<void> open(Product product) async {
    if (product.isRetired) {
      throw const ApiException(
        code: 'RETIRED',
        message: 'This app has been retired.',
      );
    }
    final store = _platform == TargetPlatform.iOS
        ? product.iosStoreUrl
        : product.androidStoreUrl;
    // Store apps without a web address open their store listing directly.
    final url = product.launchUrl == null && store != null
        ? store
        : await _repository.launchUrl(product);
    if (!await _open(url)) {
      throw const ApiException(
        code: 'LAUNCH_FAILED',
        message: 'Could not open this app on your device.',
      );
    }
  }

  Future<void> openAsset(String assetId) async {
    final url = await _repository.assetUrl(assetId);
    if (!await _open(url)) {
      throw const ApiException(
        code: 'LAUNCH_FAILED',
        message: 'Could not open this file on your device.',
      );
    }
  }
}

final openUrlProvider = Provider<OpenUrl>((ref) => _openExternally);

final appLauncherProvider = Provider<AppLauncher>(
  (ref) => AppLauncher(
    ref.watch(workspaceRepositoryProvider),
    ref.watch(openUrlProvider),
  ),
);
