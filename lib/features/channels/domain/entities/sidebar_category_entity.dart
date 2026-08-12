import 'package:equatable/equatable.dart';

class SidebarCategoryEntity extends Equatable {
  final String? id;
  final String? user_id;
  final String? team_id;
  final String? display_name;
  final String? type;

  const SidebarCategoryEntity({
    this.id,
    this.user_id,
    this.team_id,
    this.display_name,
    this.type,
  });

  @override
  List<Object?> get props => [
        id,
        user_id,
        team_id,
        display_name,
        type,
      ];

  SidebarCategoryEntity copyWith({
    String? id,
    String? user_id,
    String? team_id,
    String? display_name,
    String? type,
  }) {
    return SidebarCategoryEntity(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      team_id: team_id ?? this.team_id,
      display_name: display_name ?? this.display_name,
      type: type ?? this.type,
    );
  }
}
