import 'package:equatable/equatable.dart';

class ConditionEntity extends Equatable {
  final String? id;
  final Map<String, dynamic>? condition_expr;
  final int? version;
  final String? playbook_id;
  final String? run_id;
  final int? create_at;
  final int? update_at;

  const ConditionEntity({
    this.id,
    required this.condition_expr,
    required this.version,
    this.playbook_id,
    this.run_id,
    this.create_at,
    this.update_at,
  });

  @override
  List<Object?> get props => [
        id,
        condition_expr,
        version,
        playbook_id,
        run_id,
        create_at,
        update_at,
      ];

  ConditionEntity copyWith({
    String? id,
    Map<String, dynamic>? condition_expr,
    int? version,
    String? playbook_id,
    String? run_id,
    int? create_at,
    int? update_at,
  }) {
    return ConditionEntity(
      id: id ?? this.id,
      condition_expr: condition_expr ?? this.condition_expr,
      version: version ?? this.version,
      playbook_id: playbook_id ?? this.playbook_id,
      run_id: run_id ?? this.run_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
    );
  }
}
