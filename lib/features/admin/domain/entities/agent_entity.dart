import 'package:equatable/equatable.dart';

class AgentEntity extends Equatable {
  final String? agent_id;
  final String? display_name;
  final String? name;
  final String? type;
  final String? description;
  final String? icon;
  final String? model;
  final String? provider_name;
  final bool? isDefault;
  const AgentEntity({
    this.agent_id,
    this.display_name,
    this.name,
    this.type,
    this.description,
    this.icon,
    this.model,
    this.provider_name,
    this.isDefault,
  });

  @override
  List<Object?> get props => [
      agent_id,
      display_name,
      name,
      type,
      description,
      icon,
      model,
      provider_name,
      isDefault,
  ];
}
