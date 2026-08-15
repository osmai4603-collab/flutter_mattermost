import 'package:injectable/injectable.dart';

@lazySingleton
class KeyExchangeService {
  String? _currentSessionKey;

  String? get currentSessionKey => _currentSessionKey;

  Future<void> rotateKey() async {
    // Logic to generate a new key and distribute it via secure signaling
    _currentSessionKey = 'dummy_key_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> handleRemoteKeyUpdate(String key) async {
    _currentSessionKey = key;
  }
}
