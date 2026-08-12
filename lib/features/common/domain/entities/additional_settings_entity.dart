import 'package:equatable/equatable.dart';

class AdditionalSettingsEntity extends Equatable {
  final List<String>? Reasons;
  final bool? ReporterCommentRequired;
  final bool? ReviewerCommentRequired;
  final bool? HideFlaggedContent;

  const AdditionalSettingsEntity({
    required this.Reasons,
    required this.ReporterCommentRequired,
    required this.ReviewerCommentRequired,
    required this.HideFlaggedContent,
  });

  @override
  List<Object?> get props => [
        Reasons,
        ReporterCommentRequired,
        ReviewerCommentRequired,
        HideFlaggedContent,
      ];

  AdditionalSettingsEntity copyWith({
    List<String>? Reasons,
    bool? ReporterCommentRequired,
    bool? ReviewerCommentRequired,
    bool? HideFlaggedContent,
  }) {
    return AdditionalSettingsEntity(
      Reasons: Reasons ?? this.Reasons,
      ReporterCommentRequired: ReporterCommentRequired ?? this.ReporterCommentRequired,
      ReviewerCommentRequired: ReviewerCommentRequired ?? this.ReviewerCommentRequired,
      HideFlaggedContent: HideFlaggedContent ?? this.HideFlaggedContent,
    );
  }
}
