import 'package:equatable/equatable.dart';

class PropertyValueEntity extends Equatable {
  final String? id;
  final String? field_id;
  final String? value;
  final int? create_at;
  final int? update_at;
  final int? delete_at;

  const PropertyValueEntity({
    this.id,
    this.field_id,
    this.value,
    this.create_at,
    this.update_at,
    this.delete_at,
  });

  @override
  List<Object?> get props => [
        id,
        field_id,
        value,
        create_at,
        update_at,
        delete_at,
      ];

  PropertyValueEntity copyWith({
    String? id,
    String? field_id,
    String? value,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return PropertyValueEntity(
      id: id ?? this.id,
      field_id: field_id ?? this.field_id,
      value: value ?? this.value,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }
}
