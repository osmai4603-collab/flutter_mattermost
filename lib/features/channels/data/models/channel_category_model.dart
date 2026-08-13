import 'package:flutter_mattermost/core/enums/category_sorting.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';

final class ChannelCategoryModel extends ChannelCategoryEntity {
  const ChannelCategoryModel({
    required super.id,
    required super.teamId,
    super.userId,
    super.displayName,
    super.type,
    super.channelIds,
    super.sorting,
    super.sortOrder,
    super.muted,
    super.collapsed,
    super.propsData,
  });

  factory ChannelCategoryModel.fromMap(Map<String, dynamic> data) {
    return ChannelCategoryModel(
      id: data['id'] ?? '',
      teamId: data['team_id'] ?? '',
      userId: data['user_id'] ?? '',
      displayName: data['display_name'] ?? '',
      type: ChannelCategoryType.fromValue(data['type'] ?? 'custom'),
      channelIds: List<String>.from(data['channel_ids'] ?? const []),
      sorting: CategorySorting.fromValue(data['sorting'] ?? 'recent'),
      sortOrder: (data['sort_order'] ?? 0).toInt(),
      muted: data['muted'] ?? false,
      collapsed: data['collapsed'] ?? false,
      propsData: Map<String, dynamic>.from(data['props'] ?? const {}),
    );
  }

  factory ChannelCategoryModel.fromEntity(ChannelCategoryEntity entity) {
    return ChannelCategoryModel(
      id: entity.id,
      teamId: entity.teamId,
      userId: entity.userId,
      displayName: entity.displayName,
      type: entity.type,
      channelIds: entity.channelIds,
      sorting: entity.sorting,
      sortOrder: entity.sortOrder,
      muted: entity.muted,
      collapsed: entity.collapsed,
      propsData: entity.propsData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team_id': teamId,
      'user_id': userId,
      'display_name': displayName,
      'type': type.value,
      'channel_ids': channelIds,
      'sorting': sorting.value,
      'sort_order': sortOrder,
      'muted': muted,
      'collapsed': collapsed,
      'props': propsData,
    };
  }

  @override
  ChannelCategoryModel copyWith({
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
    return ChannelCategoryModel(
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

  ChannelCategoryEntity toEntity() {
    return ChannelCategoryEntity(
      id: id,
      teamId: teamId,
      userId: userId,
      displayName: displayName,
      type: type,
      channelIds: channelIds,
      sorting: sorting,
      sortOrder: sortOrder,
      muted: muted,
      collapsed: collapsed,
      propsData: propsData,
    );
  }
}
