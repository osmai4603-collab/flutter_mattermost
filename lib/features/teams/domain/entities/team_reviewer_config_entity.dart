import 'package:equatable/equatable.dart';

class TeamReviewerConfigEntity extends Equatable {
  final bool? Enabled;
  final List<String>? ReviewerIds;

  const TeamReviewerConfigEntity({
    required this.Enabled,
    required this.ReviewerIds,
  });

  @override
  List<Object?> get props => [
        Enabled,
        ReviewerIds,
      ];

  TeamReviewerConfigEntity copyWith({
    bool? Enabled,
    List<String>? ReviewerIds,
  }) {
    return TeamReviewerConfigEntity(
      Enabled: Enabled ?? this.Enabled,
      ReviewerIds: ReviewerIds ?? this.ReviewerIds,
    );
  }
}
