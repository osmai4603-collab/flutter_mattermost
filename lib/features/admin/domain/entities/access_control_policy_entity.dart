import 'package:equatable/equatable.dart';

class AccessControlPolicyEntity extends Equatable {
  final String? id;
  final String? name;
  final String? display_name;
  final String? description;
  final String? expression;
  final bool? is_active;
  final int? create_at;
  final int? update_at;
  final int? delete_at;

  const AccessControlPolicyEntity({
    this.id,
    this.name,
    this.display_name,
    this.description,
    this.expression,
    this.is_active,
    this.create_at,
    this.update_at,
    this.delete_at,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        display_name,
        description,
        expression,
        is_active,
        create_at,
        update_at,
        delete_at,
      ];

  AccessControlPolicyEntity copyWith({
    String? id,
    String? name,
    String? display_name,
    String? description,
    String? expression,
    bool? is_active,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return AccessControlPolicyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      description: description ?? this.description,
      expression: expression ?? this.expression,
      is_active: is_active ?? this.is_active,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }
}
