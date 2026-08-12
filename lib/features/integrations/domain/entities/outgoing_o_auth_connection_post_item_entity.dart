import 'package:equatable/equatable.dart';

class OutgoingOAuthConnectionPostItemEntity extends Equatable {
  final String? name;
  final String? client_id;
  final String? client_secret;
  final String? credentials_username;
  final String? credentials_password;
  final String? oauth_token_url;
  final String? grant_type;
  final String? audiences;

  const OutgoingOAuthConnectionPostItemEntity({
    this.name,
    this.client_id,
    this.client_secret,
    this.credentials_username,
    this.credentials_password,
    this.oauth_token_url,
    this.grant_type,
    this.audiences,
  });

  @override
  List<Object?> get props => [
        name,
        client_id,
        client_secret,
        credentials_username,
        credentials_password,
        oauth_token_url,
        grant_type,
        audiences,
      ];

  OutgoingOAuthConnectionPostItemEntity copyWith({
    String? name,
    String? client_id,
    String? client_secret,
    String? credentials_username,
    String? credentials_password,
    String? oauth_token_url,
    String? grant_type,
    String? audiences,
  }) {
    return OutgoingOAuthConnectionPostItemEntity(
      name: name ?? this.name,
      client_id: client_id ?? this.client_id,
      client_secret: client_secret ?? this.client_secret,
      credentials_username: credentials_username ?? this.credentials_username,
      credentials_password: credentials_password ?? this.credentials_password,
      oauth_token_url: oauth_token_url ?? this.oauth_token_url,
      grant_type: grant_type ?? this.grant_type,
      audiences: audiences ?? this.audiences,
    );
  }
}
