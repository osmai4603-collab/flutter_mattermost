import 'package:flutter_mattermost/features/channels/domain/entities/channel_search_entity.dart';

final class ChannelSearchModel extends ChannelSearchEntity {
  const ChannelSearchModel({
    required super.term,
    required super.team_ids,
    required super.public,
    required super.private,
    required super.deleted,
    required super.include_deleted,
  });

  factory ChannelSearchModel.fromMap(Map<String, dynamic> map) {
    return ChannelSearchModel(
      term: map["term"] as String?,
      team_ids: List<String>.from(map["team_ids"] as List<dynamic>? ?? []),
      public: map["public"] as bool?,
      private: map["private"] as bool?,
      deleted: map["deleted"] as bool?,
      include_deleted: map["include_deleted"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "term": term,
      "team_ids": team_ids,
      "public": public,
      "private": private,
      "deleted": deleted,
      "include_deleted": include_deleted,
    };
  }

  factory ChannelSearchModel.fromEntity(ChannelSearchEntity entity) {
    return ChannelSearchModel(
      term: entity.term,
      team_ids: entity.team_ids,
      public: entity.public,
      private: entity.private,
      deleted: entity.deleted,
      include_deleted: entity.include_deleted,
    );
  }

  @override
  ChannelSearchModel copyWith({
    String? term,
    List<String>? team_ids,
    bool? public,
    bool? private,
    bool? deleted,
    bool? include_deleted,
  }) {
    return ChannelSearchModel(
      term: term ?? this.term,
      team_ids: team_ids ?? this.team_ids,
      public: public ?? this.public,
      private: private ?? this.private,
      deleted: deleted ?? this.deleted,
      include_deleted: include_deleted ?? this.include_deleted,
    );
  }

  ChannelSearchEntity toEntity() => ChannelSearchEntity(
        term: term,
        team_ids: team_ids,
        public: public,
        private: private,
        deleted: deleted,
        include_deleted: include_deleted,
      );
}
