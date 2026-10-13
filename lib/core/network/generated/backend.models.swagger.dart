// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import 'dart:convert';

import 'package:mobile_app/core/network/api_type_aliases.dart';

import 'backend.enums.swagger.dart' as enums;

part 'backend.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class AdminUserCreate {
  const AdminUserCreate({
    required this.email,
    required this.fullName,
    this.role,
  });

  factory AdminUserCreate.fromJson(Map<String, dynamic> json) =>
      _$AdminUserCreateFromJson(json);

  static const toJsonFactory = _$AdminUserCreateToJson;
  Map<String, dynamic> toJson() => _$AdminUserCreateToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(
    name: 'role',
    toJson: userRoleNullableToJson,
    fromJson: userRoleRoleNullableFromJson,
  )
  final enums.UserRole? role;
  static enums.UserRole? userRoleRoleNullableFromJson(Object? value) =>
      userRoleNullableFromJson(value, enums.UserRole.user);

  static const fromJsonFactory = _$AdminUserCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AdminUserCreate &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $AdminUserCreateExtension on AdminUserCreate {
  AdminUserCreate copyWith({
    String? email,
    String? fullName,
    enums.UserRole? role,
  }) {
    return AdminUserCreate(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
    );
  }

  AdminUserCreate copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? fullName,
    Wrapped<enums.UserRole?>? role,
  }) {
    return AdminUserCreate(
      email: (email != null ? email.value : this.email),
      fullName: (fullName != null ? fullName.value : this.fullName),
      role: (role != null ? role.value : this.role),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AdminUserUpdate {
  const AdminUserUpdate({this.fullName, this.role, this.status});

  factory AdminUserUpdate.fromJson(Map<String, dynamic> json) =>
      _$AdminUserUpdateFromJson(json);

  static const toJsonFactory = _$AdminUserUpdateToJson;
  Map<String, dynamic> toJson() => _$AdminUserUpdateToJson(this);

  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(
    name: 'role',
    toJson: userRoleNullableToJson,
    fromJson: userRoleNullableFromJson,
  )
  final enums.UserRole? role;
  @JsonKey(
    name: 'status',
    toJson: userStatusNullableToJson,
    fromJson: userStatusNullableFromJson,
  )
  final enums.UserStatus? status;
  static const fromJsonFactory = _$AdminUserUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AdminUserUpdate &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(status) ^
      runtimeType.hashCode;
}

extension $AdminUserUpdateExtension on AdminUserUpdate {
  AdminUserUpdate copyWith({
    String? fullName,
    enums.UserRole? role,
    enums.UserStatus? status,
  }) {
    return AdminUserUpdate(
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  AdminUserUpdate copyWithWrapped({
    Wrapped<String?>? fullName,
    Wrapped<enums.UserRole?>? role,
    Wrapped<enums.UserStatus?>? status,
  }) {
    return AdminUserUpdate(
      fullName: (fullName != null ? fullName.value : this.fullName),
      role: (role != null ? role.value : this.role),
      status: (status != null ? status.value : this.status),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AppleRequest {
  const AppleRequest({required this.idToken, this.nonce, this.fullName});

  factory AppleRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleRequestFromJson(json);

  static const toJsonFactory = _$AppleRequestToJson;
  Map<String, dynamic> toJson() => _$AppleRequestToJson(this);

  @JsonKey(name: 'id_token')
  final String idToken;
  @JsonKey(name: 'nonce')
  final String? nonce;
  @JsonKey(name: 'full_name')
  final String? fullName;
  static const fromJsonFactory = _$AppleRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppleRequest &&
            (identical(other.idToken, idToken) ||
                const DeepCollectionEquality().equals(
                  other.idToken,
                  idToken,
                )) &&
            (identical(other.nonce, nonce) ||
                const DeepCollectionEquality().equals(other.nonce, nonce)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(idToken) ^
      const DeepCollectionEquality().hash(nonce) ^
      const DeepCollectionEquality().hash(fullName) ^
      runtimeType.hashCode;
}

extension $AppleRequestExtension on AppleRequest {
  AppleRequest copyWith({String? idToken, String? nonce, String? fullName}) {
    return AppleRequest(
      idToken: idToken ?? this.idToken,
      nonce: nonce ?? this.nonce,
      fullName: fullName ?? this.fullName,
    );
  }

  AppleRequest copyWithWrapped({
    Wrapped<String>? idToken,
    Wrapped<String?>? nonce,
    Wrapped<String?>? fullName,
  }) {
    return AppleRequest(
      idToken: (idToken != null ? idToken.value : this.idToken),
      nonce: (nonce != null ? nonce.value : this.nonce),
      fullName: (fullName != null ? fullName.value : this.fullName),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  static const toJsonFactory = _$ChangePasswordRequestToJson;
  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  @JsonKey(name: 'current_password')
  final String currentPassword;
  @JsonKey(name: 'new_password')
  final String newPassword;
  static const fromJsonFactory = _$ChangePasswordRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChangePasswordRequest &&
            (identical(other.currentPassword, currentPassword) ||
                const DeepCollectionEquality().equals(
                  other.currentPassword,
                  currentPassword,
                )) &&
            (identical(other.newPassword, newPassword) ||
                const DeepCollectionEquality().equals(
                  other.newPassword,
                  newPassword,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(currentPassword) ^
      const DeepCollectionEquality().hash(newPassword) ^
      runtimeType.hashCode;
}

extension $ChangePasswordRequestExtension on ChangePasswordRequest {
  ChangePasswordRequest copyWith({
    String? currentPassword,
    String? newPassword,
  }) {
    return ChangePasswordRequest(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  ChangePasswordRequest copyWithWrapped({
    Wrapped<String>? currentPassword,
    Wrapped<String>? newPassword,
  }) {
    return ChangePasswordRequest(
      currentPassword: (currentPassword != null
          ? currentPassword.value
          : this.currentPassword),
      newPassword: (newPassword != null ? newPassword.value : this.newPassword),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class EmailRequest {
  const EmailRequest({required this.email});

  factory EmailRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailRequestFromJson(json);

  static const toJsonFactory = _$EmailRequestToJson;
  Map<String, dynamic> toJson() => _$EmailRequestToJson(this);

  @JsonKey(name: 'email')
  final String email;
  static const fromJsonFactory = _$EmailRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EmailRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^ runtimeType.hashCode;
}

extension $EmailRequestExtension on EmailRequest {
  EmailRequest copyWith({String? email}) {
    return EmailRequest(email: email ?? this.email);
  }

  EmailRequest copyWithWrapped({Wrapped<String>? email}) {
    return EmailRequest(email: (email != null ? email.value : this.email));
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorBody {
  const ErrorBody({
    required this.code,
    required this.message,
    required this.requestId,
    required this.details,
  });

  factory ErrorBody.fromJson(Map<String, dynamic> json) =>
      _$ErrorBodyFromJson(json);

  static const toJsonFactory = _$ErrorBodyToJson;
  Map<String, dynamic> toJson() => _$ErrorBodyToJson(this);

  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'requestId')
  final String? requestId;
  @JsonKey(name: 'details', defaultValue: <ErrorDetail>[])
  final List<ErrorDetail> details;
  static const fromJsonFactory = _$ErrorBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorBody &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(
                  other.message,
                  message,
                )) &&
            (identical(other.requestId, requestId) ||
                const DeepCollectionEquality().equals(
                  other.requestId,
                  requestId,
                )) &&
            (identical(other.details, details) ||
                const DeepCollectionEquality().equals(other.details, details)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(requestId) ^
      const DeepCollectionEquality().hash(details) ^
      runtimeType.hashCode;
}

extension $ErrorBodyExtension on ErrorBody {
  ErrorBody copyWith({
    String? code,
    String? message,
    String? requestId,
    List<ErrorDetail>? details,
  }) {
    return ErrorBody(
      code: code ?? this.code,
      message: message ?? this.message,
      requestId: requestId ?? this.requestId,
      details: details ?? this.details,
    );
  }

  ErrorBody copyWithWrapped({
    Wrapped<String>? code,
    Wrapped<String>? message,
    Wrapped<String?>? requestId,
    Wrapped<List<ErrorDetail>>? details,
  }) {
    return ErrorBody(
      code: (code != null ? code.value : this.code),
      message: (message != null ? message.value : this.message),
      requestId: (requestId != null ? requestId.value : this.requestId),
      details: (details != null ? details.value : this.details),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorDetail {
  const ErrorDetail({this.field, required this.message});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);

  static const toJsonFactory = _$ErrorDetailToJson;
  Map<String, dynamic> toJson() => _$ErrorDetailToJson(this);

  @JsonKey(name: 'field')
  final String? field;
  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$ErrorDetailFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorDetail &&
            (identical(other.field, field) ||
                const DeepCollectionEquality().equals(other.field, field)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(field) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $ErrorDetailExtension on ErrorDetail {
  ErrorDetail copyWith({String? field, String? message}) {
    return ErrorDetail(
      field: field ?? this.field,
      message: message ?? this.message,
    );
  }

  ErrorDetail copyWithWrapped({
    Wrapped<String?>? field,
    Wrapped<String>? message,
  }) {
    return ErrorDetail(
      field: (field != null ? field.value : this.field),
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorEnvelope {
  const ErrorEnvelope({required this.error});

  factory ErrorEnvelope.fromJson(Map<String, dynamic> json) =>
      _$ErrorEnvelopeFromJson(json);

  static const toJsonFactory = _$ErrorEnvelopeToJson;
  Map<String, dynamic> toJson() => _$ErrorEnvelopeToJson(this);

  @JsonKey(name: 'error')
  final ErrorBody error;
  static const fromJsonFactory = _$ErrorEnvelopeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorEnvelope &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(error) ^ runtimeType.hashCode;
}

extension $ErrorEnvelopeExtension on ErrorEnvelope {
  ErrorEnvelope copyWith({ErrorBody? error}) {
    return ErrorEnvelope(error: error ?? this.error);
  }

  ErrorEnvelope copyWithWrapped({Wrapped<ErrorBody>? error}) {
    return ErrorEnvelope(error: (error != null ? error.value : this.error));
  }
}

@JsonSerializable(explicitToJson: true)
class FirebaseRequest {
  const FirebaseRequest({required this.idToken});

  factory FirebaseRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRequestFromJson(json);

  static const toJsonFactory = _$FirebaseRequestToJson;
  Map<String, dynamic> toJson() => _$FirebaseRequestToJson(this);

  @JsonKey(name: 'id_token')
  final String idToken;
  static const fromJsonFactory = _$FirebaseRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FirebaseRequest &&
            (identical(other.idToken, idToken) ||
                const DeepCollectionEquality().equals(other.idToken, idToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(idToken) ^ runtimeType.hashCode;
}

extension $FirebaseRequestExtension on FirebaseRequest {
  FirebaseRequest copyWith({String? idToken}) {
    return FirebaseRequest(idToken: idToken ?? this.idToken);
  }

  FirebaseRequest copyWithWrapped({Wrapped<String>? idToken}) {
    return FirebaseRequest(
      idToken: (idToken != null ? idToken.value : this.idToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GoogleRequest {
  const GoogleRequest({required this.idToken, this.nonce});

  factory GoogleRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleRequestFromJson(json);

  static const toJsonFactory = _$GoogleRequestToJson;
  Map<String, dynamic> toJson() => _$GoogleRequestToJson(this);

  @JsonKey(name: 'id_token')
  final String idToken;
  @JsonKey(name: 'nonce')
  final String? nonce;
  static const fromJsonFactory = _$GoogleRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GoogleRequest &&
            (identical(other.idToken, idToken) ||
                const DeepCollectionEquality().equals(
                  other.idToken,
                  idToken,
                )) &&
            (identical(other.nonce, nonce) ||
                const DeepCollectionEquality().equals(other.nonce, nonce)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(idToken) ^
      const DeepCollectionEquality().hash(nonce) ^
      runtimeType.hashCode;
}

extension $GoogleRequestExtension on GoogleRequest {
  GoogleRequest copyWith({String? idToken, String? nonce}) {
    return GoogleRequest(
      idToken: idToken ?? this.idToken,
      nonce: nonce ?? this.nonce,
    );
  }

  GoogleRequest copyWithWrapped({
    Wrapped<String>? idToken,
    Wrapped<String?>? nonce,
  }) {
    return GoogleRequest(
      idToken: (idToken != null ? idToken.value : this.idToken),
      nonce: (nonce != null ? nonce.value : this.nonce),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class HTTPValidationError {
  const HTTPValidationError({this.detail});

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) =>
      _$HTTPValidationErrorFromJson(json);

  static const toJsonFactory = _$HTTPValidationErrorToJson;
  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ValidationError>[])
  final List<ValidationError>? detail;
  static const fromJsonFactory = _$HTTPValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HTTPValidationError &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $HTTPValidationErrorExtension on HTTPValidationError {
  HTTPValidationError copyWith({List<ValidationError>? detail}) {
    return HTTPValidationError(detail: detail ?? this.detail);
  }

  HTTPValidationError copyWithWrapped({
    Wrapped<List<ValidationError>?>? detail,
  }) {
    return HTTPValidationError(
      detail: (detail != null ? detail.value : this.detail),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  static const toJsonFactory = _$LoginRequestToJson;
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$LoginRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginRequestExtension on LoginRequest {
  LoginRequest copyWith({String? email, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  LoginRequest copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
  }) {
    return LoginRequest(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MfaChallengeResponse {
  const MfaChallengeResponse({
    this.mfaRequired,
    required this.mfaToken,
    this.methods,
  });

  factory MfaChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaChallengeResponseFromJson(json);

  static const toJsonFactory = _$MfaChallengeResponseToJson;
  Map<String, dynamic> toJson() => _$MfaChallengeResponseToJson(this);

  @JsonKey(name: 'mfa_required', defaultValue: true)
  final bool? mfaRequired;
  @JsonKey(name: 'mfa_token')
  final String mfaToken;
  @JsonKey(name: 'methods', defaultValue: <String>[])
  final List<String>? methods;
  static const fromJsonFactory = _$MfaChallengeResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MfaChallengeResponse &&
            (identical(other.mfaRequired, mfaRequired) ||
                const DeepCollectionEquality().equals(
                  other.mfaRequired,
                  mfaRequired,
                )) &&
            (identical(other.mfaToken, mfaToken) ||
                const DeepCollectionEquality().equals(
                  other.mfaToken,
                  mfaToken,
                )) &&
            (identical(other.methods, methods) ||
                const DeepCollectionEquality().equals(other.methods, methods)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(mfaRequired) ^
      const DeepCollectionEquality().hash(mfaToken) ^
      const DeepCollectionEquality().hash(methods) ^
      runtimeType.hashCode;
}

extension $MfaChallengeResponseExtension on MfaChallengeResponse {
  MfaChallengeResponse copyWith({
    bool? mfaRequired,
    String? mfaToken,
    List<String>? methods,
  }) {
    return MfaChallengeResponse(
      mfaRequired: mfaRequired ?? this.mfaRequired,
      mfaToken: mfaToken ?? this.mfaToken,
      methods: methods ?? this.methods,
    );
  }

  MfaChallengeResponse copyWithWrapped({
    Wrapped<bool?>? mfaRequired,
    Wrapped<String>? mfaToken,
    Wrapped<List<String>?>? methods,
  }) {
    return MfaChallengeResponse(
      mfaRequired: (mfaRequired != null ? mfaRequired.value : this.mfaRequired),
      mfaToken: (mfaToken != null ? mfaToken.value : this.mfaToken),
      methods: (methods != null ? methods.value : this.methods),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MfaStatusResponse {
  const MfaStatusResponse({
    required this.available,
    required this.enabled,
    required this.methods,
    required this.recoveryCodesRemaining,
  });

  factory MfaStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MfaStatusResponseFromJson(json);

  static const toJsonFactory = _$MfaStatusResponseToJson;
  Map<String, dynamic> toJson() => _$MfaStatusResponseToJson(this);

  @JsonKey(name: 'available')
  final bool available;
  @JsonKey(name: 'enabled')
  final bool enabled;
  @JsonKey(name: 'methods', defaultValue: <String>[])
  final List<String> methods;
  @JsonKey(name: 'recovery_codes_remaining')
  final int recoveryCodesRemaining;
  static const fromJsonFactory = _$MfaStatusResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MfaStatusResponse &&
            (identical(other.available, available) ||
                const DeepCollectionEquality().equals(
                  other.available,
                  available,
                )) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.methods, methods) ||
                const DeepCollectionEquality().equals(
                  other.methods,
                  methods,
                )) &&
            (identical(other.recoveryCodesRemaining, recoveryCodesRemaining) ||
                const DeepCollectionEquality().equals(
                  other.recoveryCodesRemaining,
                  recoveryCodesRemaining,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(available) ^
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(methods) ^
      const DeepCollectionEquality().hash(recoveryCodesRemaining) ^
      runtimeType.hashCode;
}

extension $MfaStatusResponseExtension on MfaStatusResponse {
  MfaStatusResponse copyWith({
    bool? available,
    bool? enabled,
    List<String>? methods,
    int? recoveryCodesRemaining,
  }) {
    return MfaStatusResponse(
      available: available ?? this.available,
      enabled: enabled ?? this.enabled,
      methods: methods ?? this.methods,
      recoveryCodesRemaining:
          recoveryCodesRemaining ?? this.recoveryCodesRemaining,
    );
  }

  MfaStatusResponse copyWithWrapped({
    Wrapped<bool>? available,
    Wrapped<bool>? enabled,
    Wrapped<List<String>>? methods,
    Wrapped<int>? recoveryCodesRemaining,
  }) {
    return MfaStatusResponse(
      available: (available != null ? available.value : this.available),
      enabled: (enabled != null ? enabled.value : this.enabled),
      methods: (methods != null ? methods.value : this.methods),
      recoveryCodesRemaining: (recoveryCodesRemaining != null
          ? recoveryCodesRemaining.value
          : this.recoveryCodesRemaining),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class MfaVerifyRequest {
  const MfaVerifyRequest({
    required this.mfaToken,
    this.code,
    this.recoveryCode,
  });

  factory MfaVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$MfaVerifyRequestFromJson(json);

  static const toJsonFactory = _$MfaVerifyRequestToJson;
  Map<String, dynamic> toJson() => _$MfaVerifyRequestToJson(this);

  @JsonKey(name: 'mfa_token')
  final String mfaToken;
  @JsonKey(name: 'code')
  final String? code;
  @JsonKey(name: 'recovery_code')
  final String? recoveryCode;
  static const fromJsonFactory = _$MfaVerifyRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MfaVerifyRequest &&
            (identical(other.mfaToken, mfaToken) ||
                const DeepCollectionEquality().equals(
                  other.mfaToken,
                  mfaToken,
                )) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.recoveryCode, recoveryCode) ||
                const DeepCollectionEquality().equals(
                  other.recoveryCode,
                  recoveryCode,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(mfaToken) ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(recoveryCode) ^
      runtimeType.hashCode;
}

extension $MfaVerifyRequestExtension on MfaVerifyRequest {
  MfaVerifyRequest copyWith({
    String? mfaToken,
    String? code,
    String? recoveryCode,
  }) {
    return MfaVerifyRequest(
      mfaToken: mfaToken ?? this.mfaToken,
      code: code ?? this.code,
      recoveryCode: recoveryCode ?? this.recoveryCode,
    );
  }

  MfaVerifyRequest copyWithWrapped({
    Wrapped<String>? mfaToken,
    Wrapped<String?>? code,
    Wrapped<String?>? recoveryCode,
  }) {
    return MfaVerifyRequest(
      mfaToken: (mfaToken != null ? mfaToken.value : this.mfaToken),
      code: (code != null ? code.value : this.code),
      recoveryCode: (recoveryCode != null
          ? recoveryCode.value
          : this.recoveryCode),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PageProjectRead {
  const PageProjectRead({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory PageProjectRead.fromJson(Map<String, dynamic> json) =>
      _$PageProjectReadFromJson(json);

  static const toJsonFactory = _$PageProjectReadToJson;
  Map<String, dynamic> toJson() => _$PageProjectReadToJson(this);

  @JsonKey(name: 'items', defaultValue: <ProjectRead>[])
  final List<ProjectRead> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;
  static const fromJsonFactory = _$PageProjectReadFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PageProjectRead &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.page, page) ||
                const DeepCollectionEquality().equals(other.page, page)) &&
            (identical(other.pageSize, pageSize) ||
                const DeepCollectionEquality().equals(
                  other.pageSize,
                  pageSize,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(page) ^
      const DeepCollectionEquality().hash(pageSize) ^
      runtimeType.hashCode;
}

extension $PageProjectReadExtension on PageProjectRead {
  PageProjectRead copyWith({
    List<ProjectRead>? items,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return PageProjectRead(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  PageProjectRead copyWithWrapped({
    Wrapped<List<ProjectRead>>? items,
    Wrapped<int>? total,
    Wrapped<int>? page,
    Wrapped<int>? pageSize,
  }) {
    return PageProjectRead(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      page: (page != null ? page.value : this.page),
      pageSize: (pageSize != null ? pageSize.value : this.pageSize),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PageUserRead {
  const PageUserRead({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory PageUserRead.fromJson(Map<String, dynamic> json) =>
      _$PageUserReadFromJson(json);

  static const toJsonFactory = _$PageUserReadToJson;
  Map<String, dynamic> toJson() => _$PageUserReadToJson(this);

  @JsonKey(name: 'items', defaultValue: <UserRead>[])
  final List<UserRead> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;
  static const fromJsonFactory = _$PageUserReadFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PageUserRead &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.page, page) ||
                const DeepCollectionEquality().equals(other.page, page)) &&
            (identical(other.pageSize, pageSize) ||
                const DeepCollectionEquality().equals(
                  other.pageSize,
                  pageSize,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(page) ^
      const DeepCollectionEquality().hash(pageSize) ^
      runtimeType.hashCode;
}

extension $PageUserReadExtension on PageUserRead {
  PageUserRead copyWith({
    List<UserRead>? items,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return PageUserRead(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  PageUserRead copyWithWrapped({
    Wrapped<List<UserRead>>? items,
    Wrapped<int>? total,
    Wrapped<int>? page,
    Wrapped<int>? pageSize,
  }) {
    return PageUserRead(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      page: (page != null ? page.value : this.page),
      pageSize: (pageSize != null ? pageSize.value : this.pageSize),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectCreate {
  const ProjectCreate({
    required this.name,
    this.description,
    this.status,
    this.tags,
    this.startDate,
    this.endDate,
    this.metadata,
  });

  factory ProjectCreate.fromJson(Map<String, dynamic> json) =>
      _$ProjectCreateFromJson(json);

  static const toJsonFactory = _$ProjectCreateToJson;
  Map<String, dynamic> toJson() => _$ProjectCreateToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(
    name: 'status',
    toJson: projectStatusNullableToJson,
    fromJson: projectStatusStatusNullableFromJson,
  )
  final enums.ProjectStatus? status;
  static enums.ProjectStatus? projectStatusStatusNullableFromJson(
    Object? value,
  ) => projectStatusNullableFromJson(value, enums.ProjectStatus.draft);

  @JsonKey(name: 'tags', defaultValue: <String>[])
  final List<String>? tags;
  @JsonKey(name: 'start_date', toJson: _dateToJson)
  final DateTime? startDate;
  @JsonKey(name: 'end_date', toJson: _dateToJson)
  final DateTime? endDate;
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;
  static const fromJsonFactory = _$ProjectCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProjectCreate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.startDate, startDate) ||
                const DeepCollectionEquality().equals(
                  other.startDate,
                  startDate,
                )) &&
            (identical(other.endDate, endDate) ||
                const DeepCollectionEquality().equals(
                  other.endDate,
                  endDate,
                )) &&
            (identical(other.metadata, metadata) ||
                const DeepCollectionEquality().equals(
                  other.metadata,
                  metadata,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(startDate) ^
      const DeepCollectionEquality().hash(endDate) ^
      const DeepCollectionEquality().hash(metadata) ^
      runtimeType.hashCode;
}

extension $ProjectCreateExtension on ProjectCreate {
  ProjectCreate copyWith({
    String? name,
    String? description,
    enums.ProjectStatus? status,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectCreate(
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      metadata: metadata ?? this.metadata,
    );
  }

  ProjectCreate copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<enums.ProjectStatus?>? status,
    Wrapped<List<String>?>? tags,
    Wrapped<DateTime?>? startDate,
    Wrapped<DateTime?>? endDate,
    Wrapped<Map<String, dynamic>?>? metadata,
  }) {
    return ProjectCreate(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      status: (status != null ? status.value : this.status),
      tags: (tags != null ? tags.value : this.tags),
      startDate: (startDate != null ? startDate.value : this.startDate),
      endDate: (endDate != null ? endDate.value : this.endDate),
      metadata: (metadata != null ? metadata.value : this.metadata),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectRead {
  const ProjectRead({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.status,
    required this.tags,
    required this.startDate,
    required this.endDate,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectRead.fromJson(Map<String, dynamic> json) =>
      _$ProjectReadFromJson(json);

  static const toJsonFactory = _$ProjectReadToJson;
  Map<String, dynamic> toJson() => _$ProjectReadToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(
    name: 'status',
    toJson: projectStatusToJson,
    fromJson: projectStatusFromJson,
  )
  final enums.ProjectStatus status;
  @JsonKey(name: 'tags', defaultValue: <String>[])
  final List<String> tags;
  @JsonKey(name: 'start_date', toJson: _dateToJson)
  final DateTime? startDate;
  @JsonKey(name: 'end_date', toJson: _dateToJson)
  final DateTime? endDate;
  @JsonKey(name: 'metadata')
  final Map<String, dynamic> metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  static const fromJsonFactory = _$ProjectReadFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProjectRead &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality().equals(
                  other.ownerId,
                  ownerId,
                )) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.startDate, startDate) ||
                const DeepCollectionEquality().equals(
                  other.startDate,
                  startDate,
                )) &&
            (identical(other.endDate, endDate) ||
                const DeepCollectionEquality().equals(
                  other.endDate,
                  endDate,
                )) &&
            (identical(other.metadata, metadata) ||
                const DeepCollectionEquality().equals(
                  other.metadata,
                  metadata,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(startDate) ^
      const DeepCollectionEquality().hash(endDate) ^
      const DeepCollectionEquality().hash(metadata) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $ProjectReadExtension on ProjectRead {
  ProjectRead copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    enums.ProjectStatus? status,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectRead(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ProjectRead copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? ownerId,
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<enums.ProjectStatus>? status,
    Wrapped<List<String>>? tags,
    Wrapped<DateTime?>? startDate,
    Wrapped<DateTime?>? endDate,
    Wrapped<Map<String, dynamic>>? metadata,
    Wrapped<DateTime>? createdAt,
    Wrapped<DateTime>? updatedAt,
  }) {
    return ProjectRead(
      id: (id != null ? id.value : this.id),
      ownerId: (ownerId != null ? ownerId.value : this.ownerId),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      status: (status != null ? status.value : this.status),
      tags: (tags != null ? tags.value : this.tags),
      startDate: (startDate != null ? startDate.value : this.startDate),
      endDate: (endDate != null ? endDate.value : this.endDate),
      metadata: (metadata != null ? metadata.value : this.metadata),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectUpdate {
  const ProjectUpdate({
    this.name,
    this.description,
    this.status,
    this.tags,
    this.startDate,
    this.endDate,
    this.metadata,
  });

  factory ProjectUpdate.fromJson(Map<String, dynamic> json) =>
      _$ProjectUpdateFromJson(json);

  static const toJsonFactory = _$ProjectUpdateToJson;
  Map<String, dynamic> toJson() => _$ProjectUpdateToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(
    name: 'status',
    toJson: projectStatusNullableToJson,
    fromJson: projectStatusNullableFromJson,
  )
  final enums.ProjectStatus? status;
  @JsonKey(name: 'tags')
  final ListString? tags;
  @JsonKey(name: 'start_date', toJson: _dateToJson)
  final DateTime? startDate;
  @JsonKey(name: 'end_date', toJson: _dateToJson)
  final DateTime? endDate;
  @JsonKey(name: 'metadata')
  final Object? metadata;
  static const fromJsonFactory = _$ProjectUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProjectUpdate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.startDate, startDate) ||
                const DeepCollectionEquality().equals(
                  other.startDate,
                  startDate,
                )) &&
            (identical(other.endDate, endDate) ||
                const DeepCollectionEquality().equals(
                  other.endDate,
                  endDate,
                )) &&
            (identical(other.metadata, metadata) ||
                const DeepCollectionEquality().equals(
                  other.metadata,
                  metadata,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(startDate) ^
      const DeepCollectionEquality().hash(endDate) ^
      const DeepCollectionEquality().hash(metadata) ^
      runtimeType.hashCode;
}

extension $ProjectUpdateExtension on ProjectUpdate {
  ProjectUpdate copyWith({
    String? name,
    String? description,
    enums.ProjectStatus? status,
    ListString? tags,
    DateTime? startDate,
    DateTime? endDate,
    Object? metadata,
  }) {
    return ProjectUpdate(
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      metadata: metadata ?? this.metadata,
    );
  }

  ProjectUpdate copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<enums.ProjectStatus?>? status,
    Wrapped<ListString?>? tags,
    Wrapped<DateTime?>? startDate,
    Wrapped<DateTime?>? endDate,
    Wrapped<Object?>? metadata,
  }) {
    return ProjectUpdate(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      status: (status != null ? status.value : this.status),
      tags: (tags != null ? tags.value : this.tags),
      startDate: (startDate != null ? startDate.value : this.startDate),
      endDate: (endDate != null ? endDate.value : this.endDate),
      metadata: (metadata != null ? metadata.value : this.metadata),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ReauthRequest {
  const ReauthRequest({this.password, this.code});

  factory ReauthRequest.fromJson(Map<String, dynamic> json) =>
      _$ReauthRequestFromJson(json);

  static const toJsonFactory = _$ReauthRequestToJson;
  Map<String, dynamic> toJson() => _$ReauthRequestToJson(this);

  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'code')
  final String? code;
  static const fromJsonFactory = _$ReauthRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ReauthRequest &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(code) ^
      runtimeType.hashCode;
}

extension $ReauthRequestExtension on ReauthRequest {
  ReauthRequest copyWith({String? password, String? code}) {
    return ReauthRequest(
      password: password ?? this.password,
      code: code ?? this.code,
    );
  }

  ReauthRequest copyWithWrapped({
    Wrapped<String?>? password,
    Wrapped<String?>? code,
  }) {
    return ReauthRequest(
      password: (password != null ? password.value : this.password),
      code: (code != null ? code.value : this.code),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RecoveryCodesResponse {
  const RecoveryCodesResponse({required this.recoveryCodes});

  factory RecoveryCodesResponse.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCodesResponseFromJson(json);

  static const toJsonFactory = _$RecoveryCodesResponseToJson;
  Map<String, dynamic> toJson() => _$RecoveryCodesResponseToJson(this);

  @JsonKey(name: 'recovery_codes', defaultValue: <String>[])
  final List<String> recoveryCodes;
  static const fromJsonFactory = _$RecoveryCodesResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RecoveryCodesResponse &&
            (identical(other.recoveryCodes, recoveryCodes) ||
                const DeepCollectionEquality().equals(
                  other.recoveryCodes,
                  recoveryCodes,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(recoveryCodes) ^ runtimeType.hashCode;
}

extension $RecoveryCodesResponseExtension on RecoveryCodesResponse {
  RecoveryCodesResponse copyWith({List<String>? recoveryCodes}) {
    return RecoveryCodesResponse(
      recoveryCodes: recoveryCodes ?? this.recoveryCodes,
    );
  }

  RecoveryCodesResponse copyWithWrapped({
    Wrapped<List<String>>? recoveryCodes,
  }) {
    return RecoveryCodesResponse(
      recoveryCodes: (recoveryCodes != null
          ? recoveryCodes.value
          : this.recoveryCodes),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RefreshRequest {
  const RefreshRequest({this.refreshToken});

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);

  static const toJsonFactory = _$RefreshRequestToJson;
  Map<String, dynamic> toJson() => _$RefreshRequestToJson(this);

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  static const fromJsonFactory = _$RefreshRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RefreshRequest &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(refreshToken) ^ runtimeType.hashCode;
}

extension $RefreshRequestExtension on RefreshRequest {
  RefreshRequest copyWith({String? refreshToken}) {
    return RefreshRequest(refreshToken: refreshToken ?? this.refreshToken);
  }

  RefreshRequest copyWithWrapped({Wrapped<String?>? refreshToken}) {
    return RefreshRequest(
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
    this.mfaCode,
    this.recoveryCode,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  static const toJsonFactory = _$ResetPasswordRequestToJson;
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'new_password')
  final String newPassword;
  @JsonKey(name: 'mfa_code')
  final String? mfaCode;
  @JsonKey(name: 'recovery_code')
  final String? recoveryCode;
  static const fromJsonFactory = _$ResetPasswordRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ResetPasswordRequest &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.newPassword, newPassword) ||
                const DeepCollectionEquality().equals(
                  other.newPassword,
                  newPassword,
                )) &&
            (identical(other.mfaCode, mfaCode) ||
                const DeepCollectionEquality().equals(
                  other.mfaCode,
                  mfaCode,
                )) &&
            (identical(other.recoveryCode, recoveryCode) ||
                const DeepCollectionEquality().equals(
                  other.recoveryCode,
                  recoveryCode,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(newPassword) ^
      const DeepCollectionEquality().hash(mfaCode) ^
      const DeepCollectionEquality().hash(recoveryCode) ^
      runtimeType.hashCode;
}

extension $ResetPasswordRequestExtension on ResetPasswordRequest {
  ResetPasswordRequest copyWith({
    String? token,
    String? newPassword,
    String? mfaCode,
    String? recoveryCode,
  }) {
    return ResetPasswordRequest(
      token: token ?? this.token,
      newPassword: newPassword ?? this.newPassword,
      mfaCode: mfaCode ?? this.mfaCode,
      recoveryCode: recoveryCode ?? this.recoveryCode,
    );
  }

  ResetPasswordRequest copyWithWrapped({
    Wrapped<String>? token,
    Wrapped<String>? newPassword,
    Wrapped<String?>? mfaCode,
    Wrapped<String?>? recoveryCode,
  }) {
    return ResetPasswordRequest(
      token: (token != null ? token.value : this.token),
      newPassword: (newPassword != null ? newPassword.value : this.newPassword),
      mfaCode: (mfaCode != null ? mfaCode.value : this.mfaCode),
      recoveryCode: (recoveryCode != null
          ? recoveryCode.value
          : this.recoveryCode),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class SessionRead {
  const SessionRead({
    required this.id,
    required this.startedAt,
    required this.lastUsedAt,
    required this.expiresAt,
    required this.ip,
    required this.userAgent,
    required this.current,
  });

  factory SessionRead.fromJson(Map<String, dynamic> json) =>
      _$SessionReadFromJson(json);

  static const toJsonFactory = _$SessionReadToJson;
  Map<String, dynamic> toJson() => _$SessionReadToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @JsonKey(name: 'last_used_at')
  final DateTime lastUsedAt;
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @JsonKey(name: 'ip')
  final String? ip;
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @JsonKey(name: 'current')
  final bool current;
  static const fromJsonFactory = _$SessionReadFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SessionRead &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                const DeepCollectionEquality().equals(
                  other.lastUsedAt,
                  lastUsedAt,
                )) &&
            (identical(other.expiresAt, expiresAt) ||
                const DeepCollectionEquality().equals(
                  other.expiresAt,
                  expiresAt,
                )) &&
            (identical(other.ip, ip) ||
                const DeepCollectionEquality().equals(other.ip, ip)) &&
            (identical(other.userAgent, userAgent) ||
                const DeepCollectionEquality().equals(
                  other.userAgent,
                  userAgent,
                )) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality().equals(other.current, current)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(lastUsedAt) ^
      const DeepCollectionEquality().hash(expiresAt) ^
      const DeepCollectionEquality().hash(ip) ^
      const DeepCollectionEquality().hash(userAgent) ^
      const DeepCollectionEquality().hash(current) ^
      runtimeType.hashCode;
}

extension $SessionReadExtension on SessionRead {
  SessionRead copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    String? ip,
    String? userAgent,
    bool? current,
  }) {
    return SessionRead(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      ip: ip ?? this.ip,
      userAgent: userAgent ?? this.userAgent,
      current: current ?? this.current,
    );
  }

  SessionRead copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<DateTime>? startedAt,
    Wrapped<DateTime>? lastUsedAt,
    Wrapped<DateTime>? expiresAt,
    Wrapped<String?>? ip,
    Wrapped<String?>? userAgent,
    Wrapped<bool>? current,
  }) {
    return SessionRead(
      id: (id != null ? id.value : this.id),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      lastUsedAt: (lastUsedAt != null ? lastUsedAt.value : this.lastUsedAt),
      expiresAt: (expiresAt != null ? expiresAt.value : this.expiresAt),
      ip: (ip != null ? ip.value : this.ip),
      userAgent: (userAgent != null ? userAgent.value : this.userAgent),
      current: (current != null ? current.value : this.current),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class SetPasswordRequest {
  const SetPasswordRequest({required this.newPassword});

  factory SetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$SetPasswordRequestFromJson(json);

  static const toJsonFactory = _$SetPasswordRequestToJson;
  Map<String, dynamic> toJson() => _$SetPasswordRequestToJson(this);

  @JsonKey(name: 'new_password')
  final String newPassword;
  static const fromJsonFactory = _$SetPasswordRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SetPasswordRequest &&
            (identical(other.newPassword, newPassword) ||
                const DeepCollectionEquality().equals(
                  other.newPassword,
                  newPassword,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(newPassword) ^ runtimeType.hashCode;
}

extension $SetPasswordRequestExtension on SetPasswordRequest {
  SetPasswordRequest copyWith({String? newPassword}) {
    return SetPasswordRequest(newPassword: newPassword ?? this.newPassword);
  }

  SetPasswordRequest copyWithWrapped({Wrapped<String>? newPassword}) {
    return SetPasswordRequest(
      newPassword: (newPassword != null ? newPassword.value : this.newPassword),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class SignupRequest {
  const SignupRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.acceptTerms,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  static const toJsonFactory = _$SignupRequestToJson;
  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'accept_terms')
  final bool acceptTerms;
  static const fromJsonFactory = _$SignupRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SignupRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.acceptTerms, acceptTerms) ||
                const DeepCollectionEquality().equals(
                  other.acceptTerms,
                  acceptTerms,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(acceptTerms) ^
      runtimeType.hashCode;
}

extension $SignupRequestExtension on SignupRequest {
  SignupRequest copyWith({
    String? email,
    String? password,
    String? fullName,
    bool? acceptTerms,
  }) {
    return SignupRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }

  SignupRequest copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
    Wrapped<String>? fullName,
    Wrapped<bool>? acceptTerms,
  }) {
    return SignupRequest(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
      fullName: (fullName != null ? fullName.value : this.fullName),
      acceptTerms: (acceptTerms != null ? acceptTerms.value : this.acceptTerms),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class SignupResponse {
  const SignupResponse({
    required this.id,
    required this.email,
    required this.fullName,
    required this.emailVerified,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);

  static const toJsonFactory = _$SignupResponseToJson;
  Map<String, dynamic> toJson() => _$SignupResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  static const fromJsonFactory = _$SignupResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SignupResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.emailVerified, emailVerified) ||
                const DeepCollectionEquality().equals(
                  other.emailVerified,
                  emailVerified,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(emailVerified) ^
      runtimeType.hashCode;
}

extension $SignupResponseExtension on SignupResponse {
  SignupResponse copyWith({
    String? id,
    String? email,
    String? fullName,
    bool? emailVerified,
  }) {
    return SignupResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  SignupResponse copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? email,
    Wrapped<String>? fullName,
    Wrapped<bool>? emailVerified,
  }) {
    return SignupResponse(
      id: (id != null ? id.value : this.id),
      email: (email != null ? email.value : this.email),
      fullName: (fullName != null ? fullName.value : this.fullName),
      emailVerified: (emailVerified != null
          ? emailVerified.value
          : this.emailVerified),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TokenRequest {
  const TokenRequest({required this.token});

  factory TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestFromJson(json);

  static const toJsonFactory = _$TokenRequestToJson;
  Map<String, dynamic> toJson() => _$TokenRequestToJson(this);

  @JsonKey(name: 'token')
  final String token;
  static const fromJsonFactory = _$TokenRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TokenRequest &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(token) ^ runtimeType.hashCode;
}

extension $TokenRequestExtension on TokenRequest {
  TokenRequest copyWith({String? token}) {
    return TokenRequest(token: token ?? this.token);
  }

  TokenRequest copyWithWrapped({Wrapped<String>? token}) {
    return TokenRequest(token: (token != null ? token.value : this.token));
  }
}

@JsonSerializable(explicitToJson: true)
class TokenResponse {
  const TokenResponse({
    required this.accessToken,
    this.tokenType,
    required this.expiresIn,
    this.refreshToken,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  static const toJsonFactory = _$TokenResponseToJson;
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  static const fromJsonFactory = _$TokenResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TokenResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.tokenType, tokenType) ||
                const DeepCollectionEquality().equals(
                  other.tokenType,
                  tokenType,
                )) &&
            (identical(other.expiresIn, expiresIn) ||
                const DeepCollectionEquality().equals(
                  other.expiresIn,
                  expiresIn,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(tokenType) ^
      const DeepCollectionEquality().hash(expiresIn) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      runtimeType.hashCode;
}

extension $TokenResponseExtension on TokenResponse {
  TokenResponse copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
  }) {
    return TokenResponse(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  TokenResponse copyWithWrapped({
    Wrapped<String>? accessToken,
    Wrapped<String?>? tokenType,
    Wrapped<int>? expiresIn,
    Wrapped<String?>? refreshToken,
  }) {
    return TokenResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      tokenType: (tokenType != null ? tokenType.value : this.tokenType),
      expiresIn: (expiresIn != null ? expiresIn.value : this.expiresIn),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TotpCodeRequest {
  const TotpCodeRequest({required this.code});

  factory TotpCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$TotpCodeRequestFromJson(json);

  static const toJsonFactory = _$TotpCodeRequestToJson;
  Map<String, dynamic> toJson() => _$TotpCodeRequestToJson(this);

  @JsonKey(name: 'code')
  final String code;
  static const fromJsonFactory = _$TotpCodeRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TotpCodeRequest &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(code) ^ runtimeType.hashCode;
}

extension $TotpCodeRequestExtension on TotpCodeRequest {
  TotpCodeRequest copyWith({String? code}) {
    return TotpCodeRequest(code: code ?? this.code);
  }

  TotpCodeRequest copyWithWrapped({Wrapped<String>? code}) {
    return TotpCodeRequest(code: (code != null ? code.value : this.code));
  }
}

@JsonSerializable(explicitToJson: true)
class TotpSetupResponse {
  const TotpSetupResponse({required this.secret, required this.otpauthUri});

  factory TotpSetupResponse.fromJson(Map<String, dynamic> json) =>
      _$TotpSetupResponseFromJson(json);

  static const toJsonFactory = _$TotpSetupResponseToJson;
  Map<String, dynamic> toJson() => _$TotpSetupResponseToJson(this);

  @JsonKey(name: 'secret')
  final String secret;
  @JsonKey(name: 'otpauth_uri')
  final String otpauthUri;
  static const fromJsonFactory = _$TotpSetupResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TotpSetupResponse &&
            (identical(other.secret, secret) ||
                const DeepCollectionEquality().equals(other.secret, secret)) &&
            (identical(other.otpauthUri, otpauthUri) ||
                const DeepCollectionEquality().equals(
                  other.otpauthUri,
                  otpauthUri,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(secret) ^
      const DeepCollectionEquality().hash(otpauthUri) ^
      runtimeType.hashCode;
}

extension $TotpSetupResponseExtension on TotpSetupResponse {
  TotpSetupResponse copyWith({String? secret, String? otpauthUri}) {
    return TotpSetupResponse(
      secret: secret ?? this.secret,
      otpauthUri: otpauthUri ?? this.otpauthUri,
    );
  }

  TotpSetupResponse copyWithWrapped({
    Wrapped<String>? secret,
    Wrapped<String>? otpauthUri,
  }) {
    return TotpSetupResponse(
      secret: (secret != null ? secret.value : this.secret),
      otpauthUri: (otpauthUri != null ? otpauthUri.value : this.otpauthUri),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserRead {
  const UserRead({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.role,
    required this.status,
    required this.emailVerified,
    required this.mfaEnabled,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserRead.fromJson(Map<String, dynamic> json) =>
      _$UserReadFromJson(json);

  static const toJsonFactory = _$UserReadToJson;
  Map<String, dynamic> toJson() => _$UserReadToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'role', toJson: userRoleToJson, fromJson: userRoleFromJson)
  final enums.UserRole role;
  @JsonKey(
    name: 'status',
    toJson: userStatusToJson,
    fromJson: userStatusFromJson,
  )
  final enums.UserStatus status;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'mfa_enabled')
  final bool mfaEnabled;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  static const fromJsonFactory = _$UserReadFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserRead &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.avatarUrl, avatarUrl) ||
                const DeepCollectionEquality().equals(
                  other.avatarUrl,
                  avatarUrl,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.emailVerified, emailVerified) ||
                const DeepCollectionEquality().equals(
                  other.emailVerified,
                  emailVerified,
                )) &&
            (identical(other.mfaEnabled, mfaEnabled) ||
                const DeepCollectionEquality().equals(
                  other.mfaEnabled,
                  mfaEnabled,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                const DeepCollectionEquality().equals(
                  other.lastLoginAt,
                  lastLoginAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(avatarUrl) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(emailVerified) ^
      const DeepCollectionEquality().hash(mfaEnabled) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(lastLoginAt) ^
      runtimeType.hashCode;
}

extension $UserReadExtension on UserRead {
  UserRead copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    enums.UserRole? role,
    enums.UserStatus? status,
    bool? emailVerified,
    bool? mfaEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserRead(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  UserRead copyWithWrapped({
    Wrapped<String>? id,
    Wrapped<String>? email,
    Wrapped<String>? fullName,
    Wrapped<String?>? avatarUrl,
    Wrapped<enums.UserRole>? role,
    Wrapped<enums.UserStatus>? status,
    Wrapped<bool>? emailVerified,
    Wrapped<bool>? mfaEnabled,
    Wrapped<DateTime>? createdAt,
    Wrapped<DateTime?>? lastLoginAt,
  }) {
    return UserRead(
      id: (id != null ? id.value : this.id),
      email: (email != null ? email.value : this.email),
      fullName: (fullName != null ? fullName.value : this.fullName),
      avatarUrl: (avatarUrl != null ? avatarUrl.value : this.avatarUrl),
      role: (role != null ? role.value : this.role),
      status: (status != null ? status.value : this.status),
      emailVerified: (emailVerified != null
          ? emailVerified.value
          : this.emailVerified),
      mfaEnabled: (mfaEnabled != null ? mfaEnabled.value : this.mfaEnabled),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      lastLoginAt: (lastLoginAt != null ? lastLoginAt.value : this.lastLoginAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserUpdateMe {
  const UserUpdateMe({this.fullName, this.avatarUrl});

  factory UserUpdateMe.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateMeFromJson(json);

  static const toJsonFactory = _$UserUpdateMeToJson;
  Map<String, dynamic> toJson() => _$UserUpdateMeToJson(this);

  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  static const fromJsonFactory = _$UserUpdateMeFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserUpdateMe &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality().equals(
                  other.fullName,
                  fullName,
                )) &&
            (identical(other.avatarUrl, avatarUrl) ||
                const DeepCollectionEquality().equals(
                  other.avatarUrl,
                  avatarUrl,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(avatarUrl) ^
      runtimeType.hashCode;
}

extension $UserUpdateMeExtension on UserUpdateMe {
  UserUpdateMe copyWith({String? fullName, String? avatarUrl}) {
    return UserUpdateMe(
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  UserUpdateMe copyWithWrapped({
    Wrapped<String?>? fullName,
    Wrapped<String?>? avatarUrl,
  }) {
    return UserUpdateMe(
      fullName: (fullName != null ? fullName.value : this.fullName),
      avatarUrl: (avatarUrl != null ? avatarUrl.value : this.avatarUrl),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
    this.input,
    this.ctx,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'loc', defaultValue: <Object>[])
  final List<Object> loc;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'input')
  final dynamic input;
  @JsonKey(name: 'ctx')
  final Object? ctx;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.input, input) ||
                const DeepCollectionEquality().equals(other.input, input)) &&
            (identical(other.ctx, ctx) ||
                const DeepCollectionEquality().equals(other.ctx, ctx)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(input) ^
      const DeepCollectionEquality().hash(ctx) ^
      runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith({
    List<Object>? loc,
    String? msg,
    String? type,
    dynamic input,
    Object? ctx,
  }) {
    return ValidationError(
      loc: loc ?? this.loc,
      msg: msg ?? this.msg,
      type: type ?? this.type,
      input: input ?? this.input,
      ctx: ctx ?? this.ctx,
    );
  }

  ValidationError copyWithWrapped({
    Wrapped<List<Object>>? loc,
    Wrapped<String>? msg,
    Wrapped<String>? type,
    Wrapped<dynamic>? input,
    Wrapped<Object?>? ctx,
  }) {
    return ValidationError(
      loc: (loc != null ? loc.value : this.loc),
      msg: (msg != null ? msg.value : this.msg),
      type: (type != null ? type.value : this.type),
      input: (input != null ? input.value : this.input),
      ctx: (ctx != null ? ctx.value : this.ctx),
    );
  }
}

String? projectStatusNullableToJson(enums.ProjectStatus? projectStatus) {
  return projectStatus?.value;
}

String? projectStatusToJson(enums.ProjectStatus projectStatus) {
  return projectStatus.value;
}

enums.ProjectStatus projectStatusFromJson(
  Object? projectStatus, [
  enums.ProjectStatus? defaultValue,
]) {
  return enums.ProjectStatus.values.firstWhereOrNull(
        (e) => e.value == projectStatus,
      ) ??
      defaultValue ??
      enums.ProjectStatus.swaggerGeneratedUnknown;
}

enums.ProjectStatus? projectStatusNullableFromJson(
  Object? projectStatus, [
  enums.ProjectStatus? defaultValue,
]) {
  if (projectStatus == null) {
    return null;
  }
  return enums.ProjectStatus.values.firstWhereOrNull(
        (e) => e.value == projectStatus,
      ) ??
      defaultValue;
}

String projectStatusExplodedListToJson(
  List<enums.ProjectStatus>? projectStatus,
) {
  return projectStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> projectStatusListToJson(List<enums.ProjectStatus>? projectStatus) {
  if (projectStatus == null) {
    return [];
  }

  return projectStatus.map((e) => e.value!).toList();
}

List<enums.ProjectStatus> projectStatusListFromJson(
  List? projectStatus, [
  List<enums.ProjectStatus>? defaultValue,
]) {
  if (projectStatus == null) {
    return defaultValue ?? [];
  }

  return projectStatus.map((e) => projectStatusFromJson(e.toString())).toList();
}

List<enums.ProjectStatus>? projectStatusNullableListFromJson(
  List? projectStatus, [
  List<enums.ProjectStatus>? defaultValue,
]) {
  if (projectStatus == null) {
    return defaultValue;
  }

  return projectStatus.map((e) => projectStatusFromJson(e.toString())).toList();
}

String? userRoleNullableToJson(enums.UserRole? userRole) {
  return userRole?.value;
}

String? userRoleToJson(enums.UserRole userRole) {
  return userRole.value;
}

enums.UserRole userRoleFromJson(
  Object? userRole, [
  enums.UserRole? defaultValue,
]) {
  return enums.UserRole.values.firstWhereOrNull((e) => e.value == userRole) ??
      defaultValue ??
      enums.UserRole.swaggerGeneratedUnknown;
}

enums.UserRole? userRoleNullableFromJson(
  Object? userRole, [
  enums.UserRole? defaultValue,
]) {
  if (userRole == null) {
    return null;
  }
  return enums.UserRole.values.firstWhereOrNull((e) => e.value == userRole) ??
      defaultValue;
}

String userRoleExplodedListToJson(List<enums.UserRole>? userRole) {
  return userRole?.map((e) => e.value!).join(',') ?? '';
}

List<String> userRoleListToJson(List<enums.UserRole>? userRole) {
  if (userRole == null) {
    return [];
  }

  return userRole.map((e) => e.value!).toList();
}

List<enums.UserRole> userRoleListFromJson(
  List? userRole, [
  List<enums.UserRole>? defaultValue,
]) {
  if (userRole == null) {
    return defaultValue ?? [];
  }

  return userRole.map((e) => userRoleFromJson(e.toString())).toList();
}

List<enums.UserRole>? userRoleNullableListFromJson(
  List? userRole, [
  List<enums.UserRole>? defaultValue,
]) {
  if (userRole == null) {
    return defaultValue;
  }

  return userRole.map((e) => userRoleFromJson(e.toString())).toList();
}

String? userStatusNullableToJson(enums.UserStatus? userStatus) {
  return userStatus?.value;
}

String? userStatusToJson(enums.UserStatus userStatus) {
  return userStatus.value;
}

enums.UserStatus userStatusFromJson(
  Object? userStatus, [
  enums.UserStatus? defaultValue,
]) {
  return enums.UserStatus.values.firstWhereOrNull(
        (e) => e.value == userStatus,
      ) ??
      defaultValue ??
      enums.UserStatus.swaggerGeneratedUnknown;
}

enums.UserStatus? userStatusNullableFromJson(
  Object? userStatus, [
  enums.UserStatus? defaultValue,
]) {
  if (userStatus == null) {
    return null;
  }
  return enums.UserStatus.values.firstWhereOrNull(
        (e) => e.value == userStatus,
      ) ??
      defaultValue;
}

String userStatusExplodedListToJson(List<enums.UserStatus>? userStatus) {
  return userStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> userStatusListToJson(List<enums.UserStatus>? userStatus) {
  if (userStatus == null) {
    return [];
  }

  return userStatus.map((e) => e.value!).toList();
}

List<enums.UserStatus> userStatusListFromJson(
  List? userStatus, [
  List<enums.UserStatus>? defaultValue,
]) {
  if (userStatus == null) {
    return defaultValue ?? [];
  }

  return userStatus.map((e) => userStatusFromJson(e.toString())).toList();
}

List<enums.UserStatus>? userStatusNullableListFromJson(
  List? userStatus, [
  List<enums.UserStatus>? defaultValue,
]) {
  if (userStatus == null) {
    return defaultValue;
  }

  return userStatus.map((e) => userStatusFromJson(e.toString())).toList();
}

String? apiV1UsersGetSortNullableToJson(
  enums.ApiV1UsersGetSort? apiV1UsersGetSort,
) {
  return apiV1UsersGetSort?.value;
}

String? apiV1UsersGetSortToJson(enums.ApiV1UsersGetSort apiV1UsersGetSort) {
  return apiV1UsersGetSort.value;
}

enums.ApiV1UsersGetSort apiV1UsersGetSortFromJson(
  Object? apiV1UsersGetSort, [
  enums.ApiV1UsersGetSort? defaultValue,
]) {
  return enums.ApiV1UsersGetSort.values.firstWhereOrNull(
        (e) => e.value == apiV1UsersGetSort,
      ) ??
      defaultValue ??
      enums.ApiV1UsersGetSort.swaggerGeneratedUnknown;
}

enums.ApiV1UsersGetSort? apiV1UsersGetSortNullableFromJson(
  Object? apiV1UsersGetSort, [
  enums.ApiV1UsersGetSort? defaultValue,
]) {
  if (apiV1UsersGetSort == null) {
    return null;
  }
  return enums.ApiV1UsersGetSort.values.firstWhereOrNull(
        (e) => e.value == apiV1UsersGetSort,
      ) ??
      defaultValue;
}

String apiV1UsersGetSortExplodedListToJson(
  List<enums.ApiV1UsersGetSort>? apiV1UsersGetSort,
) {
  return apiV1UsersGetSort?.map((e) => e.value!).join(',') ?? '';
}

List<String> apiV1UsersGetSortListToJson(
  List<enums.ApiV1UsersGetSort>? apiV1UsersGetSort,
) {
  if (apiV1UsersGetSort == null) {
    return [];
  }

  return apiV1UsersGetSort.map((e) => e.value!).toList();
}

List<enums.ApiV1UsersGetSort> apiV1UsersGetSortListFromJson(
  List? apiV1UsersGetSort, [
  List<enums.ApiV1UsersGetSort>? defaultValue,
]) {
  if (apiV1UsersGetSort == null) {
    return defaultValue ?? [];
  }

  return apiV1UsersGetSort
      .map((e) => apiV1UsersGetSortFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1UsersGetSort>? apiV1UsersGetSortNullableListFromJson(
  List? apiV1UsersGetSort, [
  List<enums.ApiV1UsersGetSort>? defaultValue,
]) {
  if (apiV1UsersGetSort == null) {
    return defaultValue;
  }

  return apiV1UsersGetSort
      .map((e) => apiV1UsersGetSortFromJson(e.toString()))
      .toList();
}

String? apiV1ProjectsGetSortNullableToJson(
  enums.ApiV1ProjectsGetSort? apiV1ProjectsGetSort,
) {
  return apiV1ProjectsGetSort?.value;
}

String? apiV1ProjectsGetSortToJson(
  enums.ApiV1ProjectsGetSort apiV1ProjectsGetSort,
) {
  return apiV1ProjectsGetSort.value;
}

enums.ApiV1ProjectsGetSort apiV1ProjectsGetSortFromJson(
  Object? apiV1ProjectsGetSort, [
  enums.ApiV1ProjectsGetSort? defaultValue,
]) {
  return enums.ApiV1ProjectsGetSort.values.firstWhereOrNull(
        (e) => e.value == apiV1ProjectsGetSort,
      ) ??
      defaultValue ??
      enums.ApiV1ProjectsGetSort.swaggerGeneratedUnknown;
}

enums.ApiV1ProjectsGetSort? apiV1ProjectsGetSortNullableFromJson(
  Object? apiV1ProjectsGetSort, [
  enums.ApiV1ProjectsGetSort? defaultValue,
]) {
  if (apiV1ProjectsGetSort == null) {
    return null;
  }
  return enums.ApiV1ProjectsGetSort.values.firstWhereOrNull(
        (e) => e.value == apiV1ProjectsGetSort,
      ) ??
      defaultValue;
}

String apiV1ProjectsGetSortExplodedListToJson(
  List<enums.ApiV1ProjectsGetSort>? apiV1ProjectsGetSort,
) {
  return apiV1ProjectsGetSort?.map((e) => e.value!).join(',') ?? '';
}

List<String> apiV1ProjectsGetSortListToJson(
  List<enums.ApiV1ProjectsGetSort>? apiV1ProjectsGetSort,
) {
  if (apiV1ProjectsGetSort == null) {
    return [];
  }

  return apiV1ProjectsGetSort.map((e) => e.value!).toList();
}

List<enums.ApiV1ProjectsGetSort> apiV1ProjectsGetSortListFromJson(
  List? apiV1ProjectsGetSort, [
  List<enums.ApiV1ProjectsGetSort>? defaultValue,
]) {
  if (apiV1ProjectsGetSort == null) {
    return defaultValue ?? [];
  }

  return apiV1ProjectsGetSort
      .map((e) => apiV1ProjectsGetSortFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ProjectsGetSort>? apiV1ProjectsGetSortNullableListFromJson(
  List? apiV1ProjectsGetSort, [
  List<enums.ApiV1ProjectsGetSort>? defaultValue,
]) {
  if (apiV1ProjectsGetSort == null) {
    return defaultValue;
  }

  return apiV1ProjectsGetSort
      .map((e) => apiV1ProjectsGetSortFromJson(e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
