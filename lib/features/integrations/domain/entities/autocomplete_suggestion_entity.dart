import 'package:equatable/equatable.dart';

class AutocompleteSuggestionEntity extends Equatable {
  final String? Complete;
  final String? Suggestion;
  final String? Hint;
  final String? Description;
  final String? IconData;

  const AutocompleteSuggestionEntity({
    this.Complete,
    this.Suggestion,
    this.Hint,
    this.Description,
    this.IconData,
  });

  @override
  List<Object?> get props => [
        Complete,
        Suggestion,
        Hint,
        Description,
        IconData,
      ];

  AutocompleteSuggestionEntity copyWith({
    String? Complete,
    String? Suggestion,
    String? Hint,
    String? Description,
    String? IconData,
  }) {
    return AutocompleteSuggestionEntity(
      Complete: Complete ?? this.Complete,
      Suggestion: Suggestion ?? this.Suggestion,
      Hint: Hint ?? this.Hint,
      Description: Description ?? this.Description,
      IconData: IconData ?? this.IconData,
    );
  }
}
