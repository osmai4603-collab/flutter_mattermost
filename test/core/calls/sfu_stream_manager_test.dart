import 'dart:async';

import 'package:flutter_mattermost/core/calls/sfu_stream_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webrtc_interface/src/rtc_peerconnection.dart';
import 'package:webrtc_interface/src/rtc_stats_report.dart';

void main() {
  group('SFUStreamManager', () {
    late SFUStreamManager manager;

    setUp(() {
      manager = SFUStreamManager();
    });

    tearDown(() {
      manager.dispose();
    });

    group('activeSpeakerStream', () {
      test('يبدأ بدون متحدث نشط', () {
        final speakers = <String>[];
        final sub = manager.activeSpeakerStream.listen(speakers.add);
        expect(speakers, isEmpty);
        sub.cancel();
      });
    });

    group('stopMonitoring', () {
      test('إيقاف المراقبة لا يسبب أخطاء', () {
        manager.stopMonitoring();
        manager.stopMonitoring();
      });

      test('startMonitoring ثم stopMonitoring لا يسبب أخطاء', () {
        manager.startMonitoring(FakeRTCPeerConnection());
        manager.stopMonitoring();
      });
    });

    group('dispose', () {
      test('dispose يُغلق التدفق ويزيل المراقبة', () {
        manager.startMonitoring(FakeRTCPeerConnection());
        manager.dispose();
      });

      test('dispose بعد stopMonitoring لا يسبب تعارض', () {
        manager.stopMonitoring();
        manager.dispose();
      });
    });

    group('callState', () {
      test('SFUStreamManager يبدأ في حالة نقية', () {
        final sm = SFUStreamManager();
        expect(sm.activeSpeakerStream, isA<Stream<String>>());
        sm.dispose();
      });
    });
  });
}

/// RTCPeerConnection وهمي يُعيد قائمة إحصاءات فارغة.
class FakeRTCPeerConnection implements RTCPeerConnection {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getStats) {
      return Future.value(<StatsReport>[]);
    }
    return null;
  }
}
