sealed class PluginsEndPoint {
  PluginsEndPoint._();

  static const String base = '/plugins';
  static const String root = base;
  static const String installFromUrl = '$base/install_from_url';
  static const String marketplace = '$base/marketplace';
  static const String marketplaceFirstAdminVisit =
      '$base/marketplace/first_admin_visit';
  static const String marketplaceVisited = '$base/marketplace/visited';
  static const String reattach = '$base/reattach';
  static const String statuses = '$base/statuses';
  static const String webapp = '$base/webapp';
  static String webappById(String weappId) => '$webapp/$weappId';
  static String byPluginId(String pluginId) => '$base/$pluginId';
  static String detach(String pluginId) => '$base/$pluginId/detach';
  static String disable(String pluginId) => '$base/$pluginId/disable';
  static String enable(String pluginId) => '$base/$pluginId/enable';
  static String callPluginConfig = '$base/com.mattermost.calls/config';
  static String callPluginVersion = '$base/com.mattermost.calls/version';
}
