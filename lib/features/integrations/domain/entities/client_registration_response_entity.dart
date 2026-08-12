import 'package:equatable/equatable.dart';

class ClientRegistrationResponseEntity extends Equatable {
  final String? client_id;
  final String? client_secret;
  final List<String>? redirect_uris;
  final String? token_endpoint_auth_method;
  final List<String>? grant_types;
  final List<String>? response_types;
  final String? scope;
  final String? client_name;
  final String? client_uri;

  const ClientRegistrationResponseEntity({
    this.client_id,
    this.client_secret,
    this.redirect_uris,
    this.token_endpoint_auth_method,
    this.grant_types,
    this.response_types,
    this.scope,
    this.client_name,
    this.client_uri,
  });

  @override
  List<Object?> get props => [
        client_id,
        client_secret,
        redirect_uris,
        token_endpoint_auth_method,
        grant_types,
        response_types,
        scope,
        client_name,
        client_uri,
      ];

  ClientRegistrationResponseEntity copyWith({
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
    return ClientRegistrationResponseEntity(
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
}
