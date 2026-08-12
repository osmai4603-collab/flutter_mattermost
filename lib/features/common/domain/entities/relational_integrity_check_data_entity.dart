import 'package:equatable/equatable.dart';

class RelationalIntegrityCheckDataEntity extends Equatable {
  final String? parent_name;
  final String? child_name;
  final String? parent_id_attr;
  final String? child_id_attr;
  final List<Map<String, dynamic>>? records;

  const RelationalIntegrityCheckDataEntity({
    this.parent_name,
    this.child_name,
    this.parent_id_attr,
    this.child_id_attr,
    this.records,
  });

  @override
  List<Object?> get props => [
        parent_name,
        child_name,
        parent_id_attr,
        child_id_attr,
        records,
      ];

  RelationalIntegrityCheckDataEntity copyWith({
    String? parent_name,
    String? child_name,
    String? parent_id_attr,
    String? child_id_attr,
    List<Map<String, dynamic>>? records,
  }) {
    return RelationalIntegrityCheckDataEntity(
      parent_name: parent_name ?? this.parent_name,
      child_name: child_name ?? this.child_name,
      parent_id_attr: parent_id_attr ?? this.parent_id_attr,
      child_id_attr: child_id_attr ?? this.child_id_attr,
      records: records ?? this.records,
    );
  }
}
