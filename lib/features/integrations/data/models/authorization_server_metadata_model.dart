import 'package:flutter_mattermost/features/integrations/domain/entities/authorization_server_metadata_entity.dart';

final class AuthorizationServerMetadataModel
    extends AuthorizationServerMetadataEntity {
  const AuthorizationServerMetadataModel({
    required super.issuer,
    required super.authorization_endpoint,
    required super.token_endpoint,
    required super.response_types_supported,
    required super.registration_endpoint,
    required super.scopes_supported,
    required super.grant_types_supported,
    required super.token_endpoint_auth_methods_supported,
    required super.code_challenge_methods_supported,
  });

  factory AuthorizationServerMetadataModel.fromMap(Map<String, dynamic> map) {
    return AuthorizationServerMetadataModel(
      issuer: map["issuer"] as String?,
      authorization_endpoint: map["authorization_endpoint"] as String?,
      token_endpoint: map["token_endpoint"] as String?,
      response_types_supported: List<String>.from(
        map["response_types_supported"] as List<dynamic>? ?? [],
      ),
      registration_endpoint: map["registration_endpoint"] as String?,
      scopes_supported: List<String>.from(
        map["scopes_supported"] as List<dynamic>? ?? [],
      ),
      grant_types_supported: List<String>.from(
        map["grant_types_supported"] as List<dynamic>? ?? [],
      ),
      token_endpoint_auth_methods_supported: List<String>.from(
        map["token_endpoint_auth_methods_supported"] as List<dynamic>? ?? [],
      ),
      code_challenge_methods_supported: List<String>.from(
        map["code_challenge_methods_supported"] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "issuer": issuer,
      "authorization_endpoint": authorization_endpoint,
      "token_endpoint": token_endpoint,
      "response_types_supported": response_types_supported,
      "registration_endpoint": registration_endpoint,
      "scopes_supported": scopes_supported,
      "grant_types_supported": grant_types_supported,
      "token_endpoint_auth_methods_supported":
          token_endpoint_auth_methods_supported,
      "code_challenge_methods_supported": code_challenge_methods_supported,
    };
  }

  factory AuthorizationServerMetadataModel.fromEntity(
    AuthorizationServerMetadataEntity entity,
  ) {
    return AuthorizationServerMetadataModel(
      issuer: entity.issuer,
      authorization_endpoint: entity.authorization_endpoint,
      token_endpoint: entity.token_endpoint,
      response_types_supported: entity.response_types_supported,
      registration_endpoint: entity.registration_endpoint,
      scopes_supported: entity.scopes_supported,
      grant_types_supported: entity.grant_types_supported,
      token_endpoint_auth_methods_supported:
          entity.token_endpoint_auth_methods_supported,
      code_challenge_methods_supported: entity.code_challenge_methods_supported,
    );
  }

  @override
  AuthorizationServerMetadataModel copyWith({
    String? issuer,
    String? authorization_endpoint,
    String? token_endpoint,
    List<String>? response_types_supported,
    String? registration_endpoint,
    List<String>? scopes_supported,
    List<String>? grant_types_supported,
    List<String>? token_endpoint_auth_methods_supported,
    List<String>? code_challenge_methods_supported,
  }) {
    return AuthorizationServerMetadataModel(
      issuer: issuer ?? this.issuer,
      authorization_endpoint:
          authorization_endpoint ?? this.authorization_endpoint,
      token_endpoint: token_endpoint ?? this.token_endpoint,
      response_types_supported:
          response_types_supported ?? this.response_types_supported,
      registration_endpoint:
          registration_endpoint ?? this.registration_endpoint,
      scopes_supported: scopes_supported ?? this.scopes_supported,
      grant_types_supported:
          grant_types_supported ?? this.grant_types_supported,
      token_endpoint_auth_methods_supported:
          token_endpoint_auth_methods_supported ??
          this.token_endpoint_auth_methods_supported,
      code_challenge_methods_supported:
          code_challenge_methods_supported ??
          this.code_challenge_methods_supported,
    );
  }

  AuthorizationServerMetadataEntity toEntity() =>
      AuthorizationServerMetadataEntity(
        issuer: issuer,
        authorization_endpoint: authorization_endpoint,
        token_endpoint: token_endpoint,
        response_types_supported: response_types_supported,
        registration_endpoint: registration_endpoint,
        scopes_supported: scopes_supported,
        grant_types_supported: grant_types_supported,
        token_endpoint_auth_methods_supported:
            token_endpoint_auth_methods_supported,
        code_challenge_methods_supported: code_challenge_methods_supported,
      );
}
