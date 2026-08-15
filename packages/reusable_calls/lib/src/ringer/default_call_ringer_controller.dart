import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:reusable_calls/src/ringer/call_ringer_controller.dart';

/// Default realization of [CallRingerController] using `audioplayers` with system haptics fallback.
class DefaultCallRingerController implements CallRingerController {
  AudioPlayer? _player;
  Timer? _timer;
  bool _isRinging = false;
  final String defaultRingtoneAsset;

  DefaultCallRingerController({
    this.defaultRingtoneAsset = 'sounds/calls_ringtone.wav',
  });

  @override
  bool get isRinging => _isRinging;

  @override
  void startRinging({String? customAssetPath}) {
    if (_isRinging) return;
    _isRinging = true;
    unawaited(_playLoop(customAssetPath ?? defaultRingtoneAsset));
  }

  Future<void> _playLoop(String assetPath) async {
    try {
      try {
        WidgetsBinding.instance;
      } catch (_) {
        throw StateError('WidgetsBinding not initialized');
      }

      final player = _player ??= AudioPlayer();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(1.0);
      await player.play(AssetSource(assetPath));
    } catch (_) {
      unawaited(_systemAlert());
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        unawaited(_systemAlert());
      });
    }
  }

  Future<void> _systemAlert() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  @override
  void stopRinging() {
    if (!_isRinging) return;
    _isRinging = false;
    _timer?.cancel();
    _timer = null;
    try {
      _player?.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    stopRinging();
    _player?.dispose();
  }
}
