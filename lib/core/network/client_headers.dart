import 'package:flutter/foundation.dart';

/// Tells the SGS API this is the mobile app, so refresh tokens are delivered
/// in JSON bodies (not cookies) and sessions are labelled by platform.
Map<String, String> clientHeaders([TargetPlatform? platform]) {
  final target = platform ?? defaultTargetPlatform;
  return <String, String>{
    'X-Client': 'mobile',
    'X-Client-Platform': target == TargetPlatform.iOS ? 'ios' : 'android',
  };
}
