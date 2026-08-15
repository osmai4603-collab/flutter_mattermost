import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CallsWebSocketClient resolves from DI', () async {
    await configureDependencies();

    final client = getIt<CallsWebSocketClient>();

    expect(client, isNotNull);
    expect(client.sessionId, isNull);
    expect(client.status, CallsWebSocketStatus.disconnected);

    await getIt.reset();
  });
}
