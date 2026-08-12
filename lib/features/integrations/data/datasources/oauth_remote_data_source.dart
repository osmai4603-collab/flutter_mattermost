import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/integrations/data/models/oauth_app_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/outgoing_oauth_connection_model.dart';

abstract class OAuthRemoteDataSource {
  Future<List<OAuthAppModel>> getOAuthApps({
    int page = 0,
    int perPage = 60,
    bool includeIcon = false,
  });
  Future<OAuthAppModel> registerOAuthApp({
    required String name,
    String description = '',
    String homepage = '',
    List<String> callbackUrls = const [],
    bool isTrusted = false,
    String iconUrl = '',
  });
  Future<OAuthAppModel> getOAuthApp(String appId);
  Future<OAuthAppModel> updateOAuthApp(
    String appId, {
    String? name,
    String? description,
    String? homepage,
    List<String>? callbackUrls,
    bool? isTrusted,
    String? iconUrl,
  });
  Future<void> deleteOAuthApp(String appId);
  Future<OAuthAppModel> regenerateOAuthAppSecret(String appId);

  Future<List<OutgoingOAuthConnectionModel>> getOutgoingOAuthConnections({
    int page = 0,
    int perPage = 60,
  });
  Future<OutgoingOAuthConnectionModel> createOutgoingOAuthConnection(
    Map<String, dynamic> connection,
  );
  Future<Map<String, dynamic>> validateOutgoingOAuthConnection(
    Map<String, dynamic> connection,
  );
  Future<OutgoingOAuthConnectionModel> getOutgoingOAuthConnection(
    String connectionId,
  );
  Future<OutgoingOAuthConnectionModel> updateOutgoingOAuthConnection(
    String connectionId,
    Map<String, dynamic> connection,
  );
  Future<void> deleteOutgoingOAuthConnection(String connectionId);
  Future<Map<String, dynamic>> getAuthorizationServerMetadata();
}

@LazySingleton(as: OAuthRemoteDataSource)
class OAuthRemoteDataSourceImpl implements OAuthRemoteDataSource {
  final ApiClient _apiClient;

  OAuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<OAuthAppModel>> getOAuthApps({
    int page = 0,
    int perPage = 60,
    bool includeIcon = false,
  }) async {
    final result = await _apiClient.get<List<OAuthAppModel>>(
      OAuthEndPoint.apps,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'include_icon': includeIcon,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => OAuthAppModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<OAuthAppModel>>) {
      return result.data;
    }
    throw Exception('Failed to get OAuth apps');
  }

  @override
  Future<OAuthAppModel> registerOAuthApp({
    required String name,
    String description = '',
    String homepage = '',
    List<String> callbackUrls = const [],
    bool isTrusted = false,
    String iconUrl = '',
  }) async {
    final result = await _apiClient.post<OAuthAppModel>(
      OAuthEndPoint.appsRegister,
      data: {
        'name': name,
        'description': description,
        'homepage': homepage,
        'callback_urls': callbackUrls,
        'is_trusted': isTrusted,
        'icon_url': iconUrl,
      },
      fromJson: (json) => OAuthAppModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OAuthAppModel>) {
      return result.data;
    }
    throw Exception('Failed to register OAuth app');
  }

  @override
  Future<OAuthAppModel> getOAuthApp(String appId) async {
    final result = await _apiClient.get<OAuthAppModel>(
      OAuthEndPoint.appsInfo(appId),
      fromJson: (json) => OAuthAppModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OAuthAppModel>) {
      return result.data;
    }
    throw Exception('Failed to get OAuth app');
  }

  @override
  Future<OAuthAppModel> updateOAuthApp(
    String appId, {
    String? name,
    String? description,
    String? homepage,
    List<String>? callbackUrls,
    bool? isTrusted,
    String? iconUrl,
  }) async {
    final result = await _apiClient.put<OAuthAppModel>(
      OAuthEndPoint.apps2(appId),
      data: {
        'name': name,
        'description': description,
        'homepage': homepage,
        'callback_urls': callbackUrls,
        'is_trusted': isTrusted,
        'icon_url': iconUrl,
      },
      fromJson: (json) => OAuthAppModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OAuthAppModel>) {
      return result.data;
    }
    throw Exception('Failed to update OAuth app');
  }

  @override
  Future<void> deleteOAuthApp(String appId) async {
    final result = await _apiClient.delete(OAuthEndPoint.apps2(appId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete OAuth app');
    }
  }

  @override
  Future<OAuthAppModel> regenerateOAuthAppSecret(String appId) async {
    final result = await _apiClient.post<OAuthAppModel>(
      OAuthEndPoint.appsRegenSecret(appId),
      fromJson: (json) => OAuthAppModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OAuthAppModel>) {
      return result.data;
    }
    throw Exception('Failed to regenerate OAuth app secret');
  }

  @override
  Future<List<OutgoingOAuthConnectionModel>> getOutgoingOAuthConnections({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<OutgoingOAuthConnectionModel>>(
      OAuthEndPoint.outgoingConnections,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) =>
                OutgoingOAuthConnectionModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<OutgoingOAuthConnectionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get outgoing OAuth connections');
  }

  @override
  Future<OutgoingOAuthConnectionModel> createOutgoingOAuthConnection(
    Map<String, dynamic> connection,
  ) async {
    final result = await _apiClient.post<OutgoingOAuthConnectionModel>(
      OAuthEndPoint.outgoingConnections,
      data: connection,
      fromJson: (json) =>
          OutgoingOAuthConnectionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingOAuthConnectionModel>) {
      return result.data;
    }
    throw Exception('Failed to create outgoing OAuth connection');
  }

  @override
  Future<Map<String, dynamic>> validateOutgoingOAuthConnection(
    Map<String, dynamic> connection,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      OAuthEndPoint.outgoingConnectionsValidate,
      data: connection,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to validate outgoing OAuth connection');
  }

  @override
  Future<OutgoingOAuthConnectionModel> getOutgoingOAuthConnection(
    String connectionId,
  ) async {
    final result = await _apiClient.get<OutgoingOAuthConnectionModel>(
      OAuthEndPoint.outgoingConnections2(connectionId),
      fromJson: (json) =>
          OutgoingOAuthConnectionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingOAuthConnectionModel>) {
      return result.data;
    }
    throw Exception('Failed to get outgoing OAuth connection');
  }

  @override
  Future<OutgoingOAuthConnectionModel> updateOutgoingOAuthConnection(
    String connectionId,
    Map<String, dynamic> connection,
  ) async {
    final result = await _apiClient.put<OutgoingOAuthConnectionModel>(
      OAuthEndPoint.outgoingConnections2(connectionId),
      data: connection,
      fromJson: (json) =>
          OutgoingOAuthConnectionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingOAuthConnectionModel>) {
      return result.data;
    }
    throw Exception('Failed to update outgoing OAuth connection');
  }

  @override
  Future<void> deleteOutgoingOAuthConnection(String connectionId) async {
    final result = await _apiClient.delete(
      OAuthEndPoint.outgoingConnections2(connectionId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete outgoing OAuth connection');
    }
  }

  @override
  Future<Map<String, dynamic>> getAuthorizationServerMetadata() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      OAuthEndPoint.authorizationServerMetadata,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get authorization server metadata');
  }
}
