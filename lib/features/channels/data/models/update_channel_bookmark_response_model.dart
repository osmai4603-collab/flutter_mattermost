import 'package:flutter_mattermost/features/channels/domain/entities/update_channel_bookmark_response_entity.dart';

final class UpdateChannelBookmarkResponseModel extends UpdateChannelBookmarkResponseEntity {
  const UpdateChannelBookmarkResponseModel({
    super.updated,
    super.deleted,
  });

  factory UpdateChannelBookmarkResponseModel.fromMap(Map<String, dynamic> data) {
    return UpdateChannelBookmarkResponseModel(
      updated: Map<String, dynamic>.from(data['updated'] ?? const {}),
      deleted: Map<String, dynamic>.from(data['deleted'] ?? const {}),
    );
  }

  factory UpdateChannelBookmarkResponseModel.fromEntity(
    UpdateChannelBookmarkResponseEntity entity,
  ) {
    return UpdateChannelBookmarkResponseModel(
      updated: entity.updated,
      deleted: entity.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'updated': updated,
      'deleted': deleted,
    };
  }

  @override
  UpdateChannelBookmarkResponseModel copyWith({
    Map<String, dynamic>? updated,
    Map<String, dynamic>? deleted,
  }) {
    return UpdateChannelBookmarkResponseModel(
      updated: updated ?? this.updated,
      deleted: deleted ?? this.deleted,
    );
  }

  UpdateChannelBookmarkResponseEntity toEntity() {
    return UpdateChannelBookmarkResponseEntity(
      updated: updated,
      deleted: deleted,
    );
  }
}
