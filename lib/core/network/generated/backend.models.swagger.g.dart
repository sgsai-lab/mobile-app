// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserCreate _$AdminUserCreateFromJson(Map<String, dynamic> json) =>
    AdminUserCreate(
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: AdminUserCreate.userRoleRoleNullableFromJson(json['role']),
    );

Map<String, dynamic> _$AdminUserCreateToJson(AdminUserCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'full_name': instance.fullName,
      'role': userRoleNullableToJson(instance.role),
    };

AdminUserUpdate _$AdminUserUpdateFromJson(Map<String, dynamic> json) =>
    AdminUserUpdate(
      fullName: json['full_name'] as String?,
      role: userRoleNullableFromJson(json['role']),
      status: userStatusNullableFromJson(json['status']),
    );

Map<String, dynamic> _$AdminUserUpdateToJson(AdminUserUpdate instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'role': userRoleNullableToJson(instance.role),
      'status': userStatusNullableToJson(instance.status),
    };

AppleRequest _$AppleRequestFromJson(Map<String, dynamic> json) => AppleRequest(
  idToken: json['id_token'] as String,
  nonce: json['nonce'] as String?,
  fullName: json['full_name'] as String?,
);

Map<String, dynamic> _$AppleRequestToJson(AppleRequest instance) =>
    <String, dynamic>{
      'id_token': instance.idToken,
      'nonce': instance.nonce,
      'full_name': instance.fullName,
    };

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  currentPassword: json['current_password'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'current_password': instance.currentPassword,
  'new_password': instance.newPassword,
};

EmailRequest _$EmailRequestFromJson(Map<String, dynamic> json) =>
    EmailRequest(email: json['email'] as String);

Map<String, dynamic> _$EmailRequestToJson(EmailRequest instance) =>
    <String, dynamic>{'email': instance.email};

ErrorBody _$ErrorBodyFromJson(Map<String, dynamic> json) => ErrorBody(
  code: json['code'] as String,
  message: json['message'] as String,
  requestId: json['requestId'] as String?,
  details:
      (json['details'] as List<dynamic>?)
          ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ErrorBodyToJson(ErrorBody instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'requestId': instance.requestId,
  'details': instance.details.map((e) => e.toJson()).toList(),
};

ErrorDetail _$ErrorDetailFromJson(Map<String, dynamic> json) => ErrorDetail(
  field: json['field'] as String?,
  message: json['message'] as String,
);

Map<String, dynamic> _$ErrorDetailToJson(ErrorDetail instance) =>
    <String, dynamic>{'field': instance.field, 'message': instance.message};

ErrorEnvelope _$ErrorEnvelopeFromJson(Map<String, dynamic> json) =>
    ErrorEnvelope(
      error: ErrorBody.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorEnvelopeToJson(ErrorEnvelope instance) =>
    <String, dynamic>{'error': instance.error.toJson()};

FirebaseRequest _$FirebaseRequestFromJson(Map<String, dynamic> json) =>
    FirebaseRequest(idToken: json['id_token'] as String);

Map<String, dynamic> _$FirebaseRequestToJson(FirebaseRequest instance) =>
    <String, dynamic>{'id_token': instance.idToken};

GoogleRequest _$GoogleRequestFromJson(Map<String, dynamic> json) =>
    GoogleRequest(
      idToken: json['id_token'] as String,
      nonce: json['nonce'] as String?,
    );

Map<String, dynamic> _$GoogleRequestToJson(GoogleRequest instance) =>
    <String, dynamic>{'id_token': instance.idToken, 'nonce': instance.nonce};

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    HTTPValidationError(
      detail:
          (json['detail'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(
  HTTPValidationError instance,
) => <String, dynamic>{
  'detail': instance.detail?.map((e) => e.toJson()).toList(),
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

MfaChallengeResponse _$MfaChallengeResponseFromJson(
  Map<String, dynamic> json,
) => MfaChallengeResponse(
  mfaRequired: json['mfa_required'] as bool? ?? true,
  mfaToken: json['mfa_token'] as String,
  methods:
      (json['methods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$MfaChallengeResponseToJson(
  MfaChallengeResponse instance,
) => <String, dynamic>{
  'mfa_required': instance.mfaRequired,
  'mfa_token': instance.mfaToken,
  'methods': instance.methods,
};

MfaStatusResponse _$MfaStatusResponseFromJson(Map<String, dynamic> json) =>
    MfaStatusResponse(
      available: json['available'] as bool,
      enabled: json['enabled'] as bool,
      methods:
          (json['methods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      recoveryCodesRemaining: (json['recovery_codes_remaining'] as num).toInt(),
    );

Map<String, dynamic> _$MfaStatusResponseToJson(MfaStatusResponse instance) =>
    <String, dynamic>{
      'available': instance.available,
      'enabled': instance.enabled,
      'methods': instance.methods,
      'recovery_codes_remaining': instance.recoveryCodesRemaining,
    };

MfaVerifyRequest _$MfaVerifyRequestFromJson(Map<String, dynamic> json) =>
    MfaVerifyRequest(
      mfaToken: json['mfa_token'] as String,
      code: json['code'] as String?,
      recoveryCode: json['recovery_code'] as String?,
    );

Map<String, dynamic> _$MfaVerifyRequestToJson(MfaVerifyRequest instance) =>
    <String, dynamic>{
      'mfa_token': instance.mfaToken,
      'code': instance.code,
      'recovery_code': instance.recoveryCode,
    };

PageProjectRead _$PageProjectReadFromJson(Map<String, dynamic> json) =>
    PageProjectRead(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ProjectRead.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
    );

Map<String, dynamic> _$PageProjectReadToJson(PageProjectRead instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };

PageUserRead _$PageUserReadFromJson(Map<String, dynamic> json) => PageUserRead(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => UserRead.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['page_size'] as num).toInt(),
);

Map<String, dynamic> _$PageUserReadToJson(PageUserRead instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };

ProjectCreate _$ProjectCreateFromJson(Map<String, dynamic> json) =>
    ProjectCreate(
      name: json['name'] as String,
      description: json['description'] as String?,
      status: ProjectCreate.projectStatusStatusNullableFromJson(json['status']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProjectCreateToJson(ProjectCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'status': projectStatusNullableToJson(instance.status),
      'tags': instance.tags,
      'start_date': _dateToJson(instance.startDate),
      'end_date': _dateToJson(instance.endDate),
      'metadata': instance.metadata,
    };

ProjectRead _$ProjectReadFromJson(Map<String, dynamic> json) => ProjectRead(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: projectStatusFromJson(json['status']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  metadata: json['metadata'] as Map<String, dynamic>,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProjectReadToJson(ProjectRead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'status': projectStatusToJson(instance.status),
      'tags': instance.tags,
      'start_date': _dateToJson(instance.startDate),
      'end_date': _dateToJson(instance.endDate),
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ProjectUpdate _$ProjectUpdateFromJson(Map<String, dynamic> json) =>
    ProjectUpdate(
      name: json['name'] as String?,
      description: json['description'] as String?,
      status: projectStatusNullableFromJson(json['status']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      metadata: json['metadata'],
    );

Map<String, dynamic> _$ProjectUpdateToJson(ProjectUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'status': projectStatusNullableToJson(instance.status),
      'tags': instance.tags,
      'start_date': _dateToJson(instance.startDate),
      'end_date': _dateToJson(instance.endDate),
      'metadata': instance.metadata,
    };

ReauthRequest _$ReauthRequestFromJson(Map<String, dynamic> json) =>
    ReauthRequest(
      password: json['password'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ReauthRequestToJson(ReauthRequest instance) =>
    <String, dynamic>{'password': instance.password, 'code': instance.code};

RecoveryCodesResponse _$RecoveryCodesResponseFromJson(
  Map<String, dynamic> json,
) => RecoveryCodesResponse(
  recoveryCodes:
      (json['recovery_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$RecoveryCodesResponseToJson(
  RecoveryCodesResponse instance,
) => <String, dynamic>{'recovery_codes': instance.recoveryCodes};

RefreshRequest _$RefreshRequestFromJson(Map<String, dynamic> json) =>
    RefreshRequest(refreshToken: json['refresh_token'] as String?);

Map<String, dynamic> _$RefreshRequestToJson(RefreshRequest instance) =>
    <String, dynamic>{'refresh_token': instance.refreshToken};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  token: json['token'] as String,
  newPassword: json['new_password'] as String,
  mfaCode: json['mfa_code'] as String?,
  recoveryCode: json['recovery_code'] as String?,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'new_password': instance.newPassword,
  'mfa_code': instance.mfaCode,
  'recovery_code': instance.recoveryCode,
};

SessionRead _$SessionReadFromJson(Map<String, dynamic> json) => SessionRead(
  id: json['id'] as String,
  startedAt: DateTime.parse(json['started_at'] as String),
  lastUsedAt: DateTime.parse(json['last_used_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  ip: json['ip'] as String?,
  userAgent: json['user_agent'] as String?,
  current: json['current'] as bool,
);

Map<String, dynamic> _$SessionReadToJson(SessionRead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'started_at': instance.startedAt.toIso8601String(),
      'last_used_at': instance.lastUsedAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'ip': instance.ip,
      'user_agent': instance.userAgent,
      'current': instance.current,
    };

SetPasswordRequest _$SetPasswordRequestFromJson(Map<String, dynamic> json) =>
    SetPasswordRequest(newPassword: json['new_password'] as String);

Map<String, dynamic> _$SetPasswordRequestToJson(SetPasswordRequest instance) =>
    <String, dynamic>{'new_password': instance.newPassword};

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['full_name'] as String,
      acceptTerms: json['accept_terms'] as bool,
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'full_name': instance.fullName,
      'accept_terms': instance.acceptTerms,
    };

SignupResponse _$SignupResponseFromJson(Map<String, dynamic> json) =>
    SignupResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      emailVerified: json['email_verified'] as bool,
    );

Map<String, dynamic> _$SignupResponseToJson(SignupResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'email_verified': instance.emailVerified,
    };

TokenRequest _$TokenRequestFromJson(Map<String, dynamic> json) =>
    TokenRequest(token: json['token'] as String);

Map<String, dynamic> _$TokenRequestToJson(TokenRequest instance) =>
    <String, dynamic>{'token': instance.token};

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String?,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
    };

TotpCodeRequest _$TotpCodeRequestFromJson(Map<String, dynamic> json) =>
    TotpCodeRequest(code: json['code'] as String);

Map<String, dynamic> _$TotpCodeRequestToJson(TotpCodeRequest instance) =>
    <String, dynamic>{'code': instance.code};

TotpSetupResponse _$TotpSetupResponseFromJson(Map<String, dynamic> json) =>
    TotpSetupResponse(
      secret: json['secret'] as String,
      otpauthUri: json['otpauth_uri'] as String,
    );

Map<String, dynamic> _$TotpSetupResponseToJson(TotpSetupResponse instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'otpauth_uri': instance.otpauthUri,
    };

UserRead _$UserReadFromJson(Map<String, dynamic> json) => UserRead(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  role: userRoleFromJson(json['role']),
  status: userStatusFromJson(json['status']),
  emailVerified: json['email_verified'] as bool,
  mfaEnabled: json['mfa_enabled'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
);

Map<String, dynamic> _$UserReadToJson(UserRead instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'full_name': instance.fullName,
  'avatar_url': instance.avatarUrl,
  'role': userRoleToJson(instance.role),
  'status': userStatusToJson(instance.status),
  'email_verified': instance.emailVerified,
  'mfa_enabled': instance.mfaEnabled,
  'created_at': instance.createdAt.toIso8601String(),
  'last_login_at': instance.lastLoginAt?.toIso8601String(),
};

UserUpdateMe _$UserUpdateMeFromJson(Map<String, dynamic> json) => UserUpdateMe(
  fullName: json['full_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$UserUpdateMeToJson(UserUpdateMe instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
    };

ValidationError _$ValidationErrorFromJson(
  Map<String, dynamic> json,
) => ValidationError(
  loc: (json['loc'] as List<dynamic>?)?.map((e) => e as Object).toList() ?? [],
  msg: json['msg'] as String,
  type: json['type'] as String,
  input: json['input'],
  ctx: json['ctx'],
);

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
      'input': instance.input,
      'ctx': instance.ctx,
    };
