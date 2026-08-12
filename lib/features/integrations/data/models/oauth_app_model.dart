import 'package:flutter_mattermost/features/integrations/domain/entities/oauth_app_entity.dart';

final class OAuthAppModel extends OAuthAppEntity {
  const OAuthAppModel({
    required super.id,
    super.clientId,
    super.clientSecret,
    super.userId,
    super.name,
    super.description,
    super.iconUrl,
    super.callbackUrls,
    super.homepage,
    super.isTrusted,
    super.isOwner,
    super.createAt,
    super.updateAt,
  });

  factory OAuthAppModel.fromMap(Map<String, dynamic> data) {
    return OAuthAppModel(
      id: data['id'] ?? '',
      clientId: data['client_id'] ?? '',
      clientSecret: data['client_secret'] ?? '',
      userId: data['creator_id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['icon_url'] ?? '',
      callbackUrls: List<String>.from(data['callback_urls'] ?? const []),
      homepage: data['homepage'] ?? '',
      isTrusted: data['is_trusted'] ?? false,
      isOwner: data['is_owner'] ?? false,
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
    );
  }

  factory OAuthAppModel.fromEntity(OAuthAppEntity entity) {
    return OAuthAppModel(
      id: entity.id,
      clientId: entity.clientId,
      clientSecret: entity.clientSecret,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      iconUrl: entity.iconUrl,
      callbackUrls: entity.callbackUrls,
      homepage: entity.homepage,
      isTrusted: entity.isTrusted,
      isOwner: entity.isOwner,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'client_secret': clientSecret,
      'creator_id': userId,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'callback_urls': callbackUrls,
      'homepage': homepage,
      'is_trusted': isTrusted,
      'is_owner': isOwner,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }

  @override
  OAuthAppModel copyWith({
    String? id,
    String? clientId,
    String? clientSecret,
    String? userId,
    String? name,
    String? description,
    String? iconUrl,
    List<String>? callbackUrls,
    String? homepage,
    bool? isTrusted,
    bool? isOwner,
    int? createAt,
    int? updateAt,
  }) {
    return OAuthAppModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      callbackUrls: callbackUrls ?? this.callbackUrls,
      homepage: homepage ?? this.homepage,
      isTrusted: isTrusted ?? this.isTrusted,
      isOwner: isOwner ?? this.isOwner,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  OAuthAppEntity toEntity() {
    return OAuthAppEntity(
      id: id,
      clientId: clientId,
      clientSecret: clientSecret,
      userId: userId,
      name: name,
      description: description,
      iconUrl: iconUrl,
      callbackUrls: callbackUrls,
      homepage: homepage,
      isTrusted: isTrusted,
      isOwner: isOwner,
      createAt: createAt,
      updateAt: updateAt,
    );
  }
}
