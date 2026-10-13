import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/connectivity_banner.dart';
import 'package:mobile_app/core/network/connectivity_provider.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows the offline banner and removes it when network returns', (
    tester,
  ) async {
    final connectivity = StreamController<bool>.broadcast(sync: true);
    addTearDown(connectivity.close);

    await tester.pumpApp(
      const ConnectivityBanner(child: Scaffold(body: Text('Home'))),
      overrides: [
        connectivityStatusProvider.overrideWith((ref) => connectivity.stream),
      ],
    );
    expect(find.text("You're offline. Check your connection."), findsNothing);

    connectivity.add(false);
    await tester.pump();
    expect(find.text("You're offline. Check your connection."), findsOneWidget);

    connectivity.add(true);
    await tester.pump();
    expect(find.text("You're offline. Check your connection."), findsNothing);
    expect(find.text('Home'), findsOneWidget);
  });
}
