import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Last-known JSON snapshots for offline start (names and links only: never
/// tokens or signed URLs). Cleared on sign-out.
abstract interface class SnapshotCache {
  Future<Map<String, dynamic>?> read(String key);
  Future<void> write(String key, Map<String, dynamic> value);
  Future<void> remove(String key);
  Future<void> clear();
}

class PreferencesSnapshotCache implements SnapshotCache {
  static const String _prefix = 'sgsai.snapshot.';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<Map<String, dynamic>?> read(String key) async {
    final raw = (await _prefs).getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on Object {
      await remove(key);
      return null;
    }
  }

  @override
  Future<void> write(String key, Map<String, dynamic> value) async =>
      (await _prefs).setString('$_prefix$key', jsonEncode(value));

  @override
  Future<void> remove(String key) async =>
      (await _prefs).remove('$_prefix$key');

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      await prefs.remove(key);
    }
  }
}

class MemorySnapshotCache implements SnapshotCache {
  final Map<String, Map<String, dynamic>> entries = {};

  @override
  Future<Map<String, dynamic>?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, Map<String, dynamic> value) async =>
      entries[key] = value;

  @override
  Future<void> remove(String key) async => entries.remove(key);

  @override
  Future<void> clear() async => entries.clear();
}

final snapshotCacheProvider = Provider<SnapshotCache>(
  (ref) => PreferencesSnapshotCache(),
);
