import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';

/// إحصائيات غير المقروء لقناة: عدد الرسائل غير المقروءة والمنشنات.
class ChannelUnreadCounts {
  final int messages;
  final int mentions;

  const ChannelUnreadCounts({required this.messages, required this.mentions});

  bool get hasUnreads => messages > 0 || mentions > 0;
}

abstract class ChannelRepository {
  Future<List<ChannelEntity>> getChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelEntity>> getMyChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<ChannelEntity> getChannelById(String channelId);

  /// إنشاء رسالة مباشرة — يطابق POST /channels/direct.
  Future<ChannelEntity> createDirectChannel(List<String> userIds);

  /// إنشاء محادثة جماعية (GM) — يطابق POST /channels/group.
  Future<ChannelEntity> createGroupChannel(List<String> userIds);

  /// إنشاء قناة جديدة — يطابق POST /channels.
  Future<ChannelEntity> createChannel({
    required String teamId,
    required String displayName,
    required String name,
    required ChannelType type,
    String purpose = '',
  });

  /// إنشاء فئة جديدة في الشريط الجانبي — يطابق POST /users/{userId}/teams/{teamId}/channels/categories.
  Future<ChannelCategoryEntity> createChannelCategory(
    String userId,
    String teamId, {
    String? displayName,
    List<String>? channelIds,
  });

  /// تحديث قائمة الفئات كاملة — يطابق PUT /users/{userId}/teams/{teamId}/channels/categories.
  Future<List<ChannelCategoryEntity>> updateChannelCategories(
    String teamId,
    String userId,
    List<ChannelCategoryEntity> categories,
  );

  /// تحديث جزئي للقناة (مثل notify_props) — يطابق PATCH /channels/{id}.
  Future<void> updateChannel(
    String channelId, {
    String? name,
    String? displayName,
    String? purpose,
    String? header,
    Map<String, dynamic>? notifyProps,
  });

  /// تحديث خصوصية القناة (خاص/عام) — يطابق PUT /channels/{id}/privacy.
  Future<ChannelEntity> updateChannelPrivacy(String channelId, String privacy);

  /// أرشفة القناة — يطابق DELETE /channels/{id}.
  Future<void> deleteChannel(String channelId);

  Future<List<ChannelMemberEntity>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<ChannelMemberEntity> getMyChannelMember(String channelId);
  Future<ChannelStats> getChannelStats(String channelId);
  Future<List<ChannelCategoryEntity>> getChannelCategories(
    String teamId,
    String userId,
  );
  Future<List<String>> getChannelCategoryOrder(String teamId, String userId);
  Future<List<ChannelBookmarkEntity>> getChannelBookmarks(String channelId);

  /// كل عضويات المستخدم في فريق واحد (استدعاء واحد).
  Future<List<ChannelMemberEntity>> getMyChannelMembersInTeam(String teamId);

  /// خريطة channelId ← عدد غير المقروء/المنشنات (يُحسب من channel.totalMsgCount).
  Future<Map<String, ChannelUnreadCounts>> getUnreadCountsForTeam(
    String teamId, {
    required List<ChannelEntity> channels,
  });
}
