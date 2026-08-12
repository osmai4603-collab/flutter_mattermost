import 'package:flutter_mattermost/core/entities/entity.dart';

class OutgoingOAuthConnectionEntity extends Entity {
  final String id;
  final String clientId;
  final String clientSecret;
  final String scopes;
  final String grantType;
  final String tokenUrl;
  final String userId;
  final String audience;
  final String baseRedirectUrl;
  final List<String> redirectUrls;
  final int createAt;
  final int updateAt;
  final int deleteAt;

  const OutgoingOAuthConnectionEntity({
    this.id = '',
    this.clientId = '',
    this.clientSecret = '',
    this.scopes = '',
    this.grantType = '',
    this.tokenUrl = '',
    this.userId = '',
    this.audience = '',
    this.baseRedirectUrl = '',
    this.redirectUrls = const [],
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        clientSecret,
        scopes,
        grantType,
        tokenUrl,
        userId,
        audience,
        baseRedirectUrl,
        redirectUrls,
        createAt,
        updateAt,
        deleteAt,
      ];

  @override
  OutgoingOAuthConnectionEntity copyWith({
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
    return OutgoingOAuthConnectionEntity(
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
}
