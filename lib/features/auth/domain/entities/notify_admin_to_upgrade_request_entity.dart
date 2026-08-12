import 'package:equatable/equatable.dart';

class NotifyAdminToUpgradeRequestEntity extends Equatable {
  final bool? trial_notification;
  final String? required_plan;
  final String? required_feature;

  const NotifyAdminToUpgradeRequestEntity({
    this.trial_notification,
    this.required_plan,
    this.required_feature,
  });

  @override
  List<Object?> get props => [
        trial_notification,
        required_plan,
        required_feature,
      ];

  NotifyAdminToUpgradeRequestEntity copyWith({
    bool? trial_notification,
    String? required_plan,
    String? required_feature,
  }) {
    return NotifyAdminToUpgradeRequestEntity(
      trial_notification: trial_notification ?? this.trial_notification,
      required_plan: required_plan ?? this.required_plan,
      required_feature: required_feature ?? this.required_feature,
    );
  }
}
