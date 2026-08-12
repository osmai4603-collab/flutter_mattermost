import 'package:equatable/equatable.dart';

class PropertyFieldEntity extends Equatable {
  final String? id;
  final String? type;
  final String? name;
  final String? description;
  final int? create_at;
  final int? update_at;
  final int? delete_at;
  final Map<String, dynamic>? attrs;

  const PropertyFieldEntity({
    this.id,
    this.type,
    this.name,
    this.description,
    this.create_at,
    this.update_at,
    this.delete_at,
    this.attrs,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        description,
        create_at,
        update_at,
        delete_at,
        attrs,
      ];

  PropertyFieldEntity copyWith({
    String? id,
    String? type,
    String? name,
    String? description,
    int? create_at,
    int? update_at,
    int? delete_at,
    Map<String, dynamic>? attrs,
  }) {
    return PropertyFieldEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      attrs: attrs ?? this.attrs,
    );
  }
}
