import 'package:injectable/injectable.dart';
import 'package:osm_network/osm_network.dart' as osm;
import 'package:flutter_mattermost/app/config/app_config.dart';

@singleton
class ServerManager extends osm.ServerManager {
  ServerManager(super.apiClient)
      : super(initialServerUrl: AppConfig.defaultBaseUrl);
}
