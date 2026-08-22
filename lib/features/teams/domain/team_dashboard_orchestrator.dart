import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/groups_associated_to_channels_model.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/drafts_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/scheduled_posts_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/scheduled_post_model.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:flutter_mattermost/features/users/data/datasources/user_status_remote_data_source.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_status_model.dart';
import 'package:flutter_mattermost/features/common/data/datasources/playbooks_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channel_bookmarks_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_bookmark_model.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/agents_remote_data_source.dart';

import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';

/// النتيجة الشاملة لتحميل واجهة الفريق
class TeamDashboardData {
  final String teamId;
  final String userId;

  // المرحلة 1: القنوات والهيكلية
  final List<ChannelEntity> channels;
  final List<ChannelCategoryEntity> categories;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final Map<String, ChannelMemberEntity> members;

  // المجموعات، الخيوط، المسودات والمؤثرات
  final List<GroupModel> userGroups;
  final GroupsAssociatedToChannelsModel? channelGroups;
  final Map<String, dynamic> threadsSummary;
  final List<DraftModel> teamDrafts;
  final List<ScheduledPostModel> scheduledPosts;

  // مستخدمو الفريق وحالاتهم
  final List<UserModel> userProfiles;
  final List<UserStatusModel> userStatuses;

  // الإضافات وبوتات الذكاء الاصطناعي (Agents)
  final List<Map<String, dynamic>> agents;
  final Map<String, dynamic> agentsStatus;

  const TeamDashboardData({
    required this.teamId,
    required this.userId,
    required this.channels,
    required this.categories,
    required this.unreadCounts,
    required this.members,
    this.userGroups = const [],
    this.channelGroups,
    this.threadsSummary = const {},
    this.teamDrafts = const [],
    this.scheduledPosts = const [],
    this.userProfiles = const [],
    this.userStatuses = const [],
    this.agents = const [],
    this.agentsStatus = const {},
  });
}

@LazySingleton()
class TeamDashboardOrchestrator {
  final ChannelRepository _channelRepository;
  final GroupsRemoteDataSource _groupsRemoteDataSource;
  final ThreadsRemoteDataSource _threadsRemoteDataSource;
  final DraftsRemoteDataSource _draftsRemoteDataSource;
  final ScheduledPostsRemoteDataSource _scheduledPostsRemoteDataSource;
  final UsersRemoteDataSource _usersRemoteDataSource;
  final UserStatusRemoteDataSource _userStatusRemoteDataSource;
  final PlaybooksRemoteDataSource _playbooksRemoteDataSource;
  final ChannelBookmarksRemoteDataSource _channelBookmarksRemoteDataSource;
  final AgentsRemoteDataSource _agentsRemoteDataSource;
  final PostRemoteDataSource _postRemoteDataSource;

  TeamDashboardOrchestrator(
    this._channelRepository,
    this._groupsRemoteDataSource,
    this._threadsRemoteDataSource,
    this._draftsRemoteDataSource,
    this._scheduledPostsRemoteDataSource,
    this._usersRemoteDataSource,
    this._userStatusRemoteDataSource,
    this._playbooksRemoteDataSource,
    this._channelBookmarksRemoteDataSource,
    this._agentsRemoteDataSource,
    this._postRemoteDataSource,
  );

  /// تحميل كل عمليات واجهة الفريق بشكل متزامن هجين (Parallel Lifecycle Load)
  Future<TeamDashboardData> loadTeamDashboard({
    required String teamId,
    String? userId,
  }) async {
    final uid = (userId != null && userId.isNotEmpty) ? userId : 'me';

    // 1. العمليات الأساسية للقنوات (المرحلة 1)
    final channelsFuture = _channelRepository
        .getMyChannels(teamId)
        .catchError((_) => <ChannelEntity>[]);
    final categoriesFuture = _channelRepository
        .getChannelCategories(teamId, uid)
        .catchError((_) => <ChannelCategoryEntity>[]);
    final membersFuture = _channelRepository
        .getMyChannelMembersInTeam(teamId)
        .catchError((_) => <ChannelMemberEntity>[]);

    // 2. الهيكلية والمجموعات (AD/LDAP & Channel Groups)
    final userGroupsFuture = _groupsRemoteDataSource
        .getGroupsByUserId(uid)
        .catchError((_) => <GroupModel>[]);
    final Future<GroupsAssociatedToChannelsModel?> channelGroupsFuture =
        _groupsRemoteDataSource
            .getGroupsAssociatedToChannelsByTeam(teamId: teamId)
            .then<GroupsAssociatedToChannelsModel?>((val) => val)
            .catchError((_, _) => null);

    // 3. الخيوط والمسودات والرسائل المجدولة
    final threadsSummaryFuture = _threadsRemoteDataSource
        .getThreadsForUser(teamId, totalsOnly: true)
        .catchError((_) => <String, dynamic>{});
    final draftsFuture = _draftsRemoteDataSource
        .getDraftsForTeam(uid, teamId)
        .catchError((_) => <DraftModel>[]);
    final scheduledPostsFuture = _scheduledPostsRemoteDataSource
        .getScheduledPosts(teamId: teamId)
        .catchError((_) => <ScheduledPostModel>[]);

    // 4. أعضاء الفريق والـ Agents
    final userProfilesFuture = _usersRemoteDataSource
        .getProfiles(page: 0, perPage: 100)
        .catchError((_) => <UserModel>[]);
    final agentsFuture = _agentsRemoteDataSource.getAgents().catchError(
      (_) => <Map<String, dynamic>>[],
    );
    final agentsStatusFuture = _agentsRemoteDataSource
        .getAgentsStatus()
        .catchError((_) => <String, dynamic>{});

    // تنفيذ كل العمليات متزامنة
    final results = await Future.wait<dynamic>([
      channelsFuture,
      categoriesFuture,
      membersFuture,
      userGroupsFuture,
      channelGroupsFuture,
      threadsSummaryFuture,
      draftsFuture,
      scheduledPostsFuture,
      userProfilesFuture,
      agentsFuture,
      agentsStatusFuture,
    ]);

    final channels = results[0] as List<ChannelEntity>;
    final categories = results[1] as List<ChannelCategoryEntity>;
    final memberList = results[2] as List<ChannelMemberEntity>;
    final members = {for (final m in memberList) m.channelId: m};

    final resolvedUserId = (userId != null && userId.isNotEmpty)
        ? userId
        : (memberList.isNotEmpty ? memberList.first.userId : '');

    // جلب عدادات غير المقروء بعد توفر القنوات
    Map<String, ChannelUnreadCounts> unreadCounts = {};
    if (channels.isNotEmpty) {
      try {
        unreadCounts = await _channelRepository.getUnreadCountsForTeam(
          teamId,
          channels: channels,
        );
      } catch (_) {}
    }

    final userGroups = results[3] as List<GroupModel>;
    final channelGroups = results[4] as GroupsAssociatedToChannelsModel?;
    final threadsSummary = results[5] as Map<String, dynamic>;
    final teamDrafts = results[6] as List<DraftModel>;
    final scheduledPosts = results[7] as List<ScheduledPostModel>;
    final userProfiles = results[8] as List<UserModel>;
    final agents = results[9] as List<Map<String, dynamic>>;
    final agentsStatus = results[10] as Map<String, dynamic>;

    // 5. جلب حالات اتصال المستخدمين استناداً لمعرّفات البروفايلات المحمّلة
    List<UserStatusModel> userStatuses = [];
    if (userProfiles.isNotEmpty) {
      final userIds = userProfiles.map((u) => u.id).take(100).toList();
      try {
        userStatuses = await _userStatusRemoteDataSource.getStatusesByIds(
          userIds,
        );
      } catch (_) {}
    }

    return TeamDashboardData(
      teamId: teamId,
      userId: resolvedUserId,
      channels: channels,
      categories: categories,
      unreadCounts: unreadCounts,
      members: members,
      userGroups: userGroups,
      channelGroups: channelGroups,
      threadsSummary: threadsSummary,
      teamDrafts: teamDrafts,
      scheduledPosts: scheduledPosts,
      userProfiles: userProfiles,
      userStatuses: userStatuses,
      agents: agents,
      agentsStatus: agentsStatus,
    );
  }

  /// فتح القناة النشطة وجلب الرسائل غير المقروءة والروابط الإضافية (المرحلة 4 + 5)
  Future<List<PostModel>> loadActiveChannelDetails({
    required String channelId,
    required String userId,
  }) async {
    try {
      // إطلاق إحصائيات القناة، الإشارات المرجعية وقواعد Playbooks بشكل متزامن
      unawaited(
        _playbooksRemoteDataSource
            .getChannelActions(channelId, triggerType: 'new_member_joins')
            .catchError((_) => <dynamic>[]),
      );

      unawaited(
        _channelBookmarksRemoteDataSource
            .getChannelBookmarks(channelId)
            .catchError((_) => <ChannelBookmarkModel>[]),
      );

      // 4.3 العملية الأهم: جلب الرسائل غير المقروءة للقناة التي دخل إليها المستخدم
      final unreadPosts = await _postRemoteDataSource.getPostsUnread(
        userId.isEmpty ? 'me' : userId,
        channelId,
        limitBefore: 30,
        limitAfter: 30,
      );

      return unreadPosts;
    } catch (e) {
      debugPrint('[TeamDashboardOrchestrator] Failed active channel load: $e');
      return [];
    }
  }
}
