import 'package:flutter_mattermost/features/common/domain/entities/additional_settings_entity.dart';

final class AdditionalSettingsModel extends AdditionalSettingsEntity {
  const AdditionalSettingsModel({
    required super.Reasons,
    required super.ReporterCommentRequired,
    required super.ReviewerCommentRequired,
    required super.HideFlaggedContent,
  });

  factory AdditionalSettingsModel.fromMap(Map<String, dynamic> map) {
    return AdditionalSettingsModel(
      Reasons: List<String>.from(map["Reasons"] as List<dynamic>? ?? []),
      ReporterCommentRequired: map["ReporterCommentRequired"] as bool?,
      ReviewerCommentRequired: map["ReviewerCommentRequired"] as bool?,
      HideFlaggedContent: map["HideFlaggedContent"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Reasons": Reasons,
      "ReporterCommentRequired": ReporterCommentRequired,
      "ReviewerCommentRequired": ReviewerCommentRequired,
      "HideFlaggedContent": HideFlaggedContent,
    };
  }

  factory AdditionalSettingsModel.fromEntity(AdditionalSettingsEntity entity) {
    return AdditionalSettingsModel(
      Reasons: entity.Reasons,
      ReporterCommentRequired: entity.ReporterCommentRequired,
      ReviewerCommentRequired: entity.ReviewerCommentRequired,
      HideFlaggedContent: entity.HideFlaggedContent,
    );
  }

  @override
  AdditionalSettingsModel copyWith({
    List<String>? Reasons,
    bool? ReporterCommentRequired,
    bool? ReviewerCommentRequired,
    bool? HideFlaggedContent,
  }) {
    return AdditionalSettingsModel(
      Reasons: Reasons ?? this.Reasons,
      ReporterCommentRequired: ReporterCommentRequired ?? this.ReporterCommentRequired,
      ReviewerCommentRequired: ReviewerCommentRequired ?? this.ReviewerCommentRequired,
      HideFlaggedContent: HideFlaggedContent ?? this.HideFlaggedContent,
    );
  }

  AdditionalSettingsEntity toEntity() => AdditionalSettingsEntity(
        Reasons: Reasons,
        ReporterCommentRequired: ReporterCommentRequired,
        ReviewerCommentRequired: ReviewerCommentRequired,
        HideFlaggedContent: HideFlaggedContent,
      );
}
