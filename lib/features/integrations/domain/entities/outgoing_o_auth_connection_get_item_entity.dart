import 'package:equatable/equatable.dart';

class OutgoingOAuthConnectionGetItemEntity extends Equatable {
  final String? id;
  final String? name;
  final int? create_at;
  final int? update_at;
  final String? grant_type;
  final String? audiences;

  const OutgoingOAuthConnectionGetItemEntity({
    this.id,
    this.name,
    this.create_at,
    this.update_at,
    this.grant_type,
    this.audiences,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        create_at,
        update_at,
        grant_type,
        audiences,
      ];

  OutgoingOAuthConnectionGetItemEntity copyWith({
    String? id,
    String? name,
    int? create_at,
    int? update_at,
    String? grant_type,
    String? audiences,
  }) {
    return OutgoingOAuthConnectionGetItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      grant_type: grant_type ?? this.grant_type,
      audiences: audiences ?? this.audiences,
    );
  }
}
