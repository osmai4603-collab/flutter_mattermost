import 'package:flutter_mattermost/features/auth/domain/entities/notify_admin_to_upgrade_request_entity.dart';

final class NotifyAdminToUpgradeRequestModel extends NotifyAdminToUpgradeRequestEntity {
  const NotifyAdminToUpgradeRequestModel({
    required super.trial_notification,
    required super.required_plan,
    required super.required_feature,
  });

  factory NotifyAdminToUpgradeRequestModel.fromMap(Map<String, dynamic> map) {
    return NotifyAdminToUpgradeRequestModel(
      trial_notification: map["trial_notification"] as bool?,
      required_plan: map["required_plan"] as String?,
      required_feature: map["required_feature"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "trial_notification": trial_notification,
      "required_plan": required_plan,
      "required_feature": required_feature,
    };
  }

  factory NotifyAdminToUpgradeRequestModel.fromEntity(NotifyAdminToUpgradeRequestEntity entity) {
    return NotifyAdminToUpgradeRequestModel(
      trial_notification: entity.trial_notification,
      required_plan: entity.required_plan,
      required_feature: entity.required_feature,
    );
  }

  @override
  NotifyAdminToUpgradeRequestModel copyWith({
    bool? trial_notification,
    String? required_plan,
    String? required_feature,
  }) {
    return NotifyAdminToUpgradeRequestModel(
      trial_notification: trial_notification ?? this.trial_notification,
      required_plan: required_plan ?? this.required_plan,
      required_feature: required_feature ?? this.required_feature,
    );
  }

  NotifyAdminToUpgradeRequestEntity toEntity() => NotifyAdminToUpgradeRequestEntity(
        trial_notification: trial_notification,
        required_plan: required_plan,
        required_feature: required_feature,
      );
}
