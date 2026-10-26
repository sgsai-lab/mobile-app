import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A canned response; `status: 0` simulates a network failure.
class FakeReply {
  const FakeReply(this.status, [this.body = const <String, dynamic>{}]);

  final int status;
  final Map<String, dynamic> body;
}

typedef FakeHandler = FakeReply Function(RequestOptions request);

/// In-memory Dio adapter: routes `'METHOD /path'` to handlers and records
/// requests so tests can assert on headers and bodies.
class FakeApi implements HttpClientAdapter {
  FakeApi(this.routes);

  final Map<String, FakeHandler> routes;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final handler = routes['${options.method} ${options.uri.path}'];
    if (handler == null) {
      return ResponseBody.fromString(
        jsonEncode({
          'error': {'code': 'NOT_FOUND', 'message': 'No fake route.'},
        }),
        404,
        headers: _json,
      );
    }
    final reply = handler(options);
    if (reply.status == 0) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      jsonEncode(reply.body),
      reply.status,
      headers: _json,
    );
  }

  static const Map<String, List<String>> _json = {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  };

  @override
  void close({bool force = false}) {}

  Iterable<RequestOptions> called(String method, String path) => requests.where(
    (request) => request.method == method && request.uri.path == path,
  );
}

Dio fakeDio(FakeApi api) =>
    Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = api;

Map<String, dynamic> error(String code, String message) => {
  'error': {'code': code, 'message': message},
};
