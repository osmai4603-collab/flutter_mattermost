import 'package:equatable/equatable.dart';

class ReviewerSettingsEntity extends Equatable {
  final bool? CommonReviewers;
  final bool? SystemAdminsAsReviewers;
  final bool? TeamAdminsAsReviewers;
  final List<String>? CommonReviewerIds;
  final Map<String, dynamic>? TeamReviewersSetting;

  const ReviewerSettingsEntity({
    required this.CommonReviewers,
    required this.SystemAdminsAsReviewers,
    required this.TeamAdminsAsReviewers,
    required this.CommonReviewerIds,
    required this.TeamReviewersSetting,
  });

  @override
  List<Object?> get props => [
        CommonReviewers,
        SystemAdminsAsReviewers,
        TeamAdminsAsReviewers,
        CommonReviewerIds,
        TeamReviewersSetting,
      ];

  ReviewerSettingsEntity copyWith({
    bool? CommonReviewers,
    bool? SystemAdminsAsReviewers,
    bool? TeamAdminsAsReviewers,
    List<String>? CommonReviewerIds,
    Map<String, dynamic>? TeamReviewersSetting,
  }) {
    return ReviewerSettingsEntity(
      CommonReviewers: CommonReviewers ?? this.CommonReviewers,
      SystemAdminsAsReviewers: SystemAdminsAsReviewers ?? this.SystemAdminsAsReviewers,
      TeamAdminsAsReviewers: TeamAdminsAsReviewers ?? this.TeamAdminsAsReviewers,
      CommonReviewerIds: CommonReviewerIds ?? this.CommonReviewerIds,
      TeamReviewersSetting: TeamReviewersSetting ?? this.TeamReviewersSetting,
    );
  }
}
