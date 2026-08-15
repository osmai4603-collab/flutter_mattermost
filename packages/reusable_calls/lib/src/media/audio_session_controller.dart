import 'package:reusable_calls/src/media/audio_output_device.dart';

/// Contract for managing mobile/desktop audio sessions, wake locks, and proximity sensors.
abstract class AudioSessionController {
  /// Current audio output target.
  AudioOutputDevice get currentDevice;

  /// Activates voice-chat audio mode and Wakelock.
  Future<void> activateAudioSession();

  /// Deactivates audio session and releases hardware locks.
  Future<void> deactivateAudioSession();

  /// Switches audio output route (speaker/earpiece/bluetooth).
  Future<void> setAudioOutput(AudioOutputDevice device);

  /// Releases resources.
  void dispose();
}
