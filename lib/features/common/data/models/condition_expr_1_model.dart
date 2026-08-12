import 'package:flutter_mattermost/features/common/domain/entities/condition_expr_1_entity.dart';

final class ConditionExpr1Model extends ConditionExpr1Entity {
  const ConditionExpr1Model({
    required super.and,
    required super.or,
    required super.is_,
    required super.isNot,
  });

  factory ConditionExpr1Model.fromMap(Map<String, dynamic> map) {
    return ConditionExpr1Model(
      and: (map["and"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      or: (map["or"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      is_: map["is"] as Map<String, dynamic>?,
      isNot: map["isNot"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "and": and,
      "or": or,
      "is": is_,
      "isNot": isNot,
    };
  }

  factory ConditionExpr1Model.fromEntity(ConditionExpr1Entity entity) {
    return ConditionExpr1Model(
      and: entity.and,
      or: entity.or,
      is_: entity.is_,
      isNot: entity.isNot,
    );
  }

  @override
  ConditionExpr1Model copyWith({
    List<Map<String, dynamic>>? and,
    List<Map<String, dynamic>>? or,
    Map<String, dynamic>? is_,
    Map<String, dynamic>? isNot,
  }) {
    return ConditionExpr1Model(
      and: and ?? this.and,
      or: or ?? this.or,
      is_: is_ ?? this.is_,
      isNot: isNot ?? this.isNot,
    );
  }

  ConditionExpr1Entity toEntity() => ConditionExpr1Entity(
        and: and,
        or: or,
        is_: is_,
        isNot: isNot,
      );
}
