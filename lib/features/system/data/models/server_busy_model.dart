import 'package:flutter_mattermost/features/system/domain/entities/server_busy_entity.dart';

final class ServerBusyModel extends ServerBusyEntity {
  const ServerBusyModel({
    required super.busy,
    required super.expires,
  });

  factory ServerBusyModel.fromMap(Map<String, dynamic> map) {
    return ServerBusyModel(
      busy: map["busy"] as bool?,
      expires: (map["expires"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "busy": busy,
      "expires": expires,
    };
  }

  factory ServerBusyModel.fromEntity(ServerBusyEntity entity) {
    return ServerBusyModel(
      busy: entity.busy,
      expires: entity.expires,
    );
  }

  @override
  ServerBusyModel copyWith({
    bool? busy,
    int? expires,
  }) {
    return ServerBusyModel(
      busy: busy ?? this.busy,
      expires: expires ?? this.expires,
    );
  }

  ServerBusyEntity toEntity() => ServerBusyEntity(
        busy: busy,
        expires: expires,
      );
}
