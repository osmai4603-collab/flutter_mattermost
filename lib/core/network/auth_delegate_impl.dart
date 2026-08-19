import 'package:injectable/injectable.dart';
import 'package:osm_network/osm_network.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';

@lazySingleton
class MattermostAuthDelegate implements OsmAuthDelegate {
  final SecureStorageService _secureStorage;
  final SessionController _sessionController;

  MattermostAuthDelegate(this._secureStorage, this._sessionController);

  @override
  Future<String?> getAuthToken() async {
    return await _secureStorage.getAuthToken();
  }

  @override
  Future<String?> getCookies() async {
    return await _secureStorage.getCookies();
  }

  @override
  Future<String?> getCsrfToken() async {
    return await _secureStorage.getCsrfToken();
  }

  @override
  Future<void> onAuthenticationError() async {
    await _secureStorage.saveAuthToken('');
    _sessionController.emit(SessionEvent.expired);
  }
}
