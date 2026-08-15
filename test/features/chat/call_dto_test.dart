import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/features/chat/data/models/call_dto.dart';
import 'package:flutter_mattermost/features/chat/data/models/call_participant_dto.dart';

void main() {
  group('CallParticipantDto', () {
    test('fromMap يقرأ كل الحقول على نمط UserStateClient', () {
      final dto = CallParticipantDto.fromMap({
        'session_id': 'sess-1',
        'user_id': 'user-1',
        'unmuted': true,
        'raised_hand': 123456,
        'video': false,
      });

      expect(dto.sessionId, 'sess-1');
      expect(dto.userId, 'user-1');
      expect(dto.unmuted, true);
      expect(dto.raisedHand, 123456);
      expect(dto.video, false);
    });

    test('fromMap يعطي قيماً افتراضية عند غياب الحقول', () {
      final dto = CallParticipantDto.fromMap({'session_id': 'sess-1'});

      expect(dto.userId, '');
      expect(dto.unmuted, false);
      expect(dto.raisedHand, 0);
      expect(dto.video, false);
    });

    test('toMap يعيد نفس الشكل المقبول لدى fromMap', () {
      final dto = CallParticipantDto(
        sessionId: 'sess-2',
        userId: 'user-2',
        unmuted: true,
        raisedHand: 7,
        video: true,
      );

      expect(dto.toMap(), {
        'session_id': 'sess-2',
        'user_id': 'user-2',
        'unmuted': true,
        'raised_hand': 7,
        'video': true,
      });
    });
  });

  group('CallDto', () {
    test('fromMap يقرأ call_state كاملة مع sessions', () {
      final dto = CallDto.fromMap({
        'id': 'call-1',
        'start_at': 1700000000,
        'sessions': [
          {
            'session_id': 'sess-1',
            'user_id': 'user-1',
            'unmuted': true,
            'raised_hand': 0,
            'video': false,
          },
          {
            'session_id': 'sess-2',
            'user_id': 'user-2',
            'unmuted': false,
            'raised_hand': 1700000100,
            'video': true,
          },
        ],
        'thread_id': 'thread-1',
        'post_id': 'post-1',
        'screen_sharing_session_id': 'sess-2',
        'owner_id': 'user-1',
        'host_id': 'user-1',
        'dismissed_notification': {'sess-3': true},
      });

      expect(dto.id, 'call-1');
      expect(dto.startAt, 1700000000);
      expect(dto.sessions, hasLength(2));
      expect(dto.sessions[0].sessionId, 'sess-1');
      expect(dto.sessions[1].video, true);
      expect(dto.sessions[1].raisedHand, 1700000100);
      expect(dto.threadId, 'thread-1');
      expect(dto.postId, 'post-1');
      expect(dto.screenSharingSessionId, 'sess-2');
      expect(dto.ownerId, 'user-1');
      expect(dto.hostId, 'user-1');
      expect(dto.dismissedNotification, {'sess-3': true});
      expect(dto.recording, isNull);
      expect(dto.transcription, isNull);
      expect(dto.liveCaptions, isNull);
    });

    test('fromMap يقرأ JobState الاختيارية (recording/transcription/live_captions)',
        () {
      final dto = CallDto.fromMap({
        'id': 'call-1',
        'start_at': 1700000000,
        'sessions': [],
        'thread_id': '',
        'post_id': '',
        'owner_id': '',
        'host_id': '',
        'recording': {
          'type': 'recording',
          'init_at': 1700000000,
          'start_at': 1700000100,
          'end_at': 0,
        },
        'live_captions': {
          'type': 'transcription',
          'init_at': 1700000000,
          'start_at': 0,
          'end_at': 0,
          'err': 'some error',
        },
      });

      expect(dto.recording, isNotNull);
      expect(dto.recording!.type, 'recording');
      expect(dto.recording!.startAt, 1700000100);
      expect(dto.liveCaptions, isNotNull);
      expect(dto.liveCaptions!.err, 'some error');
      expect(dto.transcription, isNull);
    });

    test('sessions و dismissed_notification آمِنة عند غيابهما', () {
      final dto = CallDto.fromMap({'id': 'call-1'});

      expect(dto.sessions, isEmpty);
      expect(dto.dismissedNotification, isEmpty);
      expect(dto.hostId, '');
    });
  });

  group('CallChannelStateDto', () {
    test('fromMap يقرأ استجابة GET /{channel_id} مع call', () {
      final dto = CallChannelStateDto.fromMap({
        'enabled': true,
        'channel_id': 'ch-1',
        'call': {
          'id': 'call-1',
          'start_at': 1700000000,
          'sessions': [
            {'session_id': 'sess-1', 'user_id': 'user-1'},
          ],
          'thread_id': '',
          'post_id': '',
          'owner_id': 'user-1',
          'host_id': 'user-1',
        },
      });

      expect(dto.enabled, true);
      expect(dto.channelId, 'ch-1');
      expect(dto.call, isNotNull);
      expect(dto.call!.id, 'call-1');
      expect(dto.call!.sessions.single.sessionId, 'sess-1');
    });

    test('fromMap يسمح بغياب call (لا توجد مكالمة نشطة)', () {
      final dto = CallChannelStateDto.fromMap({
        'enabled': false,
        'channel_id': 'ch-1',
      });

      expect(dto.enabled, false);
      expect(dto.call, isNull);
    });
  });
}
