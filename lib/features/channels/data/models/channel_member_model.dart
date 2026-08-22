import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';

final class ChannelMemberModel extends ChannelMemberEntity {
  const ChannelMemberModel({
    required super.channelId,
    required super.userId,
    required super.roles,
    required super.lastViewedAt,
    required super.msgCount,
    required super.mentionCount,
    required super.notifyProps,
    required super.lastUpdateAt,
    required super.schemeGuest,
    required super.schemeAdmin,
    required super.schemeUser,
    required super.autoTranslationDisabled,
    required super.explicitRoles,
    required super.mentionCountRoot,
    required super.msgCountRoot,
  });

  factory ChannelMemberModel.fromMap(Map<String, dynamic> data) {
    return ChannelMemberModel(
      channelId: data['channel_id'] ?? '',
      userId: data['user_id'] ?? '',
      roles: data['roles'] ?? '',
      lastViewedAt: (data['last_viewed_at'] ?? 0).toInt(),
      msgCount: (data['msg_count'] ?? 0).toInt(),
      mentionCount: (data['mention_count'] ?? 0).toInt(),
      notifyProps: ChannelMemberNofigyPropsModel.fromJson(
        data['notify_props'] ?? const {},
      ),
      lastUpdateAt: (data['last_update_at'] ?? 0).toInt(),
      schemeGuest: data['scheme_guest'] ?? false,
      schemeAdmin: data['scheme_admin'] ?? false,
      schemeUser: data['scheme_user'] ?? false,
      explicitRoles: data['explicit_roles'] ?? '',
      autoTranslationDisabled: data['autotranslation_disabled'] ?? false,
      mentionCountRoot: data['mention_count_root'] ?? 0,
      msgCountRoot: data['msg_count_root'] ?? 0,
    );
  }

  factory ChannelMemberModel.fromEntity(ChannelMemberEntity entity) {
    return ChannelMemberModel(
      channelId: entity.channelId,
      userId: entity.userId,
      roles: entity.roles,
      lastViewedAt: entity.lastViewedAt,
      msgCount: entity.msgCount,
      mentionCount: entity.mentionCount,
      notifyProps: entity.notifyProps,
      lastUpdateAt: entity.lastUpdateAt,
      schemeAdmin: entity.schemeAdmin,
      schemeGuest: entity.schemeGuest,
      schemeUser: entity.schemeUser,
      explicitRoles: entity.explicitRoles,
      autoTranslationDisabled: entity.autoTranslationDisabled,
      mentionCountRoot: entity.mentionCountRoot,
      msgCountRoot: entity.msgCountRoot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channel_id': channelId,
      'user_id': userId,
      'roles': roles,
      'last_viewed_at': lastViewedAt,
      'msg_count': msgCount,
      'mention_count': mentionCount,
      'mention_count_root': mentionCountRoot,
      'msg_count_root': msgCountRoot,
      'notify_props': (notifyProps as ChannelMemberNofigyPropsModel).toMap(),
      'last_update_at': lastUpdateAt,
      'scheme_admin': schemeAdmin,
      'scheme_user': schemeUser,
      'scheme_guest': schemeGuest,
      'autotranslation_disabled': autoTranslationDisabled,
      'explicit_roles': explicitRoles,
    };
  }

  @override
  ChannelMemberModel copyWith({
    String? serverId,
    String? channelId,
    String? userId,
    String? roles,
    int? lastViewedAt,
    int? msgCount,
    int? mentionCount,
    ChannelMemeberNotifyProps? notifyProps,
    int? lastUpdateAt,
    bool? schemeGuest,
    bool? schemeUser,
    bool? schemeAdmin,
    String? explicitRoles,
    bool? autoTranslationDisabled,
    int? mentionCountRoot,
    int? msgCountRoute,
  }) {
    return ChannelMemberModel(
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      msgCount: msgCount ?? this.msgCount,
      mentionCount: mentionCount ?? this.mentionCount,
      notifyProps: notifyProps ?? this.notifyProps,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      schemeGuest: schemeGuest ?? this.schemeGuest,
      schemeUser: schemeUser ?? this.schemeUser,
      schemeAdmin: schemeAdmin ?? this.schemeAdmin,
      explicitRoles: explicitRoles ?? this.explicitRoles,
      autoTranslationDisabled:
          autoTranslationDisabled ?? this.autoTranslationDisabled,
      mentionCountRoot: mentionCountRoot ?? this.mentionCountRoot,
      msgCountRoot: msgCountRoute ?? this.msgCountRoot,
    );
  }

  ChannelMemberEntity toEntity() {
    return ChannelMemberEntity(
      channelId: channelId,
      userId: userId,
      roles: roles,
      lastViewedAt: lastViewedAt,
      msgCount: msgCount,
      mentionCount: mentionCount,
      notifyProps: notifyProps,
      lastUpdateAt: lastUpdateAt,
      mentionCountRoot: mentionCountRoot,
      msgCountRoot: msgCountRoot,
      schemeAdmin: schemeAdmin,
      schemeGuest: schemeGuest,
      schemeUser: schemeUser,
      autoTranslationDisabled: autoTranslationDisabled,
      explicitRoles: explicitRoles,
    );
  }
}

class ChannelMemberNofigyPropsModel extends ChannelMemeberNotifyProps {
  const ChannelMemberNofigyPropsModel({
    required super.channelAutoFollowThreads,
    required super.desktop,
    required super.email,
    required super.ignoreChannelMentions,
    required super.markUnread,
    required super.push,
  });
  factory ChannelMemberNofigyPropsModel.fromJson(Map<String, dynamic> data) {
    return ChannelMemberNofigyPropsModel(
      channelAutoFollowThreads: data['channel_auto_follow_threads'] ?? '',
      email: data['email'] ?? '',
      desktop: data['desktop'] ?? '',
      ignoreChannelMentions: data['igore_channel_mentions'] ?? '',
      markUnread: data['mark_unread'] ?? '',
      push: data['push'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channel_auto_follow_threads': channelAutoFollowThreads,
      'email': email,
      'desktop': desktop,
      'igore_channel_mentions': ignoreChannelMentions,
      'mark_unread': markUnread,
      'push': push,
    };
  }
}
