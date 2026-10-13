import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_exception.dart';

DioException _dioError({
  required DioExceptionType type,
  Object? data,
  int? statusCode,
}) {
  final options = RequestOptions(path: '/api/v1/users/me');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('ApiException.fromDioException', () {
    test('parses the backend error envelope', () {
      final exception = ApiException.fromDioException(
        _dioError(
          type: DioExceptionType.badResponse,
          statusCode: 422,
          data: <String, dynamic>{
            'error': <String, dynamic>{
              'code': 'VALIDATION_ERROR',
              'message': 'Request validation failed',
              'requestId': 'req-123',
              'details': <dynamic>[
                <String, dynamic>{
                  'field': 'body.email',
                  'message': 'not an email',
                },
              ],
            },
          },
        ),
      );

      expect(exception.code, 'VALIDATION_ERROR');
      expect(exception.statusCode, 422);
      expect(exception.requestId, 'req-123');
      expect(exception.isValidationFailure, isTrue);
      expect(exception.messageForField('email'), 'not an email');
    });

    test('flags 401 so the session layer can react', () {
      final exception = ApiException.fromDioException(
        _dioError(
          type: DioExceptionType.badResponse,
          statusCode: 401,
          data: <String, dynamic>{
            'error': <String, dynamic>{
              'code': 'UNAUTHENTICATED',
              'message': 'Authentication required',
            },
          },
        ),
      );

      expect(exception.isUnauthenticated, isTrue);
    });

    test('maps transport failures to a user-safe message', () {
      final exception = ApiException.fromDioException(
        _dioError(type: DioExceptionType.connectionError),
      );

      expect(exception.code, 'NETWORK_ERROR');
      expect(exception.message, contains('connection'));
    });

    test('maps timeouts separately from connection loss', () {
      final exception = ApiException.fromDioException(
        _dioError(type: DioExceptionType.receiveTimeout),
      );

      expect(exception.code, 'TIMEOUT');
    });
  });
}
