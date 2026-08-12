import 'package:flutter_mattermost/features/channels/domain/entities/reviewer_settings_entity.dart';

final class ReviewerSettingsModel extends ReviewerSettingsEntity {
  const ReviewerSettingsModel({
    required super.CommonReviewers,
    required super.SystemAdminsAsReviewers,
    required super.TeamAdminsAsReviewers,
    required super.CommonReviewerIds,
    required super.TeamReviewersSetting,
  });

  factory ReviewerSettingsModel.fromMap(Map<String, dynamic> map) {
    return ReviewerSettingsModel(
      CommonReviewers: map["CommonReviewers"] as bool?,
      SystemAdminsAsReviewers: map["SystemAdminsAsReviewers"] as bool?,
      TeamAdminsAsReviewers: map["TeamAdminsAsReviewers"] as bool?,
      CommonReviewerIds: List<String>.from(map["CommonReviewerIds"] as List<dynamic>? ?? []),
      TeamReviewersSetting: map["TeamReviewersSetting"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "CommonReviewers": CommonReviewers,
      "SystemAdminsAsReviewers": SystemAdminsAsReviewers,
      "TeamAdminsAsReviewers": TeamAdminsAsReviewers,
      "CommonReviewerIds": CommonReviewerIds,
      "TeamReviewersSetting": TeamReviewersSetting,
    };
  }

  factory ReviewerSettingsModel.fromEntity(ReviewerSettingsEntity entity) {
    return ReviewerSettingsModel(
      CommonReviewers: entity.CommonReviewers,
      SystemAdminsAsReviewers: entity.SystemAdminsAsReviewers,
      TeamAdminsAsReviewers: entity.TeamAdminsAsReviewers,
      CommonReviewerIds: entity.CommonReviewerIds,
      TeamReviewersSetting: entity.TeamReviewersSetting,
    );
  }

  @override
  ReviewerSettingsModel copyWith({
    bool? CommonReviewers,
    bool? SystemAdminsAsReviewers,
    bool? TeamAdminsAsReviewers,
    List<String>? CommonReviewerIds,
    Map<String, dynamic>? TeamReviewersSetting,
  }) {
    return ReviewerSettingsModel(
      CommonReviewers: CommonReviewers ?? this.CommonReviewers,
      SystemAdminsAsReviewers: SystemAdminsAsReviewers ?? this.SystemAdminsAsReviewers,
      TeamAdminsAsReviewers: TeamAdminsAsReviewers ?? this.TeamAdminsAsReviewers,
      CommonReviewerIds: CommonReviewerIds ?? this.CommonReviewerIds,
      TeamReviewersSetting: TeamReviewersSetting ?? this.TeamReviewersSetting,
    );
  }

  ReviewerSettingsEntity toEntity() => ReviewerSettingsEntity(
        CommonReviewers: CommonReviewers,
        SystemAdminsAsReviewers: SystemAdminsAsReviewers,
        TeamAdminsAsReviewers: TeamAdminsAsReviewers,
        CommonReviewerIds: CommonReviewerIds,
        TeamReviewersSetting: TeamReviewersSetting,
      );
}
