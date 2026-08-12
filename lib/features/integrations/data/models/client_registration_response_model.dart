import 'package:flutter_mattermost/features/integrations/domain/entities/client_registration_response_entity.dart';

final class ClientRegistrationResponseModel extends ClientRegistrationResponseEntity {
  const ClientRegistrationResponseModel({
    required super.client_id,
    required super.client_secret,
    required super.redirect_uris,
    required super.token_endpoint_auth_method,
    required super.grant_types,
    required super.response_types,
    required super.scope,
    required super.client_name,
    required super.client_uri,
  });

  factory ClientRegistrationResponseModel.fromMap(Map<String, dynamic> map) {
    return ClientRegistrationResponseModel(
      client_id: map["client_id"] as String?,
      client_secret: map["client_secret"] as String?,
      redirect_uris: List<String>.from(map["redirect_uris"] as List<dynamic>? ?? []),
      token_endpoint_auth_method: map["token_endpoint_auth_method"] as String?,
      grant_types: List<String>.from(map["grant_types"] as List<dynamic>? ?? []),
      response_types: List<String>.from(map["response_types"] as List<dynamic>? ?? []),
      scope: map["scope"] as String?,
      client_name: map["client_name"] as String?,
      client_uri: map["client_uri"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "client_id": client_id,
      "client_secret": client_secret,
      "redirect_uris": redirect_uris,
      "token_endpoint_auth_method": token_endpoint_auth_method,
      "grant_types": grant_types,
      "response_types": response_types,
      "scope": scope,
      "client_name": client_name,
      "client_uri": client_uri,
    };
  }

  factory ClientRegistrationResponseModel.fromEntity(ClientRegistrationResponseEntity entity) {
    return ClientRegistrationResponseModel(
      client_id: entity.client_id,
      client_secret: entity.client_secret,
      redirect_uris: entity.redirect_uris,
      token_endpoint_auth_method: entity.token_endpoint_auth_method,
      grant_types: entity.grant_types,
      response_types: entity.response_types,
      scope: entity.scope,
      client_name: entity.client_name,
      client_uri: entity.client_uri,
    );
  }

  @override
  ClientRegistrationResponseModel copyWith({
    String? client_id,
    String? client_secret,
    List<String>? redirect_uris,
    String? token_endpoint_auth_method,
    List<String>? grant_types,
    List<String>? response_types,
    String? scope,
    String? client_name,
    String? client_uri,
  }) {
    return ClientRegistrationResponseModel(
      client_id: client_id ?? this.client_id,
      client_secret: client_secret ?? this.client_secret,
      redirect_uris: redirect_uris ?? this.redirect_uris,
      token_endpoint_auth_method: token_endpoint_auth_method ?? this.token_endpoint_auth_method,
      grant_types: grant_types ?? this.grant_types,
      response_types: response_types ?? this.response_types,
      scope: scope ?? this.scope,
      client_name: client_name ?? this.client_name,
      client_uri: client_uri ?? this.client_uri,
    );
  }

  ClientRegistrationResponseEntity toEntity() => ClientRegistrationResponseEntity(
        client_id: client_id,
        client_secret: client_secret,
        redirect_uris: redirect_uris,
        token_endpoint_auth_method: token_endpoint_auth_method,
        grant_types: grant_types,
        response_types: response_types,
        scope: scope,
        client_name: client_name,
        client_uri: client_uri,
      );
}
