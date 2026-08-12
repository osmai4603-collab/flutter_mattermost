import 'package:equatable/equatable.dart';

class CustomAttributeFieldEntity extends Equatable {
  final String? id;
  final String? name;
  final String? type;
  final String? group_id;
  final Map<String,dynamic>? attrs;
  final int? create_at;
  final int? update_at;
  final int? delete_at;
  const CustomAttributeFieldEntity({
    this.id,
    this.name,
    this.type,
    this.group_id,
    this.attrs,
    this.create_at,
    this.update_at,
    this.delete_at,
  });

  @override
  List<Object?> get props => [
      id,
      name,
      type,
      group_id,
      attrs,
      create_at,
      update_at,
      delete_at,
  ];
}
