import 'package:equatable/equatable.dart';

class ConditionExpr1Entity extends Equatable {
  final List<Map<String, dynamic>>? and;
  final List<Map<String, dynamic>>? or;
  final Map<String, dynamic>? is_;
  final Map<String, dynamic>? isNot;

  const ConditionExpr1Entity({
    this.and,
    this.or,
    this.is_,
    this.isNot,
  });

  @override
  List<Object?> get props => [
        and,
        or,
        is_,
        isNot,
      ];

  ConditionExpr1Entity copyWith({
    List<Map<String, dynamic>>? and,
    List<Map<String, dynamic>>? or,
    Map<String, dynamic>? is_,
    Map<String, dynamic>? isNot,
  }) {
    return ConditionExpr1Entity(
      and: and ?? this.and,
      or: or ?? this.or,
      is_: is_ ?? this.is_,
      isNot: isNot ?? this.isNot,
    );
  }
}
