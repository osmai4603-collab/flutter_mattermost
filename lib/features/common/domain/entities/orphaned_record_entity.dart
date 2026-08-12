import 'package:equatable/equatable.dart';

class OrphanedRecordEntity extends Equatable {
  final String? parent_id;
  final String? child_id;

  const OrphanedRecordEntity({
    this.parent_id,
    this.child_id,
  });

  @override
  List<Object?> get props => [
        parent_id,
        child_id,
      ];

  OrphanedRecordEntity copyWith({
    String? parent_id,
    String? child_id,
  }) {
    return OrphanedRecordEntity(
      parent_id: parent_id ?? this.parent_id,
      child_id: child_id ?? this.child_id,
    );
  }
}
