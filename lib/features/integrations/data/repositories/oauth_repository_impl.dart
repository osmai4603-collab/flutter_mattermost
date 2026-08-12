import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/oauth_remote_data_source.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/oauth_app_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/oauth_repository.dart';

@LazySingleton(as: OAuthRepository)
class OAuthRepositoryImpl implements OAuthRepository {
  final OAuthRemoteDataSource _remoteDataSource;

  OAuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<OAuthAppEntity>> getOAuthApps() async {
    final models = await _remoteDataSource.getOAuthApps();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<OAuthAppEntity> registerOAuthApp({
    required String name,
    String description = '',
    String homepage = '',
    List<String> callbackUrls = const [],
    bool isTrusted = false,
    String iconUrl = '',
  }) async {
    final model = await _remoteDataSource.registerOAuthApp(
      name: name,
      description: description,
      homepage: homepage,
      callbackUrls: callbackUrls,
      isTrusted: isTrusted,
      iconUrl: iconUrl,
    );
    return model.toEntity();
  }

  @override
  Future<OAuthAppEntity> updateOAuthApp(
    String appId, {
    String? name,
    String? description,
    String? homepage,
    List<String>? callbackUrls,
    bool? isTrusted,
    String? iconUrl,
  }) async {
    final model = await _remoteDataSource.updateOAuthApp(
      appId,
      name: name,
      description: description,
      homepage: homepage,
      callbackUrls: callbackUrls,
      isTrusted: isTrusted,
      iconUrl: iconUrl,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteOAuthApp(String appId) async {
    await _remoteDataSource.deleteOAuthApp(appId);
  }

  @override
  Future<String> regenerateOAuthAppSecret(String appId) async {
    final model = await _remoteDataSource.regenerateOAuthAppSecret(appId);
    return model.clientSecret;
  }
}
