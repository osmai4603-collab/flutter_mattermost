import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reusable_calls/src/sfu/active_speaker_detector.dart';

/// Realization of [ActiveSpeakerDetector] using WebRTC `inbound-rtp` audio levels.
class RtpActiveSpeakerDetector implements ActiveSpeakerDetector {
  Timer? _statsTimer;
  final Map<String, double> _audioLevels = {};
  String? _activeSpeakerSessionId;

  final StreamController<String> _activeSpeakerController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get activeSpeakerStream => _activeSpeakerController.stream;

  @override
  void startMonitoring(RTCPeerConnection pc) {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final stats = await pc.getStats();
        _processStats(stats);
      } catch (_) {
        stopMonitoring();
      }
    });
  }

  @override
  void stopMonitoring() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  void _processStats(List<StatsReport> reports) {
    for (final report in reports) {
      if (report.type == 'inbound-rtp' && report.values['kind'] == 'audio') {
        final sessionId = report.id;
        final audioLevel =
            (report.values['audioLevel'] as num?)?.toDouble() ?? 0.0;
        _audioLevels[sessionId] = audioLevel;
      }
    }
    _detectActiveSpeaker();
  }

  void _detectActiveSpeaker() {
    String? loudestSessionId;
    double maxLevel = 0.01;

    _audioLevels.forEach((sessionId, level) {
      if (level > maxLevel) {
        maxLevel = level;
        loudestSessionId = sessionId;
      }
    });

    if (loudestSessionId != null &&
        loudestSessionId != _activeSpeakerSessionId) {
      _activeSpeakerSessionId = loudestSessionId;
      _activeSpeakerController.add(_activeSpeakerSessionId!);
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    _activeSpeakerController.close();
  }
}
