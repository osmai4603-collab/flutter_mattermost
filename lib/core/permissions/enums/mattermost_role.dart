import 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';

/// الأدوار المدمجة القياسية في Mattermost (من Server model/permissions).
enum MMRole {
  /// دور مسؤول النظام بالكامل
  systemAdmin('system_admin', {
    MMPermission.manageSystem,
    MMPermission.manageJobs,
  }),

  /// دور مستخدم النظام القياسي
  systemUser('system_user', {
    MMPermission.createDirectChannel,
    MMPermission.createGroupChannel,
    MMPermission.createTeam,
    MMPermission.listPublicTeams,
    MMPermission.joinPublicTeams,
    MMPermission.createCustomGroup,
    MMPermission.manageCustomGroupMembers,
  }),

  /// دور ضيف النظام
  systemGuest('system_guest', {
    MMPermission.createDirectChannel,
    MMPermission.createGroupChannel,
  }),

  /// دور مسؤول الفريق
  teamAdmin('team_admin', {
    MMPermission.viewTeam,
    MMPermission.viewMembers,
    MMPermission.manageTeam,
    MMPermission.manageTeamRoles,
    MMPermission.removeUserFromTeam,
    MMPermission.addUserToTeam,
    MMPermission.inviteUser,
    MMPermission.inviteGuest,
    MMPermission.promoteGuest,
    MMPermission.demoteToGuest,
    MMPermission.manageBots,
    MMPermission.readBots,
    MMPermission.createPublicChannel,
    MMPermission.createPrivateChannel,
    MMPermission.deletePublicChannel,
    MMPermission.deletePrivateChannel,
  }),

  /// دور مستخدم الفريق
  teamUser('team_user', {
    MMPermission.viewTeam,
    MMPermission.viewMembers,
    MMPermission.createPublicChannel,
    MMPermission.createPrivateChannel,
    MMPermission.joinPublicTeams,
    MMPermission.inviteUser,
  }),

  /// دور ضيف الفريق
  teamGuest('team_guest', {MMPermission.viewTeam, MMPermission.viewMembers}),

  /// دور مسؤول القناة
  channelAdmin('channel_admin', {
    MMPermission.readPublicChannel,
    MMPermission.useChannelMentions,
    MMPermission.createPost,
    MMPermission.useGroupMentions,
    MMPermission.addReaction,
    MMPermission.removeReaction,
    MMPermission.managePublicChannelMembers,
    MMPermission.manageChannelRoles,
    MMPermission.addBookmarkPublicChannel,
    MMPermission.managePrivateChannelMembers,
    MMPermission.managePublicChannelProperties,
    MMPermission.managePrivateChannelProperties,
    MMPermission.convertPublicChannelToPrivate,
    MMPermission.editPost,
    MMPermission.deletePost,
    MMPermission.deleteOthersPosts,
    MMPermission.removeOthersReactions,
  }),

  /// دور مستخدم القناة
  channelUser('channel_user', {
    MMPermission.readPublicChannel,
    MMPermission.createPost,
    MMPermission.editPost,
    MMPermission.deletePost,
    MMPermission.addReaction,
    MMPermission.removeReaction,
    MMPermission.useChannelMentions,
    MMPermission.useGroupMentions,
    MMPermission.useSlashCommands,
  }),

  /// دور ضيف القناة
  channelGuest('channel_guest', {
    MMPermission.readPublicChannel,
    MMPermission.createPost,
    MMPermission.editPost,
    MMPermission.deletePost,
    MMPermission.addReaction,
    MMPermission.removeReaction,
    MMPermission.useSlashCommands,
  });

  /// القيمة النصية الصريحة للدور في Mattermost Server.
  final String value;

  /// مجموعة الأذونات المخصصة لهذا الدور بشكل افتراضي.
  final Set<MMPermission> permissions;

  const MMRole(this.value, this.permissions);

  /// يفحص ما إذا كان هذا الدور يمتلك الصلاحية المطلوبة.
  bool hasPermission(MMPermission permission) {
    if (this == MMRole.systemAdmin) return true;
    return permissions.contains(permission);
  }

  /// تحويل النص إلى [MMRole] إن وجد.
  static MMRole? of(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final role in MMRole.values) {
      if (role.value == value) {
        return role;
      }
    }
    return null;
  }

  bool hasAnyPermissions(Set<MMPermission> permissions) {
    return this.permissions.any(
      (permission) => permissions.contains(permission),
    );
  }

  bool hasAllPermissions(List<MMPermission> permissions) {
    return !permissions
        .map((permission) {
          return this.permissions.contains(permission);
        })
        .toSet()
        .contains(false);
  }
}
