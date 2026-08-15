import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class E2EEEngine {
  final Map<String, FrameCryptor> _frameCryptors = {};
  KeyProvider? _keyProvider;
  bool _enabled = false;

  bool get isEnabled => _enabled;

  Future<void> setupE2EE(RTCPeerConnection pc, String key) async {
    _enabled = true;

    final keyProvider = await frameCryptorFactory.createDefaultKeyProvider(
      KeyProviderOptions(
        sharedKey: true,
        ratchetSalt: Uint8List.fromList(List.filled(32, 1)),
        ratchetWindowSize: 1,
      ),
    );
    await keyProvider.setSharedKey(key: Uint8List.fromList(key.codeUnits));
    _keyProvider = keyProvider;

    final senders = await pc.getSenders();
    for (final sender in senders) {
      if (sender.track != null) {
        final fc = await frameCryptorFactory.createFrameCryptorForRtpSender(
          participantId: 'local',
          sender: sender,
          algorithm: Algorithm.kAesGcm,
          keyProvider: keyProvider,
        );
        await fc.setEnabled(true);
        await fc.setKeyIndex(0);
        _frameCryptors['local_${sender.track!.id}'] = fc;
      }
    }
  }

  Future<void> dispose() async {
    for (final fc in _frameCryptors.values) {
      await fc.dispose();
    }
    _frameCryptors.clear();
    await _keyProvider?.dispose();
    _keyProvider = null;
    _enabled = false;
  }
}
