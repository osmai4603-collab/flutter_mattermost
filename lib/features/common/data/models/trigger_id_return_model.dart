import 'package:flutter_mattermost/features/common/domain/entities/trigger_id_return_entity.dart';

final class TriggerIdReturnModel extends TriggerIdReturnEntity {
  const TriggerIdReturnModel({
    required super.trigger_id,
  });

  factory TriggerIdReturnModel.fromMap(Map<String, dynamic> map) {
    return TriggerIdReturnModel(
      trigger_id: map["trigger_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "trigger_id": trigger_id,
    };
  }

  factory TriggerIdReturnModel.fromEntity(TriggerIdReturnEntity entity) {
    return TriggerIdReturnModel(
      trigger_id: entity.trigger_id,
    );
  }

  @override
  TriggerIdReturnModel copyWith({
    String? trigger_id,
  }) {
    return TriggerIdReturnModel(
      trigger_id: trigger_id ?? this.trigger_id,
    );
  }

  TriggerIdReturnEntity toEntity() => TriggerIdReturnEntity(
        trigger_id: trigger_id,
      );
}
