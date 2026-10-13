import 'package:dio/dio.dart';

class ApiErrorDetail {
  const ApiErrorDetail({required this.field, required this.message});

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) => ApiErrorDetail(
    field: json['field'] as String? ?? '',
    message: json['message'] as String? ?? '',
  );

  final String field;
  final String message;
}

/// Mirrors the backend error envelope:
/// `{"error": {"code", "message", "requestId", "details": [...]}}`.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.requestId,
    this.details = const <ApiErrorDetail>[],
  });

  factory ApiException.fromDioException(DioException error) {
    final response = error.response;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final envelope = data['error'];
      if (envelope is Map<String, dynamic>) {
        final rawDetails = envelope['details'];
        return ApiException(
          code: envelope['code'] as String? ?? 'HTTP_ERROR',
          message: envelope['message'] as String? ?? 'Request failed.',
          statusCode: response?.statusCode,
          requestId: envelope['requestId'] as String?,
          details: rawDetails is List
              ? rawDetails
                    .whereType<Map<String, dynamic>>()
                    .map(ApiErrorDetail.fromJson)
                    .toList(growable: false)
              : const <ApiErrorDetail>[],
        );
      }
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ApiException(
        code: 'TIMEOUT',
        message: 'The server took too long to respond. Please try again.',
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => const ApiException(
        code: 'NETWORK_ERROR',
        message: 'No connection. Check your network and try again.',
      ),
      DioExceptionType.cancel => const ApiException(
        code: 'CANCELLED',
        message: 'The request was cancelled.',
      ),
      _ => ApiException(
        code: 'HTTP_ERROR',
        message: 'Something went wrong. Please try again.',
        statusCode: response?.statusCode,
      ),
    };
  }

  final String code;
  final String message;
  final int? statusCode;
  final String? requestId;
  final List<ApiErrorDetail> details;

  bool get isUnauthenticated => statusCode == 401;

  bool get isValidationFailure => code == 'VALIDATION_ERROR';

  String? messageForField(String field) {
    for (final detail in details) {
      if (detail.field == field || detail.field.endsWith('.$field')) {
        return detail.message;
      }
    }
    return null;
  }

  @override
  String toString() => 'ApiException($code, status: $statusCode)';
}
