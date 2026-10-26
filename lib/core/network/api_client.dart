import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/auth/token_store.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/network/client_headers.dart';
import 'package:mobile_app/core/network/request_log_interceptor.dart';
import 'package:mobile_app/core/session/session_events.dart';

/// The single configured HTTP client. Features depend on repositories, never
/// on [Dio] directly.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final tokenStore = ref.watch(tokenStoreProvider);
  final sessionEvents = ref.watch(sessionEventsProvider);

  final options = BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
    sendTimeout: config.connectTimeout,
    contentType: Headers.jsonContentType,
    headers: <String, String>{
      'Accept': Headers.jsonContentType,
      ...clientHeaders(),
    },
  );

  // A bare client for refresh and retry, so a 401 can never recurse.
  final refreshClient = Dio(options);
  final dio = Dio(options)
    ..interceptors.add(
      AuthInterceptor(
        tokenStore: tokenStore,
        refreshClient: refreshClient,
        onSessionExpired: () async => sessionEvents.notifyExpired(),
      ),
    );

  if (config.enableHttpLogging) {
    dio.interceptors.add(const RequestLogInterceptor());
  }

  ref.onDispose(() {
    dio.close();
    refreshClient.close();
  });

  return dio;
});
