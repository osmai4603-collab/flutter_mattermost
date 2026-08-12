import 'package:equatable/equatable.dart';

class ClusterInfoEntity extends Equatable {
  final Map<String, dynamic>? items;

  const ClusterInfoEntity({
    this.items,
  });

  @override
  List<Object?> get props => [
        items,
      ];

  ClusterInfoEntity copyWith({
    Map<String, dynamic>? items,
  }) {
    return ClusterInfoEntity(
      items: items ?? this.items,
    );
  }
}
