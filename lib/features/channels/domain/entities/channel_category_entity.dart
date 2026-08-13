import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/category_sorting.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';

class ChannelCategoryEntity extends Entity {
  final String id;
  final String teamId;
  final String userId;
  final String displayName;
  final ChannelCategoryType type;
  final List<String> channelIds;
  final CategorySorting sorting;
  final int sortOrder;
  final bool muted;

  /// حالة طي الفئة في الشريط الجانبي — تُحفظ على الخادم (مطابق
  /// `collapsed` في واجهة الفئات) وتُقرأ عند إعادة التحميل.
  final bool collapsed;
  final Map<String, dynamic> propsData;

  const ChannelCategoryEntity({
    required this.id,
    required this.teamId,
    this.userId = '',
    this.displayName = '',
    this.type = ChannelCategoryType.custom,
    this.channelIds = const [],
    this.sorting = CategorySorting.recent,
    this.sortOrder = 0,
    this.muted = false,
    this.collapsed = false,
    this.propsData = const {},
  });

  @override
  List<Object?> get props => [
        id,
        teamId,
        userId,
        displayName,
        type,
        channelIds,
        sorting,
        sortOrder,
        muted,
        collapsed,
        propsData,
      ];

  @override
  ChannelCategoryEntity copyWith({
    String? id,
    String? teamId,
    String? userId,
    String? displayName,
    ChannelCategoryType? type,
    List<String>? channelIds,
    CategorySorting? sorting,
    int? sortOrder,
    bool? muted,
    bool? collapsed,
    Map<String, dynamic>? propsData,
  }) {
    return ChannelCategoryEntity(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      channelIds: channelIds ?? this.channelIds,
      sorting: sorting ?? this.sorting,
      sortOrder: sortOrder ?? this.sortOrder,
      muted: muted ?? this.muted,
      collapsed: collapsed ?? this.collapsed,
      propsData: propsData ?? this.propsData,
    );
  }
}
