import 'package:equatable/equatable.dart';

class BridgeServiceInfoEntity extends Equatable {
  final String? id;
  final String? name;
  final String? type;

  const BridgeServiceInfoEntity({
    this.id,
    this.name,
    this.type,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
      ];

  BridgeServiceInfoEntity copyWith({
    String? id,
    String? name,
    String? type,
  }) {
    return BridgeServiceInfoEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
