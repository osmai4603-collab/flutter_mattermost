import 'package:flutter_mattermost/features/teams/domain/entities/team_reviewer_config_entity.dart';

final class TeamReviewerConfigModel extends TeamReviewerConfigEntity {
  const TeamReviewerConfigModel({
    required super.Enabled,
    required super.ReviewerIds,
  });

  factory TeamReviewerConfigModel.fromMap(Map<String, dynamic> map) {
    return TeamReviewerConfigModel(
      Enabled: map["Enabled"] as bool?,
      ReviewerIds: List<String>.from(map["ReviewerIds"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Enabled": Enabled,
      "ReviewerIds": ReviewerIds,
    };
  }

  factory TeamReviewerConfigModel.fromEntity(TeamReviewerConfigEntity entity) {
    return TeamReviewerConfigModel(
      Enabled: entity.Enabled,
      ReviewerIds: entity.ReviewerIds,
    );
  }

  @override
  TeamReviewerConfigModel copyWith({
    bool? Enabled,
    List<String>? ReviewerIds,
  }) {
    return TeamReviewerConfigModel(
      Enabled: Enabled ?? this.Enabled,
      ReviewerIds: ReviewerIds ?? this.ReviewerIds,
    );
  }

  TeamReviewerConfigEntity toEntity() => TeamReviewerConfigEntity(
        Enabled: Enabled,
        ReviewerIds: ReviewerIds,
      );
}
