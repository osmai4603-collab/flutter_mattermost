import 'dart:async';

enum SessionEvent { expired, restored, loggedOut }

class SessionController {
  final _controller = StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get stream => _controller.stream;

  void emit(SessionEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
