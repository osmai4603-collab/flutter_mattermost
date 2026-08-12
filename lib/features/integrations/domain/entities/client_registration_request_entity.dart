import 'package:equatable/equatable.dart';

class ClientRegistrationRequestEntity extends Equatable {
  final List<String>? redirect_uris;
  final String? client_name;
  final String? client_uri;

  const ClientRegistrationRequestEntity({
    required this.redirect_uris,
    this.client_name,
    this.client_uri,
  });

  @override
  List<Object?> get props => [
        redirect_uris,
        client_name,
        client_uri,
      ];

  ClientRegistrationRequestEntity copyWith({
    List<String>? redirect_uris,
    String? client_name,
    String? client_uri,
  }) {
    return ClientRegistrationRequestEntity(
      redirect_uris: redirect_uris ?? this.redirect_uris,
      client_name: client_name ?? this.client_name,
      client_uri: client_uri ?? this.client_uri,
    );
  }
}
