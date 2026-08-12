import 'package:equatable/equatable.dart';

class ChecklistEntity extends Equatable {
  final String? id;
  final String? title;
  final List<Map<String, dynamic>>? items;

  const ChecklistEntity({
    this.id,
    this.title,
    this.items,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        items,
      ];

  ChecklistEntity copyWith({
    String? id,
    String? title,
    List<Map<String, dynamic>>? items,
  }) {
    return ChecklistEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }
}
