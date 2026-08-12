import 'package:equatable/equatable.dart';

class TimezoneEntity extends Equatable {
  final String? useAutomaticTimezone;
  final String? manualTimezone;
  final String? automaticTimezone;

  const TimezoneEntity({
    this.useAutomaticTimezone,
    this.manualTimezone,
    this.automaticTimezone,
  });

  @override
  List<Object?> get props => [
        useAutomaticTimezone,
        manualTimezone,
        automaticTimezone,
      ];

  TimezoneEntity copyWith({
    String? useAutomaticTimezone,
    String? manualTimezone,
    String? automaticTimezone,
  }) {
    return TimezoneEntity(
      useAutomaticTimezone: useAutomaticTimezone ?? this.useAutomaticTimezone,
      manualTimezone: manualTimezone ?? this.manualTimezone,
      automaticTimezone: automaticTimezone ?? this.automaticTimezone,
    );
  }
}
