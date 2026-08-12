import 'package:equatable/equatable.dart';

class AuthorizationServerMetadataEntity extends Equatable {
  final String? issuer;
  final String? authorization_endpoint;
  final String? token_endpoint;
  final List<String>? response_types_supported;
  final String? registration_endpoint;
  final List<String>? scopes_supported;
  final List<String>? grant_types_supported;
  final List<String>? token_endpoint_auth_methods_supported;
  final List<String>? code_challenge_methods_supported;

  const AuthorizationServerMetadataEntity({
    required this.issuer,
    this.authorization_endpoint,
    this.token_endpoint,
    required this.response_types_supported,
    this.registration_endpoint,
    this.scopes_supported,
    this.grant_types_supported,
    this.token_endpoint_auth_methods_supported,
    this.code_challenge_methods_supported,
  });

  @override
  List<Object?> get props => [
        issuer,
        authorization_endpoint,
        token_endpoint,
        response_types_supported,
        registration_endpoint,
        scopes_supported,
        grant_types_supported,
        token_endpoint_auth_methods_supported,
        code_challenge_methods_supported,
      ];

  AuthorizationServerMetadataEntity copyWith({
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
    return AuthorizationServerMetadataEntity(
      issuer: issuer ?? this.issuer,
      authorization_endpoint: authorization_endpoint ?? this.authorization_endpoint,
      token_endpoint: token_endpoint ?? this.token_endpoint,
      response_types_supported: response_types_supported ?? this.response_types_supported,
      registration_endpoint: registration_endpoint ?? this.registration_endpoint,
      scopes_supported: scopes_supported ?? this.scopes_supported,
      grant_types_supported: grant_types_supported ?? this.grant_types_supported,
      token_endpoint_auth_methods_supported: token_endpoint_auth_methods_supported ?? this.token_endpoint_auth_methods_supported,
      code_challenge_methods_supported: code_challenge_methods_supported ?? this.code_challenge_methods_supported,
    );
  }
}
