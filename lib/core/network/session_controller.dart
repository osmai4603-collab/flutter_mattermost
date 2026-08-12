import 'dart:async';
import 'package:injectable/injectable.dart';

enum SessionEvent { expired, restored, loggedOut }

@singleton
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
