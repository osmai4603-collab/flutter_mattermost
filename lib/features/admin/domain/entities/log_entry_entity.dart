import 'package:equatable/equatable.dart';

class LogEntryEntity extends Equatable {
  final String? level;
  final String? message;
  final String? time;
  final String? caller;
  const LogEntryEntity({
    this.level,
    this.message,
    this.time,
    this.caller,
  });

  @override
  List<Object?> get props => [
      level,
      message,
      time,
      caller,
  ];
}
