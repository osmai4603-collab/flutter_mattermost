import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

enum AudioOutputDevice {
  speaker,
  earpiece,
  bluetooth,
}

@lazySingleton
class AudioSessionManager {
  AudioOutputDevice _currentDevice = AudioOutputDevice.speaker;

  AudioOutputDevice get currentDevice => _currentDevice;

  /// تهيئة إعدادات الصوت للمكالمة الصوتية/المرئية
  Future<void> initializeAudioSession() async {
    try {
      await Helper.selectAudioOutput('speaker');
      _currentDevice = AudioOutputDevice.speaker;
    } catch (_) {
      // التجاهل في حال تم التعديل لاحقاً بواسطة الجهاز
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
