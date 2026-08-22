import 'package:flutter_mattermost/core/entities/entity.dart';

class ChannelMemberEntity extends Entity {
  final String channelId;
  final String userId;
  final String roles;
  final int lastViewedAt;
  final int msgCount;
  final int mentionCount;
  final int mentionCountRoot;
  final int msgCountRoot;
  final ChannelMemeberNotifyProps? notifyProps;
  final int lastUpdateAt;
  final bool schemeGuest;
  final bool schemeUser;
  final bool schemeAdmin;
  final String explicitRoles;
  final bool autoTranslationDisabled;

  const ChannelMemberEntity({
    required this.channelId,
    required this.userId,
    this.roles = '',
    this.lastViewedAt = 0,
    this.msgCount = 0,
    this.mentionCount = 0,
    this.notifyProps,
    this.lastUpdateAt = 0,
    required this.schemeGuest,
    required this.schemeUser,
    required this.schemeAdmin,
    required this.explicitRoles,
    required this.autoTranslationDisabled,
    required this.mentionCountRoot,
    required this.msgCountRoot,
  });

  @override
  List<Object?> get props => [
    channelId,
    userId,
    roles,
    lastViewedAt,
    msgCount,
    mentionCount,
    notifyProps,
    lastUpdateAt,
  ];

  ChannelMemberEntity copyWith({
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
    return ChannelMemberEntity(
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
}

class ChannelMemeberNotifyProps extends Entity {
  final String channelAutoFollowThreads;
  final String desktop;
  final String email;
  final String ignoreChannelMentions;
  final String markUnread;
  final String push;

  const ChannelMemeberNotifyProps({
    required this.channelAutoFollowThreads,
    required this.desktop,
    required this.email,
    required this.ignoreChannelMentions,
    required this.markUnread,
    required this.push,
  });

  @override
  List<Object?> get props => [
    channelAutoFollowThreads,
    desktop,
    email,
    ignoreChannelMentions,
    markUnread,
    push,
  ];

  ChannelMemeberNotifyProps copyWith({
    String? channelAutoFollowThreads,
    String? desktop,
    String? email,
    String? ignoreChannelMentions,
    String? markRead,
    String? push,
  }) {
    return ChannelMemeberNotifyProps(
      channelAutoFollowThreads:
          channelAutoFollowThreads ?? this.channelAutoFollowThreads,
      desktop: desktop ?? this.desktop,
      email: email ?? this.email,
      ignoreChannelMentions:
          ignoreChannelMentions ?? this.ignoreChannelMentions,
      markUnread: markRead ?? this.markUnread,
      push: push ?? this.push,
    );
  }
}
