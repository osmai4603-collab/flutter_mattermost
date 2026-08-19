import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CallParticipantState', () {
    test('القيم الافتراضية صحيحة', () {
      const p = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
      );

      expect(p.sessionId, 's1');
      expect(p.userId, 'u1');
      expect(p.isMuted, isFalse);
      expect(p.isVoiceActive, isFalse);
      expect(p.isHandRaised, isFalse);
      expect(p.isSharingScreen, isFalse);
      expect(p.isVideoOn, isFalse);
      expect(p.isHost, isFalse);
      expect(p.renderer, isNull);
    });

    test('copyWith يحدّث الحقول المحددة فقط', () {
      const p = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
        isMuted: false,
        isVideoOn: true,
      );

      final updated = p.copyWith(isMuted: true);
      expect(updated.isMuted, isTrue);
      expect(updated.isVideoOn, isTrue);
      expect(updated.userId, 'u1');
      expect(updated.isHost, isFalse);
    });

    test('copyWith بدون أ args يُعيد النسخة الأصلية بقيمها', () {
      const p = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
        isMuted: true,
        isHandRaised: true,
        isVoiceActive: true,
        isSharingScreen: true,
        isVideoOn: true,
        isHost: true,
      );

      final copy = p.copyWith();
      expect(copy.sessionId, p.sessionId);
      expect(copy.userId, p.userId);
      expect(copy.isMuted, p.isMuted);
      expect(copy.isHandRaised, p.isHandRaised);
      expect(copy.isVoiceActive, p.isVoiceActive);
      expect(copy.isSharingScreen, p.isSharingScreen);
      expect(copy.isVideoOn, p.isVideoOn);
      expect(copy.isHost, p.isHost);
    });

    test('copyWith يحدّث كل الحقول دفعة واحدة', () {
      const p = CallParticipantState(
        sessionId: 's1',
        userId: 'u1',
      );

      final updated = p.copyWith(
        isMuted: true,
        isVoiceActive: true,
        isHandRaised: true,
        isSharingScreen: true,
        isVideoOn: true,
        isHost: true,
      );

      expect(updated.isMuted, isTrue);
      expect(updated.isVoiceActive, isTrue);
      expect(updated.isHandRaised, isTrue);
      expect(updated.isSharingScreen, isTrue);
      expect(updated.isVideoOn, isTrue);
      expect(updated.isHost, isTrue);
    });

    test('sessionId و userId لا يتغيران مع copyWith', () {
      const p = CallParticipantState(
        sessionId: 'sess-42',
        userId: 'user-99',
      );

      final updated = p.copyWith(isMuted: true);
      expect(updated.sessionId, 'sess-42');
      expect(updated.userId, 'user-99');
    });
  });

  group('CallReactionEvent', () {
    test('يحتفظ بجميع الحقول', () {
      const r = CallReactionEvent(
        sessionId: 's1',
        userId: 'u1',
        emojiName: 'thumbsup',
        emojiLiteral: '👍',
        timestamp: 12345,
      );

      expect(r.sessionId, 's1');
      expect(r.userId, 'u1');
      expect(r.emojiName, 'thumbsup');
      expect(r.emojiLiteral, '👍');
      expect(r.timestamp, 12345);
    });
  });

  group('CallHostControlEvent', () {
    test('يحتفظ بالنوع والبيانات', () {
      const e = CallHostControlEvent(
        type: 'host_mute',
        data: {'session_id': 's1'},
      );

      expect(e.type, 'host_mute');
      expect(e.data['session_id'], 's1');
    });
  });

  group('CallState enum', () {
    test('يحتوي على جميع الحالات المتوقعة', () {
      expect(CallState.values, contains(CallState.idle));
      expect(CallState.values, contains(CallState.ringing));
      expect(CallState.values, contains(CallState.joining));
      expect(CallState.values, contains(CallState.connected));
      expect(CallState.values, contains(CallState.reconnecting));
      expect(CallState.values, contains(CallState.ended));
      expect(CallState.values.length, 6);
    });
  });
}
