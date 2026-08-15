import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:reusable_calls/src/media/audio_output_device.dart';
import 'package:reusable_calls/src/media/audio_session_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Default realization of [AudioSessionController] using `flutter_webrtc`, `wakelock_plus`, and `proximity_sensor`.
class DefaultAudioSessionController implements AudioSessionController {
  AudioOutputDevice _currentDevice = AudioOutputDevice.speaker;
  StreamSubscription<int>? _proximitySubscription;

  @override
  AudioOutputDevice get currentDevice => _currentDevice;

  @override
  Future<void> activateAudioSession() async {
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        await Helper.ensureAudioSession();
        await Helper.setSpeakerphoneOnButPreferBluetooth();
      }
      _currentDevice = AudioOutputDevice.speaker;

      if (!kIsWeb) {
        await WakelockPlus.enable();
      }

      _startProximitySensor();
    } catch (_) {
      // Ignore platform limitations
    }
  }

  void _startProximitySensor() {
    if (kIsWeb ||
        (!defaultTargetPlatform.name.contains('android') &&
            !defaultTargetPlatform.name.contains('ios'))) {
      return;
    }

    _proximitySubscription?.cancel();
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      final isNear = event > 0;
      if (isNear && _currentDevice == AudioOutputDevice.speaker) {
        setSpeakerphoneOn(false);
      }
    });
  }

  @override
  Future<void> setAudioOutput(AudioOutputDevice device) async {
    try {
      if (device == AudioOutputDevice.speaker) {
        await Helper.setSpeakerphoneOn(true);
      } else {
        await Helper.setSpeakerphoneOn(false);
      }
      _currentDevice = device;
    } catch (_) {}
  }

  Future<void> setSpeakerphoneOn(bool enable) async {
    try {
      await Helper.setSpeakerphoneOn(enable);
    } catch (_) {}
  }

  @override
  Future<void> deactivateAudioSession() async {
    try {
      _proximitySubscription?.cancel();
      if (!kIsWeb) {
        await WakelockPlus.disable();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    deactivateAudioSession();
  }
}
