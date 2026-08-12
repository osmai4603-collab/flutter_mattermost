import 'package:flutter_mattermost/features/admin/domain/entities/log_entry_entity.dart';

final class LogEntryModel extends LogEntryEntity {
  const LogEntryModel({
    required super.level,
    required super.message,
    required super.time,
    required super.caller,
  });

  factory LogEntryModel.fromMap(Map<String, dynamic> map) {
    return LogEntryModel(
      level: map["level"] as String?,
      message: map["message"] as String?,
      time: map["time"] as String?,
      caller: map["caller"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "level": level,
      "message": message,
      "time": time,
      "caller": caller,
    };
  }

  factory LogEntryModel.fromEntity(LogEntryEntity entity) {
    return LogEntryModel(
      level: entity.level,
      message: entity.message,
      time: entity.time,
      caller: entity.caller,
    );
  }

  LogEntryModel copyWith({
    String? level,
    String? message,
    String? time,
    String? caller,
  }) {
    return LogEntryModel(
      level: level ?? this.level,
      message: message ?? this.message,
      time: time ?? this.time,
      caller: caller ?? this.caller,
    );
  }

  LogEntryEntity toEntity() => LogEntryEntity(
        level: level,
        message: message,
        time: time,
        caller: caller,
      );
}
