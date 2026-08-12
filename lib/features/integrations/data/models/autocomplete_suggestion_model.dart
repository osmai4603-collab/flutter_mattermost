import 'package:flutter_mattermost/features/integrations/domain/entities/autocomplete_suggestion_entity.dart';

final class AutocompleteSuggestionModel extends AutocompleteSuggestionEntity {
  const AutocompleteSuggestionModel({
    required super.Complete,
    required super.Suggestion,
    required super.Hint,
    required super.Description,
    required super.IconData,
  });

  factory AutocompleteSuggestionModel.fromMap(Map<String, dynamic> map) {
    return AutocompleteSuggestionModel(
      Complete: map["Complete"] as String?,
      Suggestion: map["Suggestion"] as String?,
      Hint: map["Hint"] as String?,
      Description: map["Description"] as String?,
      IconData: map["IconData"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Complete": Complete,
      "Suggestion": Suggestion,
      "Hint": Hint,
      "Description": Description,
      "IconData": IconData,
    };
  }

  factory AutocompleteSuggestionModel.fromEntity(AutocompleteSuggestionEntity entity) {
    return AutocompleteSuggestionModel(
      Complete: entity.Complete,
      Suggestion: entity.Suggestion,
      Hint: entity.Hint,
      Description: entity.Description,
      IconData: entity.IconData,
    );
  }

  @override
  AutocompleteSuggestionModel copyWith({
    String? Complete,
    String? Suggestion,
    String? Hint,
    String? Description,
    String? IconData,
  }) {
    return AutocompleteSuggestionModel(
      Complete: Complete ?? this.Complete,
      Suggestion: Suggestion ?? this.Suggestion,
      Hint: Hint ?? this.Hint,
      Description: Description ?? this.Description,
      IconData: IconData ?? this.IconData,
    );
  }

  AutocompleteSuggestionEntity toEntity() => AutocompleteSuggestionEntity(
        Complete: Complete,
        Suggestion: Suggestion,
        Hint: Hint,
        Description: Description,
        IconData: IconData,
      );
}
