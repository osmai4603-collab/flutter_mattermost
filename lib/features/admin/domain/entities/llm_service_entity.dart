import 'package:equatable/equatable.dart';

class LlmServiceEntity extends Equatable {
  final String? display_name;
  final String? name;
  final bool? isDefault;
  final String? description;
  const LlmServiceEntity({
    this.display_name,
    this.name,
    this.isDefault,
    this.description,
  });

  @override
  List<Object?> get props => [
      display_name,
      name,
      isDefault,
      description,
  ];
}
