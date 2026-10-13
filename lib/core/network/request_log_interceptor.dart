import 'package:dio/dio.dart';
import 'package:mobile_app/core/logging/app_logger.dart';

/// Logs the request line and status only. Headers and bodies are never logged:
/// they carry bearer tokens, passwords and personal data.
class RequestLogInterceptor extends Interceptor {
  const RequestLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.instance.debug('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.instance.debug(
      '← ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.instance.debug(
      '✖ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.path}',
    );
    handler.next(err);
  }
}
