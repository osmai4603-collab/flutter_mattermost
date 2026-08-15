import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SFUStreamManager {
  Timer? _statsTimer;
  final Map<String, double> _audioLevels = {};
  String? _activeSpeakerSessionId;

  final StreamController<String> _activeSpeakerController =
      StreamController<String>.broadcast();

  Stream<String> get activeSpeakerStream => _activeSpeakerController.stream;

  void startMonitoring(RTCPeerConnection pc) {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // قد يُغلق الـ peer connection (انتهاء المكالمة) قبل توقف المؤقّت —
      // لا نترك استثناءً غير معالج يُلوّث السجل.
      try {
        final stats = await pc.getStats();
        _processStats(stats);
      } catch (_) {
        stopMonitoring();
      }
    });
  }

  void stopMonitoring() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  void _processStats(List<StatsReport> reports) {
    for (final report in reports) {
      if (report.type == 'inbound-rtp' && report.values['kind'] == 'audio') {
        final sessionId = _getSessionIdFromStats(report);
        final audioLevel = report.values['audioLevel']?.toDouble() ?? 0.0;
        if (sessionId != null) {
          _audioLevels[sessionId] = audioLevel;
        }
      }
    }
    _detectActiveSpeaker();
  }

  String? _getSessionIdFromStats(StatsReport report) {
    // Logic to map stats report to session ID
    // In many implementations, track identifier or mid can be mapped
    return null; // Placeholder
  }

  void _detectActiveSpeaker() {
    String? loudestSessionId;
    double maxLevel = 0.01; // Threshold

    _audioLevels.forEach((sessionId, level) {
      if (level > maxLevel) {
        maxLevel = level;
        loudestSessionId = sessionId;
      }
    });

    if (loudestSessionId != null && loudestSessionId != _activeSpeakerSessionId) {
      _activeSpeakerSessionId = loudestSessionId;
      _activeSpeakerController.add(_activeSpeakerSessionId!);
    }
  }

  void dispose() {
    stopMonitoring();
    _activeSpeakerController.close();
  }
}
