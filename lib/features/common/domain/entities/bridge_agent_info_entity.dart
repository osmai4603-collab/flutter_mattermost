import 'package:equatable/equatable.dart';

class BridgeAgentInfoEntity extends Equatable {
  final String? id;
  final String? displayName;
  final String? username;
  final String? service_id;
  final String? service_type;

  const BridgeAgentInfoEntity({
    this.id,
    this.displayName,
    this.username,
    this.service_id,
    this.service_type,
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        username,
        service_id,
        service_type,
      ];

  BridgeAgentInfoEntity copyWith({
    String? id,
    String? displayName,
    String? username,
    String? service_id,
    String? service_type,
  }) {
    return BridgeAgentInfoEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      service_id: service_id ?? this.service_id,
      service_type: service_type ?? this.service_type,
    );
  }
}
