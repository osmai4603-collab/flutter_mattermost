import 'package:flutter_mattermost/features/integrations/domain/entities/oauth_app_entity.dart';

abstract class OAuthRepository {
  Future<List<OAuthAppEntity>> getOAuthApps();
  Future<OAuthAppEntity> registerOAuthApp({
    required String name,
    String description,
    String homepage,
    List<String> callbackUrls,
    bool isTrusted,
    String iconUrl,
  });
  Future<OAuthAppEntity> updateOAuthApp(
    String appId, {
    String? name,
    String? description,
    String? homepage,
    List<String>? callbackUrls,
    bool? isTrusted,
    String? iconUrl,
  });
  Future<void> deleteOAuthApp(String appId);
  Future<String> regenerateOAuthAppSecret(String appId);
}
