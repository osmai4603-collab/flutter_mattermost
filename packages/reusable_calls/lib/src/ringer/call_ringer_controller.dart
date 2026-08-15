/// Contract for managing call ringtone audio and system haptics.
abstract class CallRingerController {
  /// Whether ringtone is currently playing.
  bool get isRinging;

  /// Starts ringtone playback.
  void startRinging({String? customAssetPath});

  /// Stops ringtone playback.
  void stopRinging();

  /// Releases resources.
  void dispose();
}
