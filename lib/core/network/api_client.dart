import 'package:injectable/injectable.dart';
import 'package:osm_network/osm_network.dart' as osm;
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/network/session_controller.dart';
import 'package:flutter_mattermost/core/network/auth_delegate_impl.dart';

export 'package:osm_network/osm_network.dart' show ContentType, AcceptType;

@lazySingleton
class ApiClient extends osm.OsmApiClient {
  ApiClient(
    SecureStorageService secureStorage,
    SessionController sessionController,
  ) : super(
          config: osm.OsmNetworkConfig(
            baseUrl: AppConfig.defaultBaseUrl,
            connectTimeout: AppConfig.connectionTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            maxRetries: AppConfig.maxRetryAttempts,
            unauthenticatedPaths: const ['/api/v4/users/login'],
          ),
          authDelegate: MattermostAuthDelegate(secureStorage, sessionController),
          sessionController: sessionController,
        );
}
