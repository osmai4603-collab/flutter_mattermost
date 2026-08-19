import 'package:osm_network/osm_network.dart' as osm;
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/network/session_controller.dart';
import 'package:flutter_mattermost/core/network/auth_delegate_impl.dart';

class AuthInterceptor extends osm.AuthInterceptor {
  AuthInterceptor(
    SecureStorageService secureStorage,
    SessionController sessionController,
  ) : super(
          MattermostAuthDelegate(secureStorage, sessionController),
          sessionController: sessionController,
        );
}
