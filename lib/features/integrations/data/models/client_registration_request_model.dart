import 'package:flutter_mattermost/features/integrations/domain/entities/client_registration_request_entity.dart';

final class ClientRegistrationRequestModel extends ClientRegistrationRequestEntity {
  const ClientRegistrationRequestModel({
    required super.redirect_uris,
    required super.client_name,
    required super.client_uri,
  });

  factory ClientRegistrationRequestModel.fromMap(Map<String, dynamic> map) {
    return ClientRegistrationRequestModel(
      redirect_uris: List<String>.from(map["redirect_uris"] as List<dynamic>? ?? []),
      client_name: map["client_name"] as String?,
      client_uri: map["client_uri"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "redirect_uris": redirect_uris,
      "client_name": client_name,
      "client_uri": client_uri,
    };
  }

  factory ClientRegistrationRequestModel.fromEntity(ClientRegistrationRequestEntity entity) {
    return ClientRegistrationRequestModel(
      redirect_uris: entity.redirect_uris,
      client_name: entity.client_name,
      client_uri: entity.client_uri,
    );
  }

  @override
  ClientRegistrationRequestModel copyWith({
    List<String>? redirect_uris,
    String? client_name,
    String? client_uri,
  }) {
    return ClientRegistrationRequestModel(
      redirect_uris: redirect_uris ?? this.redirect_uris,
      client_name: client_name ?? this.client_name,
      client_uri: client_uri ?? this.client_uri,
    );
  }

  ClientRegistrationRequestEntity toEntity() => ClientRegistrationRequestEntity(
        redirect_uris: redirect_uris,
        client_name: client_name,
        client_uri: client_uri,
      );
}
