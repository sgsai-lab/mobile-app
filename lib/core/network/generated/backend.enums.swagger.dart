// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum ProjectStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('draft')
  draft('draft'),
  @JsonValue('active')
  active('active'),
  @JsonValue('on_hold')
  onHold('on_hold'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('archived')
  archived('archived');

  final String? value;

  const ProjectStatus(this.value);
}

enum UserRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('user')
  user('user'),
  @JsonValue('admin')
  admin('admin');

  final String? value;

  const UserRole(this.value);
}

enum UserStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('active')
  active('active'),
  @JsonValue('disabled')
  disabled('disabled');

  final String? value;

  const UserStatus(this.value);
}

enum ApiV1UsersGetSort {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('created_at')
  createdAt('created_at'),
  @JsonValue('-created_at')
  $createdAt('-created_at'),
  @JsonValue('email')
  email('email'),
  @JsonValue('-email')
  $email('-email'),
  @JsonValue('full_name')
  fullName('full_name'),
  @JsonValue('-full_name')
  $fullName('-full_name');

  final String? value;

  const ApiV1UsersGetSort(this.value);
}

enum ApiV1ProjectsGetSort {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('created_at')
  createdAt('created_at'),
  @JsonValue('-created_at')
  $createdAt('-created_at'),
  @JsonValue('name')
  name('name'),
  @JsonValue('-name')
  $name('-name'),
  @JsonValue('updated_at')
  updatedAt('updated_at'),
  @JsonValue('-updated_at')
  $updatedAt('-updated_at');

  final String? value;

  const ApiV1ProjectsGetSort(this.value);
}
