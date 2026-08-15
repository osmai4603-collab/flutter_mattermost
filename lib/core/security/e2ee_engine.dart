import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class E2EEEngine {
  final Map<String, FrameCryptor> _frameCryptors = {};
  bool _enabled = false;

  bool get isEnabled => _enabled;

  Future<void> setupE2EE(RTCPeerConnection pc, String key) async {
    _enabled = true;
    
    // In a real implementation, we'd iterate over senders and receivers
    // and attach FrameCryptors using the provided key.
    
    final senders = await pc.getSenders();
    for (var sender in senders) {
      if (sender.track != null) {
        final fc = await FrameCryptorFactory.instance.createFrameCryptorForRtpSender(
          participantId: 'local',
          sender: sender,
          algorithm: Algorithm.AES_GCM,
          key: Uint8List.fromList(key.codeUnits),
        );
        await fc.setEnabled(true);
        await fc.setKeyIndex(0);
        _frameCryptors['local_${sender.track!.id}'] = fc;
      }
    }

    // Similar logic for receivers...
  }

  Future<void> dispose() async {
    for (var fc in _frameCryptors.values) {
      await fc.dispose();
    }
    _frameCryptors.clear();
    _enabled = false;
  }
}
