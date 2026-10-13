import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lets the network layer report an unrecoverable session loss without
/// depending on feature code (which would create an import cycle).
class SessionEvents {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onExpired => _controller.stream;

  void notifyExpired() {
    if (!_controller.isClosed) _controller.add(null);
  }

  Future<void> dispose() => _controller.close();
}

final sessionEventsProvider = Provider<SessionEvents>((ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
});
