import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart';

enum AudioOutputDevice {
  speaker,
  earpiece,
  bluetooth,
}

@lazySingleton
class AudioSessionManager {
  AudioOutputDevice _currentDevice = AudioOutputDevice.speaker;
  StreamSubscription<int>? _proximitySubscription;
  bool _isProximityEnabled = false;

  AudioOutputDevice get currentDevice => _currentDevice;

  /// تشغيل جلسة الصوت للمكالمة: ضمان جلسة iOS النشطة + وضع voice-chat
  /// (playAndRecord على Android عبر getUserMedia) مع توجيه تلقائي
  /// للسماعة/البلوتوث عند توفره.
  Future<void> activateAudioSession() async {
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        await Helper.ensureAudioSession();
        await Helper.setSpeakerphoneOnButPreferBluetooth();
      }
      _currentDevice = AudioOutputDevice.speaker;
      
      // Enable wake lock to keep screen on
      if (!kIsWeb) {
        await WakelockPlus.enable();
      }
      
      // Start proximity sensor if on mobile
      _startProximitySensor();

    } catch (_) {
      // التجاهل في حال تم التعديل لاحقاً بواسطة الجهاز
    }
  }

  void _startProximitySensor() {
    if (kIsWeb || (!defaultTargetPlatform.name.contains('android') && !defaultTargetPlatform.name.contains('ios'))) {
      return;
    }

    _proximitySubscription?.cancel();
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      // event = 1 means near, 0 means far
      _isProximityEnabled = event > 0;
      if (_isProximityEnabled) {
        // Screen should be turned off or dimmed if near ear
        // WebRTC helper might handle some of this, but we can also use setSpeakerphoneOn(false)
        if (_currentDevice == AudioOutputDevice.speaker) {
          setAudioOutput(AudioOutputDevice.earpiece);
        }
      }
    });
  }

  /// تهيئة إعدادات الصوت للمكالمة الصوتية/المرئية (اسم تاريخي — نفس activate).
  Future<void> initializeAudioSession() => activateAudioSession();

  /// إيقاف جلسة الصوت بعد نهاية المكالمة — العودة للوضع الطبيعي (سماعة الأذن).
  Future<void> deactivateAudioSession() async {
    try {
      await Helper.setSpeakerphoneOn(false);
      await WakelockPlus.disable();
      _proximitySubscription?.cancel();
      _proximitySubscription = null;
    } catch (_) {
      // التجاهل — قد لا تدعم المنصة الإيقاف الفوري
    }
  }

  /// التبديل بين السماعة الخارجية والسماعة الداخلية وسماعة البلوتوث
  Future<void> setAudioOutput(AudioOutputDevice device) async {
    _currentDevice = device;
    try {
      switch (device) {
        case AudioOutputDevice.speaker:
          await Helper.selectAudioOutput('speaker');
          break;
        case AudioOutputDevice.earpiece:
          await Helper.selectAudioOutput('earpiece');
          break;
        case AudioOutputDevice.bluetooth:
          await Helper.selectAudioOutput('bluetooth');
          break;
      }
    } catch (_) {
      // التعامل المحمي عند عدم دعم المخرج الشبكي الحالي
    }
  }

  /// التبديل التلقائي السريع بين السماعة الخارجية والسماعة الداخلية
  Future<AudioOutputDevice> toggleSpeaker() async {
    if (_currentDevice == AudioOutputDevice.speaker) {
      await setAudioOutput(AudioOutputDevice.earpiece);
    } else {
      await setAudioOutput(AudioOutputDevice.speaker);
    }
    return _currentDevice;
  }
}
