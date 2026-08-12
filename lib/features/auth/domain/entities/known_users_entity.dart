import 'package:equatable/equatable.dart';

class KnownUsersEntity extends Equatable {
  final String? items;

  const KnownUsersEntity({
    this.items,
  });

  @override
  List<Object?> get props => [
        items,
      ];

  KnownUsersEntity copyWith({
    String? items,
  }) {
    return KnownUsersEntity(
      items: items ?? this.items,
    );
  }
}
