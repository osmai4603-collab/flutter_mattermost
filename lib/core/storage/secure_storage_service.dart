import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({@ignoreParam FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            mOptions: MacOsOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyServerUrl = 'server_url';
  static const String _keyUserId = 'user_id';
  static const String _keyCookies = 'auth_cookies';
  static const String _keyCsrfToken = 'csrf_token';

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> saveServerUrl(String url) async {
    await _storage.write(key: _keyServerUrl, value: url);
  }

  Future<String?> getServerUrl() async {
    return await _storage.read(key: _keyServerUrl);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> saveCookies(String cookies) async {
    await _storage.write(key: _keyCookies, value: cookies);
  }

  Future<String?> getCookies() async {
    return await _storage.read(key: _keyCookies);
  }

  Future<void> saveCsrfToken(String token) async {
    await _storage.write(key: _keyCsrfToken, value: token);
  }

  Future<String?> getCsrfToken() async {
    return await _storage.read(key: _keyCsrfToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
