import 'package:equatable/equatable.dart';

class ServerBusyEntity extends Equatable {
  final bool? busy;
  final int? expires;

  const ServerBusyEntity({
    this.busy,
    this.expires,
  });

  @override
  List<Object?> get props => [
        busy,
        expires,
      ];

  ServerBusyEntity copyWith({
    bool? busy,
    int? expires,
  }) {
    return ServerBusyEntity(
      busy: busy ?? this.busy,
      expires: expires ?? this.expires,
    );
  }
}
