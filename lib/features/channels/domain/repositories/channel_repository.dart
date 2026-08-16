import 'package:flutter_mattermost/core/enums/category_sorting.dart';
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
    String? type,
  });

  /// تحديث فئة واحدة (إعادة تسمية/نقل قنوات/كتم/ترتيب/طي) — يطابق
  /// PUT /users/{userId}/teams/{teamId}/channels/categories/{categoryId}.
  Future<ChannelCategoryEntity> updateChannelCategory(
    String userId,
    String teamId,
    String categoryId, {
    String? displayName,
    List<String>? channelIds,
    bool? muted,
    CategorySorting? sorting,
    bool? collapsed,
  });

  /// حذف فئة — يطابق DELETE /users/{userId}/teams/{teamId}/channels/categories/{categoryId}.
  Future<void> deleteChannelCategory(
    String userId,
    String teamId,
    String categoryId,
  );

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

  /// مغادرة قناة (أو إلغاء تفعيل DM/GM) — يطابق DELETE /channels/{channel_id}/members/{user_id}.
  Future<void> leaveChannel(String channelId, String userId);

  Future<List<ChannelMemberEntity>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });

  /// إضافة أعضاء للقناة — يطابق POST /channels/{id}/members.
  Future<void> addChannelMembers(String channelId, List<String> userIds);

  /// إزالة عضو من القناة — يطابق DELETE /channels/{id}/members/{user_id}.
  Future<void> removeChannelMember(String channelId, String userId);

  /// ترقية/تنزيل دور عضو (channel admin / channel member) —
  /// يطابق PUT /channels/{id}/members/{user_id}/scheme_roles.
  Future<void> updateChannelMemberSchemeRoles(
    String channelId,
    String userId, {
    bool schemeAdmin = false,
  });
  Future<ChannelMemberEntity> getMyChannelMember(String channelId);
  Future<ChannelStats> getChannelStats(String channelId);
  Future<List<ChannelCategoryEntity>> getChannelCategories(
    String teamId,
    String userId,
  );
  Future<List<String>> getChannelCategoryOrder(String teamId, String userId);
  Future<List<ChannelBookmarkEntity>> getChannelBookmarks(String channelId);

  /// إضافة إشارة مرجعية — يطابق POST /channels/{channel_id}/bookmarks.
  Future<ChannelBookmarkEntity> createChannelBookmark(
    String channelId, {
    String? linkUrl,
    String? postId,
    String? fileId,
    String? emoji,
    String? label,
  });

  /// تعديل إشارة مرجعية — يطابق PATCH /channels/{channel_id}/bookmarks/{id}.
  Future<ChannelBookmarkEntity> updateChannelBookmark(
    String channelId,
    String bookmarkId, {
    String? linkUrl,
    String? label,
    String? emoji,
  });

  /// حذف إشارة مرجعية — يطابق DELETE /channels/{channel_id}/bookmarks/{id}.
  Future<void> deleteChannelBookmark(String channelId, String bookmarkId);

  /// الفرق المشتركة بين أعضاء محادثة مباشرة/جماعية — مطابق
  /// GET /channels/{channel_id}/common_teams في webapp. تُستخدم لفحص
  /// Restricted DM: إذا كانت القائمة فارغة فلا يشارك الطرفان أي فريق.
  Future<List<String>> getGroupMessageMembersCommonTeams(String channelId);

  /// كل عضويات المستخدم في فريق واحد (استدعاء واحد).
  Future<List<ChannelMemberEntity>> getMyChannelMembersInTeam(String teamId);

  /// خريطة channelId ← عدد غير المقروء/المنشنات (يُحسب من channel.totalMsgCount).
  Future<Map<String, ChannelUnreadCounts>> getUnreadCountsForTeam(
    String teamId, {
    required List<ChannelEntity> channels,
  });

  /// تعليم قناة كمقروءة — يطابق view /users/{userId}/channels/{channelId}/view.
  Future<void> viewMyChannel(String channelId);

  /// تعليم عدة قنوات كمقروءة دفعة واحدة (تستخدمها «تعليم الفئة كمقروءة»).
  Future<void> readMultipleChannels(List<String> channelIds);
}
