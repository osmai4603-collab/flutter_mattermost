import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_o_auth_connection_post_item_entity.dart';

final class OutgoingOAuthConnectionPostItemModel extends OutgoingOAuthConnectionPostItemEntity {
  const OutgoingOAuthConnectionPostItemModel({
    required super.name,
    required super.client_id,
    required super.client_secret,
    required super.credentials_username,
    required super.credentials_password,
    required super.oauth_token_url,
    required super.grant_type,
    required super.audiences,
  });

  factory OutgoingOAuthConnectionPostItemModel.fromMap(Map<String, dynamic> map) {
    return OutgoingOAuthConnectionPostItemModel(
      name: map["name"] as String?,
      client_id: map["client_id"] as String?,
      client_secret: map["client_secret"] as String?,
      credentials_username: map["credentials_username"] as String?,
      credentials_password: map["credentials_password"] as String?,
      oauth_token_url: map["oauth_token_url"] as String?,
      grant_type: map["grant_type"] as String?,
      audiences: map["audiences"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "client_id": client_id,
      "client_secret": client_secret,
      "credentials_username": credentials_username,
      "credentials_password": credentials_password,
      "oauth_token_url": oauth_token_url,
      "grant_type": grant_type,
      "audiences": audiences,
    };
  }

  factory OutgoingOAuthConnectionPostItemModel.fromEntity(OutgoingOAuthConnectionPostItemEntity entity) {
    return OutgoingOAuthConnectionPostItemModel(
      name: entity.name,
      client_id: entity.client_id,
      client_secret: entity.client_secret,
      credentials_username: entity.credentials_username,
      credentials_password: entity.credentials_password,
      oauth_token_url: entity.oauth_token_url,
      grant_type: entity.grant_type,
      audiences: entity.audiences,
    );
  }

  @override
  OutgoingOAuthConnectionPostItemModel copyWith({
    String? name,
    String? client_id,
    String? client_secret,
    String? credentials_username,
    String? credentials_password,
    String? oauth_token_url,
    String? grant_type,
    String? audiences,
  }) {
    return OutgoingOAuthConnectionPostItemModel(
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

  OutgoingOAuthConnectionPostItemEntity toEntity() => OutgoingOAuthConnectionPostItemEntity(
        name: name,
        client_id: client_id,
        client_secret: client_secret,
        credentials_username: credentials_username,
        credentials_password: credentials_password,
        oauth_token_url: oauth_token_url,
        grant_type: grant_type,
        audiences: audiences,
      );
}
