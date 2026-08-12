import 'package:flutter_mattermost/features/integrations/domain/entities/dialog_lookup_option_entity.dart';

final class DialogLookupOptionModel extends DialogLookupOptionEntity {
  const DialogLookupOptionModel({
    required super.text,
    required super.value,
  });

  factory DialogLookupOptionModel.fromMap(Map<String, dynamic> map) {
    return DialogLookupOptionModel(
      text: map["text"] as String?,
      value: map["value"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "value": value,
    };
  }

  factory DialogLookupOptionModel.fromEntity(DialogLookupOptionEntity entity) {
    return DialogLookupOptionModel(
      text: entity.text,
      value: entity.value,
    );
  }

  DialogLookupOptionModel copyWith({
    String? text,
    String? value,
  }) {
    return DialogLookupOptionModel(
      text: text ?? this.text,
      value: value ?? this.value,
    );
  }

  DialogLookupOptionEntity toEntity() => DialogLookupOptionEntity(
        text: text,
        value: value,
      );
}
