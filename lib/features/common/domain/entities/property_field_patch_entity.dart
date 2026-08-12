import 'package:equatable/equatable.dart';

class PropertyFieldPatchEntity extends Equatable {
  final String? name;
  final String? type;
  final Map<String, dynamic>? attrs;
  final String? linked_field_id;

  const PropertyFieldPatchEntity({
    this.name,
    this.type,
    this.attrs,
    this.linked_field_id,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        attrs,
        linked_field_id,
      ];

  PropertyFieldPatchEntity copyWith({
    String? name,
    String? type,
    Map<String, dynamic>? attrs,
    String? linked_field_id,
  }) {
    return PropertyFieldPatchEntity(
      name: name ?? this.name,
      type: type ?? this.type,
      attrs: attrs ?? this.attrs,
      linked_field_id: linked_field_id ?? this.linked_field_id,
    );
  }
}
