import 'package:flutter_mattermost/core/entities/entity.dart';

class OAuthAppEntity extends Entity {
  final String id;
  final String clientId;
  final String clientSecret;
  final String userId;
  final String name;
  final String description;
  final String iconUrl;
  final List<String> callbackUrls;
  final String homepage;
  final bool isTrusted;
  final bool isOwner;
  final int createAt;
  final int updateAt;

  const OAuthAppEntity({
    required this.id,
    this.clientId = '',
    this.clientSecret = '',
    this.userId = '',
    this.name = '',
    this.description = '',
    this.iconUrl = '',
    this.callbackUrls = const [],
    this.homepage = '',
    this.isTrusted = false,
    this.isOwner = false,
    this.createAt = 0,
    this.updateAt = 0,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        clientSecret,
        userId,
        name,
        description,
        iconUrl,
        callbackUrls,
        homepage,
            isTrusted,
        isOwner,
        createAt,
        updateAt,
      ];

  @override
  OAuthAppEntity copyWith({
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
    return OAuthAppEntity(
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
}
