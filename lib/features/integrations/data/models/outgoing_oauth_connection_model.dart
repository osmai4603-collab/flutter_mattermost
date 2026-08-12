import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_oauth_connection_entity.dart';

final class OutgoingOAuthConnectionModel extends OutgoingOAuthConnectionEntity {
  const OutgoingOAuthConnectionModel({
    super.id,
    super.clientId,
    super.clientSecret,
    super.scopes,
    super.grantType,
    super.tokenUrl,
    super.userId,
    super.audience,
    super.baseRedirectUrl,
    super.redirectUrls,
    super.createAt,
    super.updateAt,
    super.deleteAt,
  });

  factory OutgoingOAuthConnectionModel.fromMap(Map<String, dynamic> data) {
    return OutgoingOAuthConnectionModel(
      id: data['id'] ?? '',
      clientId: data['client_id'] ?? '',
      clientSecret: data['client_secret'] ?? '',
      scopes: data['scopes'] ?? '',
      grantType: data['grant_type'] ?? '',
      tokenUrl: data['token_url'] ?? '',
      userId: data['user_id'] ?? '',
      audience: data['audience'] ?? '',
      baseRedirectUrl: data['base_redirect_url'] ?? '',
      redirectUrls: List<String>.from(data['redirect_urls'] ?? const []),
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
    );
  }

  factory OutgoingOAuthConnectionModel.fromEntity(
    OutgoingOAuthConnectionEntity entity,
  ) {
    return OutgoingOAuthConnectionModel(
      id: entity.id,
      clientId: entity.clientId,
      clientSecret: entity.clientSecret,
      scopes: entity.scopes,
      grantType: entity.grantType,
      tokenUrl: entity.tokenUrl,
      userId: entity.userId,
      audience: entity.audience,
      baseRedirectUrl: entity.baseRedirectUrl,
      redirectUrls: entity.redirectUrls,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'client_secret': clientSecret,
      'scopes': scopes,
      'grant_type': grantType,
      'token_url': tokenUrl,
      'user_id': userId,
      'audience': audience,
      'base_redirect_url': baseRedirectUrl,
      'redirect_urls': redirectUrls,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
    };
  }

  @override
  OutgoingOAuthConnectionModel copyWith({
    String? id,
    String? clientId,
    String? clientSecret,
    String? scopes,
    String? grantType,
    String? tokenUrl,
    String? userId,
    String? audience,
    String? baseRedirectUrl,
    List<String>? redirectUrls,
    int? createAt,
    int? updateAt,
    int? deleteAt,
  }) {
    return OutgoingOAuthConnectionModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      scopes: scopes ?? this.scopes,
      grantType: grantType ?? this.grantType,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      userId: userId ?? this.userId,
      audience: audience ?? this.audience,
      baseRedirectUrl: baseRedirectUrl ?? this.baseRedirectUrl,
      redirectUrls: redirectUrls ?? this.redirectUrls,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }

  OutgoingOAuthConnectionEntity toEntity() {
    return OutgoingOAuthConnectionEntity(
      id: id,
      clientId: clientId,
      clientSecret: clientSecret,
      scopes: scopes,
      grantType: grantType,
      tokenUrl: tokenUrl,
      userId: userId,
      audience: audience,
      baseRedirectUrl: baseRedirectUrl,
      redirectUrls: redirectUrls,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
    );
  }
}
