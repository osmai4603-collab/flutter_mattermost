import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SFUStreamManager {
  Timer? _statsTimer;
  final Map<String, double> _audioLevels = {};
  String? _activeSpeakerSessionId;
  DateTime? _lastSwitchTime;
  static const Duration _switchCooldown = Duration(milliseconds: 500);

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
    // In Mattermost SFU (rtcd), the track identifier follows the pattern:
    // "audio_<sessionId>_<random>" or "video_<sessionId>_<random>"
    final trackId = report.values['trackIdentifier'] ?? report.values['trackId'];
    if (trackId == null) return null;

    final fields = trackId.toString().split('_');
    if (fields.length == 3) {
      return fields[1];
    }
    
    // Fallback: check if the stream identifier itself is the sessionId
    // (In some versions/configurations, stream.id is used directly)
    return null;
  }

  void _detectActiveSpeaker() {
    String? loudestSessionId;
    double maxLevel = 0.05; // Slightly higher threshold to filter background noise

    _audioLevels.forEach((sessionId, level) {
      if (level > maxLevel) {
        maxLevel = level;
        loudestSessionId = sessionId;
      }
    });

    if (loudestSessionId != null && loudestSessionId != _activeSpeakerSessionId) {
      final now = DateTime.now();
      if (_lastSwitchTime == null || 
          now.difference(_lastSwitchTime!) > _switchCooldown) {
        _activeSpeakerSessionId = loudestSessionId;
        _lastSwitchTime = now;
        _activeSpeakerController.add(_activeSpeakerSessionId!);
      }
    }
  }

  void dispose() {
    stopMonitoring();
    _activeSpeakerController.close();
  }
}
