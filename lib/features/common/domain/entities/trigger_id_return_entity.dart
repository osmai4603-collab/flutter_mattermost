import 'package:equatable/equatable.dart';

class TriggerIdReturnEntity extends Equatable {
  final String? trigger_id;

  const TriggerIdReturnEntity({
    required this.trigger_id,
  });

  @override
  List<Object?> get props => [
        trigger_id,
      ];

  TriggerIdReturnEntity copyWith({
    String? trigger_id,
  }) {
    return TriggerIdReturnEntity(
      trigger_id: trigger_id ?? this.trigger_id,
    );
  }
}
