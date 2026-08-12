import 'package:equatable/equatable.dart';

class AccessControlFieldsAutocompleteResponseEntity extends Equatable {
  final List<Map<String, dynamic>>? fields;

  const AccessControlFieldsAutocompleteResponseEntity({
    this.fields,
  });

  @override
  List<Object?> get props => [
        fields,
      ];

  AccessControlFieldsAutocompleteResponseEntity copyWith({
    List<Map<String, dynamic>>? fields,
  }) {
    return AccessControlFieldsAutocompleteResponseEntity(
      fields: fields ?? this.fields,
    );
  }
}
