import 'package:flutter_mattermost/features/admin/domain/entities/access_control_fields_autocomplete_response_entity.dart';

final class AccessControlFieldsAutocompleteResponseModel extends AccessControlFieldsAutocompleteResponseEntity {
  const AccessControlFieldsAutocompleteResponseModel({
    required super.fields,
  });

  factory AccessControlFieldsAutocompleteResponseModel.fromMap(Map<String, dynamic> map) {
    return AccessControlFieldsAutocompleteResponseModel(
      fields: (map["fields"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fields": fields,
    };
  }

  factory AccessControlFieldsAutocompleteResponseModel.fromEntity(AccessControlFieldsAutocompleteResponseEntity entity) {
    return AccessControlFieldsAutocompleteResponseModel(
      fields: entity.fields,
    );
  }

  AccessControlFieldsAutocompleteResponseModel copyWith({
    List<Map<String, dynamic>>? fields,
  }) {
    return AccessControlFieldsAutocompleteResponseModel(
      fields: fields ?? this.fields,
    );
  }

  AccessControlFieldsAutocompleteResponseEntity toEntity() => AccessControlFieldsAutocompleteResponseEntity(
        fields: fields,
      );
}
