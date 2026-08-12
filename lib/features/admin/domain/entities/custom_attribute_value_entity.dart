import 'package:equatable/equatable.dart';

class CustomAttributeValueEntity extends Equatable {
  final String? id;
  final String? post_id;
  final String? attr_id;
  final String? value;
  final int? create_at;
  final int? update_at;
  const CustomAttributeValueEntity({
    this.id,
    this.post_id,
    this.attr_id,
    this.value,
    this.create_at,
    this.update_at,
  });

  @override
  List<Object?> get props => [
      id,
      post_id,
      attr_id,
      value,
      create_at,
      update_at,
  ];
}
