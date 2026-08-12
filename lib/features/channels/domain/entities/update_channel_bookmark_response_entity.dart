import 'package:flutter_mattermost/core/entities/entity.dart';

class UpdateChannelBookmarkResponseEntity extends Entity {
  final Map<String, dynamic> updated;
  final Map<String, dynamic> deleted;

  const UpdateChannelBookmarkResponseEntity({
    this.updated = const {},
    this.deleted = const {},
  });

  @override
  List<Object?> get props => [updated, deleted];

  @override
  UpdateChannelBookmarkResponseEntity copyWith({
    Map<String, dynamic>? updated,
    Map<String, dynamic>? deleted,
  }) {
    return UpdateChannelBookmarkResponseEntity(
      updated: updated ?? this.updated,
      deleted: deleted ?? this.deleted,
    );
  }
}
