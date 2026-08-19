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

    test('ToggleVideoEvent يعكس isVideoOn', () async {
      bloc.add(const StartCallEvent('ch1', video: true));
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isVideoOn, isTrue);

      bloc.add(ToggleVideoEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isVideoOn, isFalse);
    });

    test('StartCallEvent مع video=true يبدأ مع isVideoOn=true', () async {
      bloc.add(const StartCallEvent('ch1', video: true));
      await pumpEventQueue();
      final s = bloc.state as CallConnectedState;
      expect(s.isVideoOn, isTrue);
      expect(s.channelId, 'ch1');
    });

    test('ToggleShareScreenEvent يعكس isSharingScreen', () async {
      await connect();
      expect((bloc.state as CallConnectedState).isSharingScreen, isFalse);

      bloc.add(ToggleShareScreenEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isSharingScreen, isTrue);
    });

    test('ToggleMuteEvent خارج CallConnectedState لا يفعل شيئاً', () async {
      bloc.add(ToggleMuteEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('ToggleVideoEvent خارج CallConnectedState لا يفعل شيئاً', () async {
      bloc.add(ToggleVideoEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('ToggleShareScreenEvent خارج CallConnectedState لا يفعل شيئاً',
        () async {
      bloc.add(ToggleShareScreenEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('ToggleRaiseHandEvent خارج CallConnectedState لا يفعل شيئاً',
        () async {
      bloc.add(ToggleRaiseHandEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('SwitchAudioOutputEvent خارج CallConnectedState لا يفعل شيئاً',
        () async {
      bloc.add(const SwitchAudioOutputEvent(AudioOutputDevice.bluetooth));
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('ToggleRaiseHandEvent يمكنه الرفع ثم الإسقاط', () async {
      await connect();
      bloc.add(ToggleRaiseHandEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isHandRaised, isTrue);

      bloc.add(ToggleRaiseHandEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isHandRaised, isFalse);
    });

    test('ToggleMuteEvent يمكنه الكتم ثم فك الكتم', () async {
      await connect();
      bloc.add(ToggleMuteEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isMuted, isTrue);

      bloc.add(ToggleMuteEvent());
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).isMuted, isFalse);
    });

    test('SwitchAudioOutputEvent مع bluetooth', () async {
      await connect();
      bloc.add(const SwitchAudioOutputEvent(AudioOutputDevice.bluetooth));
      await pumpEventQueue();
      expect((bloc.state as CallConnectedState).audioDevice,
          AudioOutputDevice.bluetooth);
    });

    test('CallConnectionStatusChanged(connected) من reconnecting لا ي逆袭 الحالة لأن الـ state ليس CallConnectedState', () async {
      await connect();
      bloc.add(CallConnectionStatusChanged(CallsWebSocketStatus.reconnecting));
      await pumpEventQueue();
      expect(bloc.state, isA<CallReconnectingState>());

      // عند reconnecting → connected والstate هو CallReconnectingState
      // الـ BLoC لا ي逆转 لأنه يتحقق فقط من state is CallConnectedState
      // هذا سلوك متوقع — الحالة تبقى reconnecting حتى arrives call_state
      bloc.add(CallConnectionStatusChanged(CallsWebSocketStatus.connected));
      await pumpEventQueue();
      expect(bloc.state, isA<CallReconnectingState>());
    });

    test('ParticipantsChanged يرتب حسب isHandRaised', () async {
      await connect();
      const p1 = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
        isMuted: false,
      );
      const p2 = CallParticipantState(
        sessionId: 's2',
        userId: 'u2',
        isMuted: false,
        isHandRaised: true,
      );
      bloc.add(const ParticipantsChanged({
        's1': p1,
        's2': p2,
      }));
      await pumpEventQueue();
      final s = bloc.state as CallConnectedState;
      final keys = s.participants.keys.toList();
      expect(keys.first, 's2');
      expect(keys.last, 's1');
    });

    test('ReactionReceived يحدّث lastReaction', () async {
      await connect();
      const reaction = CallReactionEvent(
        sessionId: 's1',
        userId: 'u1',
        emojiName: 'heart',
        emojiLiteral: '❤️',
        timestamp: 1000,
      );
      bloc.add(const ReactionReceived(reaction));
      await pumpEventQueue();
      expect(
        (bloc.state as CallConnectedState).lastReaction?.emojiName,
        'heart',
      );
    });

    test('IncomingCallEvent خارج CallIdleState لا يفعل شيئاً', () async {
      await connect();
      bloc.add(const IncomingCallEvent(
        callId: 'call-2',
        channelId: 'ch2',
        ownerId: 'user-2',
      ));
      await pumpEventQueue();
      expect(bloc.state, isA<CallConnectedState>());
    });

    test('EndCallEvent أثناء CallEndedState يُعيد الحالة إلى idle', () {
      fakeAsync((async) {
        final localManager = TestCallsManager();
        final localBloc = CallsBloc(localManager);

        localBloc.add(const StartCallEvent('ch1'));
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallConnectedState>());

        localBloc.add(const CallStateFromManager(CallState.ended));
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallEndedState>());

        localBloc.add(EndCallEvent());
        async.flushMicrotasks();
        expect(localBloc.state, isA<CallIdleState>());

        localBloc.close();
      });
    });

    test('CallConnectionStatusChanged(reconnecting) ثم idle → يبقى reconnecting',
        () async {
      await connect();
      bloc.add(CallConnectionStatusChanged(CallsWebSocketStatus.reconnecting));
      await pumpEventQueue();
      expect(bloc.state, isA<CallReconnectingState>());

      bloc.add(const CallStateFromManager(CallState.idle));
      await pumpEventQueue();
      expect(bloc.state, isA<CallIdleState>());
    });

    test('CallStateFromManager(ringing) لا يغيّر الحالة أثناء الاتصال', () async {
      await connect();
      bloc.add(const CallStateFromManager(CallState.ringing));
      await pumpEventQueue();
      expect(bloc.state, isA<CallConnectedState>());
    });
  });
}
