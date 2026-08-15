import 'package:fake_async/fake_async.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/channels/test_fakes.dart';

/// نسخة اختبارية من CallsManager — الأوامر لا تفعل شيئاً وتسجّل التفاعلات.
class TestCallsManager extends FakeCallsManager {
  CallsEmoji? lastSentEmoji;
  bool startCallCalled = false;

  @override
  AudioSessionManager get audioSessionManager => AudioSessionManager();

  @override
  Future<void> startCall(
    String channelId, {
    bool video = false,
    bool selfInitiated = true,
  }) async {
    startCallCalled = true;
  }

  @override
  Future<void> joinExistingCall(String channelId, {bool video = false}) async {}

  @override
  Future<void> endCall() async {}

  @override
  Future<void> dismissIncomingCall(String channelId) async {}

  @override
  Future<void> toggleScreenShare() async {}

  @override
  void toggleMute() {}

  @override
  void toggleVideo() {}

  @override
  void raiseHand(bool raise) {}

  @override
  void sendReaction(CallsEmoji emoji) {
    lastSentEmoji = emoji;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestCallsManager manager;
  late CallsBloc bloc;

  setUp(() {
    manager = TestCallsManager();
    bloc = CallsBloc(manager);
  });

  tearDown(() {
    bloc.close();
  });

  group('CallsBloc — بدء/إنهاء المكالمة', () {
    test('StartCallEvent → CallConnectedState', () async {
      bloc.add(const StartCallEvent('ch1'));
      await pumpEventQueue();
      expect(manager.startCallCalled, isTrue);
      expect(bloc.state, isA<CallConnectedState>());
      final s = bloc.state as CallConnectedState;
      expect(s.channelId, 'ch1');
      expect(s.isVideoOn, isFalse);
    });

    test('EndCallEvent → CallIdleState', () async {
      bloc.add(const StartCallEvent('ch1'));
      await pumpEventQueue();
      bloc.add(EndCallEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('JoinCallEvent من CallRingingState → CallConnectedState', () async {
      bloc.add(const IncomingCallEvent(
        callId: 'call-1',
        channelId: 'ch1',
        ownerId: 'user-1',
      ));
      await pumpEventQueue();
      expect(bloc.state, isA<CallRingingState>());

      bloc.add(const JoinCallEvent('call-1'));
      await pumpEventQueue();
      expect(bloc.state, isA<CallConnectedState>());
      expect((bloc.state as CallConnectedState).callId, 'call-1');
    });

    test('JoinCallEvent خارج الرنين لا يغيّر الحالة', () async {
      bloc.add(const JoinCallEvent('call-1'));
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });
  });

  group('CallsBloc — المكالمة الواردة', () {
    test('IncomingCallEvent → CallRingingState مع ownerId', () async {
      bloc.add(const IncomingCallEvent(
        callId: 'call-1',
        channelId: 'ch1',
        ownerId: 'caller-user',
      ));
      await pumpEventQueue();
      final s = bloc.state;
      expect(s, isA<CallRingingState>());
      expect((s as CallRingingState).ownerId, 'caller-user');
      expect(s.channelId, 'ch1');
    });

    test('RejectCallEvent أثناء الرنين → CallIdleState', () async {
      bloc.add(const IncomingCallEvent(callId: 'call-1', channelId: 'ch1'));
      await pumpEventQueue();
      bloc.add(const RejectCallEvent('call-1'));
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });
  });

  group('CallsBloc — ضوابط المكالمة', () {
    Future<void> connect() async {
      bloc.add(const StartCallEvent('ch1'));
      await pumpEventQueue();
    }

    test('ToggleMuteEvent يعكس isMuted', () async {
      await connect();
      bloc.add(ToggleMuteEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isMuted, isTrue);
      bloc.add(ToggleMuteEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isMuted, isFalse);
    });

    test('ToggleRaiseHandEvent يعكس isHandRaised', () async {
      await connect();
      bloc.add(ToggleRaiseHandEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isHandRaised, isTrue);
    });

    test('ToggleReactionEvent يرسل التفاعل للمدير', () async {
      await connect();
      const emoji = CallsEmoji(
        name: 'thumbsup',
        unified: '1f44d',
        skin: '1f3fb',
        literal: '👍',
      );
      bloc.add(const ToggleReactionEvent(emoji));
      await pumpEventQueue();
      expect(manager.lastSentEmoji?.name, 'thumbsup');
    });

    test('SwitchAudioOutputEvent يغيّر audioDevice', () async {
      await connect();
      bloc.add(const SwitchAudioOutputEvent(AudioOutputDevice.earpiece));
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).audioDevice,
          AudioOutputDevice.earpiece);
    });

    test('CallConnectionStatusChanged(reconnecting) → CallReconnectingState',
        () async {
      await connect();
      bloc.add(CallConnectionStatusChanged(CallsWebSocketStatus.reconnecting));
      await pumpEventQueue();
      expect(bloc.state, isA<CallReconnectingState>());
    });

    test('ParticipantsChanged يحدّث المشاركين في الاتصال', () async {
      await connect();
      const participant = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
        isMuted: true,
      );
      bloc.add(const ParticipantsChanged({'s1': participant}));
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).participants['s1']?.isMuted,
          isTrue);
    });

    test('CallStateFromManager(ended) → CallEndedState ثم بعد 2s → CallIdleState',
        () {
      fakeAsync((async) {
        final localManager = TestCallsManager();
        // بناء الـ bloc داخل منطقة fakeAsync حتى يعمل مؤقت الـ 2s فيها.
        final localBloc = CallsBloc(localManager);

        localBloc.add(const StartCallEvent('ch1'));
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallConnectedState>());

        localBloc.add(const CallStateFromManager(CallState.ended));
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallEndedState>());

        async.elapse(const Duration(seconds: 2));
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallIdleState>());

        localBloc.close();
      });
    });
  });
}
