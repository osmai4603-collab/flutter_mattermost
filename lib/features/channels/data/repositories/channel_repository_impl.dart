import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channel_bookmarks_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channel_categories_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channel_members_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channels_remote_data_source.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_category_model.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';

@LazySingleton(as: ChannelRepository)
class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteDataSource _remoteDataSource;
  final ChannelMembersRemoteDataSource _membersDataSource;
  final ChannelCategoriesRemoteDataSource _categoriesDataSource;
  final ChannelBookmarksRemoteDataSource _bookmarksDataSource;
  final ChatLocalDataSource _localDataSource;

  ChannelRepositoryImpl(
    this._remoteDataSource,
    this._membersDataSource,
    this._categoriesDataSource,
    this._bookmarksDataSource,
    this._localDataSource,
  );

  @override
  Future<List<ChannelEntity>> getChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    try {
      final models = await _remoteDataSource.getChannelsForTeam(
        teamId,
        page: page,
        perPage: perPage,
      );
      final entities = models.map((m) => m.toEntity()).toList();

      await _localDataSource.cacheChannels(entities);
      return entities;
    } catch (_) {
      return await _localDataSource.getCachedChannels(teamId);
    }
  }

  @override
  Future<List<ChannelEntity>> getMyChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getMyChannels(
      teamId,
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ChannelEntity> getChannelById(String channelId) async {
    final model = await _remoteDataSource.getChannelById(channelId);
    return model.toEntity();
  }

  @override
  Future<void> updateChannel(
    String channelId, {
    String? name,
    String? displayName,
    String? purpose,
    String? header,
    Map<String, dynamic>? notifyProps,
  }) async {
    await _remoteDataSource.patchChannel(
      channelId,
      name: name,
      displayName: displayName,
      purpose: purpose,
      header: header,
      notifyProps: notifyProps,
    );
  }

  @override
  Future<ChannelEntity> updateChannelPrivacy(
    String channelId,
    String privacy,
  ) async {
    final model = await _remoteDataSource.updateChannelPrivacy(
      channelId,
      privacy,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteChannel(String channelId) =>
      _remoteDataSource.deleteChannel(channelId);

  @override
  Future<ChannelEntity> createDirectChannel(List<String> userIds) async {
    final model = await _remoteDataSource.createDirectChannel(
      userIds.first,
      otherUserIds: userIds.length > 1 ? userIds.sublist(1) : null,
    );
    return model.toEntity();
  }

  @override
  Future<ChannelEntity> createGroupChannel(List<String> userIds) async {
    final model = await _remoteDataSource.createGroupChannel(userIds);
    return model.toEntity();
  }

  @override
  Future<ChannelEntity> createChannel({
    required String teamId,
    required String displayName,
    required String name,
    required ChannelType type,
    String purpose = '',
  }) async {
    final model = await _remoteDataSource.createChannel(
      teamId: teamId,
      displayName: displayName,
      name: name,
      type: type.value,
      purpose: purpose,
    );
    return model.toEntity();
  }

  @override
  Future<ChannelCategoryEntity> createChannelCategory(
    String userId,
    String teamId, {
    String? displayName,
    List<String>? channelIds,
  }) async {
    final model = await _categoriesDataSource.createChannelCategory(
      userId,
      teamId,
      displayName: displayName,
      channelIds: channelIds,
    );
    return model.toEntity();
  }

  @override
  Future<List<ChannelCategoryEntity>> updateChannelCategories(
    String teamId,
    String userId,
    List<ChannelCategoryEntity> categories,
  ) async {
    final models = await _categoriesDataSource.updateChannelCategories(
      userId,
      teamId,
      categories
          .map((c) => ChannelCategoryModel.fromEntity(c).toMap())
          .toList(),
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ChannelMemberEntity>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final members = await _membersDataSource.getChannelMembers(
      channelId,
      page: page,
      perPage: perPage,
    );
    return members.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ChannelMemberEntity> getMyChannelMember(String channelId) async {
    final m = await _membersDataSource.getMyChannelMember(channelId);
    return m.toEntity();
  }

  @override
  Future<List<ChannelMemberEntity>> getMyChannelMembersInTeam(
    String teamId,
  ) async {
    final members = await _membersDataSource.getMyChannelMembers(teamId);
    return members.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<String, ChannelUnreadCounts>> getUnreadCountsForTeam(
    String teamId, {
    required List<ChannelEntity> channels,
  }) async {
    try {
      final members = await getMyChannelMembersInTeam(teamId);
      final byChannel = {for (final m in members) m.channelId: m};
      return {
        for (final channel in channels)
          channel.id: ChannelUnreadCounts(
            messages:
                (channel.totalMsgCount - (byChannel[channel.id]?.msgCount ?? 0))
                    .clamp(0, 1 << 31),
            mentions: byChannel[channel.id]?.mentionCount ?? 0,
          ),
      };
    } catch (_) {
      return {};
    }
  }

  @override
  Future<ChannelStats> getChannelStats(String channelId) async {
    final model = await _remoteDataSource.getChannelStats(channelId);
    return model.toEntity();
  }

  @override
  Future<List<ChannelCategoryEntity>> getChannelCategories(
    String teamId,
    String userId,
  ) async {
    final categories = await _categoriesDataSource.getChannelCategories(
      userId,
      teamId,
    );
    return categories.map((c) => c.toEntity()).toList();
  }

  @override
  Future<List<String>> getChannelCategoryOrder(String teamId, String userId) =>
      _categoriesDataSource.getChannelCategoryOrder(userId, teamId);

  @override
  Future<List<ChannelBookmarkEntity>> getChannelBookmarks(
    String channelId,
  ) async {
    final bookmarks = await _bookmarksDataSource.getChannelBookmarks(channelId);
    return bookmarks.map((b) => b.toEntity()).toList();
  }
}
