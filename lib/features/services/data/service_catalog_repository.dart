import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/network/api_exception.dart';
import 'package:mobile_app/features/services/domain/pwa_service.dart';

const String serviceCatalogRemoteConfigKey = 'pwa_services';

final firebaseRemoteConfigProvider = Provider<FirebaseRemoteConfig?>((ref) {
  if (!ref.watch(appConfigProvider).firebaseEnabled) return null;
  return FirebaseRemoteConfig.instance;
});

class ServiceCatalogRepository {
  const ServiceCatalogRepository(this._remoteConfig);

  final FirebaseRemoteConfig? _remoteConfig;

  Future<List<PwaService>> fetchServices() async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) return PwaService.sampleCatalog;

    final defaults = jsonEncode(
      PwaService.sampleCatalog.map((service) => service.toJson()).toList(),
    );
    await remoteConfig.setDefaults(<String, Object>{
      serviceCatalogRemoteConfigKey: defaults,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } on FirebaseException {
      return PwaService.sampleCatalog;
    }

    final value = remoteConfig.getString(serviceCatalogRemoteConfigKey);
    if (value.isEmpty) return PwaService.sampleCatalog;
    try {
      final decoded = jsonDecode(value);
      if (decoded is! List<dynamic>) throw const FormatException();
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(PwaService.fromJson)
          .toList(growable: false);
    } on Object {
      throw const ApiException(
        code: 'INVALID_SERVICE_CATALOG',
        message: 'Services could not be loaded. Please try again.',
      );
    }
  }
}

final serviceCatalogRepositoryProvider = Provider<ServiceCatalogRepository>(
  (ref) => ServiceCatalogRepository(ref.watch(firebaseRemoteConfigProvider)),
);

final serviceCatalogProvider = FutureProvider<List<PwaService>>(
  (ref) => ref.watch(serviceCatalogRepositoryProvider).fetchServices(),
);
