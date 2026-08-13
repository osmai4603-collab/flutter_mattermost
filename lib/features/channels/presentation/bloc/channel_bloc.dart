import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';

// Events
abstract class ChannelEvent extends Equatable {
  const ChannelEvent();
  @override
  List<Object?> get props => [];
}

class LoadChannelsForTeamEvent extends ChannelEvent {
  final String teamId;
  final String? userId;
  const LoadChannelsForTeamEvent(this.teamId, {this.userId});
  @override
  List<Object?> get props => [teamId, userId];
}

class SelectChannelEvent extends ChannelEvent {
  final ChannelEntity channel;
  const SelectChannelEvent(this.channel);
  @override
  List<Object?> get props => [channel];
}

/// إضافة قناة (DM/GM) إلى القائمة أو تحديثها إن وُجدت.
class UpsertChannelEvent extends ChannelEvent {
  final ChannelEntity channel;
  const UpsertChannelEvent(this.channel);
  @override
  List<Object?> get props => [channel];
}

class CreateChannelEvent extends ChannelEvent {
  final String teamId;
  final String userId;
  final String displayName;
  final String name;
  final ChannelType type;
  final String purpose;
  final String? categoryId;
  final String? newCategoryName;

  const CreateChannelEvent({
    required this.teamId,
    required this.userId,
    required this.displayName,
    required this.name,
    required this.type,
    this.purpose = '',
    this.categoryId,
    this.newCategoryName,
  });

  @override
  List<Object?> get props => [
    teamId,
    userId,
    displayName,
    name,
    type,
    purpose,
    categoryId,
    newCategoryName,
  ];
}

class RealtimeChannelChangedEvent extends ChannelEvent {}

class UpdateChannelEvent extends ChannelEvent {
  final ChannelEntity channel;
  const UpdateChannelEvent(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ArchiveChannelEvent extends ChannelEvent {
  final ChannelEntity channel;
  const ArchiveChannelEvent(this.channel);
  @override
  List<Object?> get props => [channel];
}

class UpdateUnreadCountsEvent extends ChannelEvent {}

class ToggleMuteEvent extends ChannelEvent {
  final String channelId;
  final String userId;
  const ToggleMuteEvent({required this.channelId, required this.userId});
  @override
  List<Object?> get props => [channelId, userId];
}

class ToggleFavoriteEvent extends ChannelEvent {
  final String channelId;
  final String userId;
  final String teamId;
  const ToggleFavoriteEvent({
    required this.channelId,
    required this.userId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [channelId, userId, teamId];
}

/// نقل قناة بين فئات الشريط الجانبي (سحب وإفلات) — يطابق
/// PUT /users/{userId}/teams/{teamId}/channels/categories بعد التحديث.
class MoveChannelToCategoryEvent extends ChannelEvent {
  final String channelId;
  final String targetCategoryId;
  final String userId;
  final String teamId;
  const MoveChannelToCategoryEvent({
    required this.channelId,
    required this.targetCategoryId,
    required this.userId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [
    channelId,
    targetCategoryId,
    userId,
    teamId,
  ];
}

/// إعادة تسمية فئة — يطابق PUT /users/{userId}/teams/{teamId}/channels/categories/{categoryId}.
class RenameCategoryEvent extends ChannelEvent {
  final String categoryId;
  final String newName;
  final String userId;
  final String teamId;
  const RenameCategoryEvent({
    required this.categoryId,
    required this.newName,
    required this.userId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [categoryId, newName, userId, teamId];
}

/// كتم/إلغاء كتم فئة — يطابق PUT بنفس المسار مع muted.
class ToggleMuteCategoryEvent extends ChannelEvent {
  final String categoryId;
  final bool muted;
  final String userId;
  final String teamId;
  const ToggleMuteCategoryEvent({
    required this.categoryId,
    required this.muted,
    required this.userId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [categoryId, muted, userId, teamId];
}

/// حذف فئة — يطابق DELETE /users/{userId}/teams/{teamId}/channels/categories/{categoryId}.
class DeleteCategoryEvent extends ChannelEvent {
  final String categoryId;
  final String userId;
  final String teamId;
  const DeleteCategoryEvent({
    required this.categoryId,
    required this.userId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [categoryId, userId, teamId];
}

/// إنشاء فئة جديدة — يطابق POST /users/{userId}/teams/{teamId}/channels/categories.
class CreateCategoryEvent extends ChannelEvent {
  final String displayName;
  final String userId;
  final String teamId;
  final List<String>? channelIds;
  const CreateCategoryEvent({
    required this.displayName,
    required this.userId,
    required this.teamId,
    this.channelIds,
  });
  @override
  List<Object?> get props => [displayName, userId, teamId, channelIds];
}

/// مغادرة قناة/إلغاء تفعيل DM — يطابق DELETE /channels/{channel_id}/members/{user_id}.
class LeaveChannelEvent extends ChannelEvent {
  final String channelId;
  final String userId;
  const LeaveChannelEvent({required this.channelId, required this.userId});
  @override
  List<Object?> get props => [channelId, userId];
}

// States
abstract class ChannelState extends Equatable {
  const ChannelState();
  @override
  List<Object?> get props => [];
}

class ChannelInitialState extends ChannelState {}

class ChannelLoadingState extends ChannelState {}

class ChannelsLoadedState extends ChannelState {
  final String teamId;
  final List<ChannelEntity> channels;
  final List<ChannelCategoryEntity> categories;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final ChannelEntity? selectedChannel;
  final String userId;
  final Map<String, ChannelMemberEntity> members;

  const ChannelsLoadedState({
    required this.teamId,
    required this.channels,
    this.categories = const [],
    this.unreadCounts = const {},
    this.selectedChannel,
    this.userId = '',
    this.members = const {},
  });

  ChannelEntity? channelById(String id) {
    for (final c in channels) {
      if (c.id == id) return c;
    }
    return null;
  }

  ChannelUnreadCounts? unreadFor(String channelId) => unreadCounts[channelId];

  @override
  List<Object?> get props => [
    teamId,
    channels,
    categories,
    unreadCounts,
    selectedChannel,
    userId,
    members,
  ];
}

class ChannelErrorState extends ChannelState {
  final String message;
  const ChannelErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository _channelRepository;
  final WebSocketClientManager _webSocketManager;
  StreamSubscription? _wsSubscription;

  ChannelBloc(this._channelRepository, this._webSocketManager)
    : super(ChannelInitialState()) {
    on<LoadChannelsForTeamEvent>(_onLoadChannels);
    on<SelectChannelEvent>(_onSelectChannel);
    on<UpsertChannelEvent>(_onUpsertChannel);
    on<CreateChannelEvent>(_onCreateChannel);
    on<RealtimeChannelChangedEvent>(_onRealtimeChannelChanged);
    on<UpdateChannelEvent>(_onUpdateChannel);
    on<ArchiveChannelEvent>(_onArchiveChannel);
    on<UpdateUnreadCountsEvent>(_onRefreshUnread);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<MoveChannelToCategoryEvent>(_onMoveChannelToCategory);
    on<RenameCategoryEvent>(_onRenameCategory);
    on<ToggleMuteCategoryEvent>(_onToggleMuteCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<LeaveChannelEvent>(_onLeaveChannel);

    _wsSubscription = _webSocketManager.eventStream.listen((event) {
      if (event is ChannelUpdatedEvent) {
        add(RealtimeChannelChangedEvent());
      }
    });
  }

  Future<void> _onLoadChannels(
    LoadChannelsForTeamEvent event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoadingState());
    try {
      // العملية الأساسية: GetChannelsForTeamForUser — تجلب كل قنوات المستخدم
      // في الفريق (عامة/خاصة/DM/GM) ليعمل قسم DM في الشريط الجانبي.
      var channels = <ChannelEntity>[];
      try {
        channels = await _channelRepository.getMyChannels(event.teamId);
      } catch (_) {
        // بعض الخوادم لا تفعّل هذا المسار — نعود للقنوات العامة فقط.
        channels = await _channelRepository.getChannelsForTeam(event.teamId);
      }

      var categories = <ChannelCategoryEntity>[];
      if (event.userId != null) {
        try {
          categories = await _channelRepository.getChannelCategories(
            event.teamId,
            event.userId!,
          );
        } catch (_) {
          // بعض الخوادم لا تدعم الفئات — تُبنى فئات افتراضية في الواجهة.
        }
      }

      final unread = await _fetchUnread(event.teamId, channels);
      mergeUnreadCache(unread);

      var userId = event.userId ?? '';
      var members = <String, ChannelMemberEntity>{};
      try {
        final memberList = await _channelRepository.getMyChannelMembersInTeam(
          event.teamId,
        );
        members = {for (final m in memberList) m.channelId: m};
        if (userId.isEmpty && memberList.isNotEmpty) {
          userId = memberList.first.userId;
        }
      } catch (_) {
        // بعض الخوادم لا تعيد الأعضاء — تُترك الخريطة فارغة.
      }

      emit(
        ChannelsLoadedState(
          teamId: event.teamId,
          channels: channels,
          categories: categories,
          unreadCounts: unread,
          selectedChannel: channels.isNotEmpty ? channels.first : null,
          userId: userId,
          members: members,
        ),
      );
    } catch (e) {
      emit(ChannelErrorState(e.toString()));
    }
  }

  Future<Map<String, ChannelUnreadCounts>> _fetchUnread(
    String teamId,
    List<ChannelEntity> channels,
  ) async {
    try {
      return await _channelRepository.getUnreadCountsForTeam(
        teamId,
        channels: channels,
      );
    } catch (_) {
      return Map.of(unreadCache);
    }
  }

  void _onSelectChannel(SelectChannelEvent event, Emitter<ChannelState> emit) {
    final current = state;
    if (current is ChannelsLoadedState &&
        current.selectedChannel?.id != event.channel.id) {
      emit(
        ChannelsLoadedState(
          teamId: current.teamId,
          channels: current.channels,
          categories: current.categories,
          unreadCounts: current.unreadCounts,
          selectedChannel: event.channel,
          userId: current.userId,
          members: current.members,
        ),
      );
    }
  }

  // إدراج قناة DM/GM جديدة في القائمة، أو تحديثها مكانها إن كانت موجودة.
  void _onUpsertChannel(UpsertChannelEvent event, Emitter<ChannelState> emit) {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final exists = current.channels.any((c) => c.id == event.channel.id);
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: exists
            ? current.channels
                  .map((c) => c.id == event.channel.id ? event.channel : c)
                  .toList()
            : [...current.channels, event.channel],
        categories: current.categories,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel?.id == event.channel.id
            ? event.channel
            : current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
  }

  Future<void> _onCreateChannel(
    CreateChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    try {
      final channel = await _channelRepository.createChannel(
        teamId: event.teamId,
        displayName: event.displayName,
        name: event.name,
        type: event.type,
        purpose: event.purpose,
      );

      if (event.newCategoryName != null) {
        try {
          await _channelRepository.createChannelCategory(
            event.userId,
            event.teamId,
            displayName: event.newCategoryName,
            channelIds: [channel.id],
          );
        } catch (_) {
          // فشل إلحاق الفئة الجديدة لا يُفشل إنشاء القناة.
        }
      } else if (event.categoryId != null) {
        try {
          final categories = await _channelRepository.getChannelCategories(
            event.teamId,
            event.userId,
          );
          final updated = categories
              .map(
                (c) => c.id == event.categoryId
                    ? c.copyWith(channelIds: [...c.channelIds, channel.id])
                    : c,
              )
              .toList();
          await _channelRepository.updateChannelCategories(
            event.teamId,
            event.userId,
            updated,
          );
        } catch (_) {}
      }

      final current = state;
      if (current is ChannelsLoadedState) {
        final channels = await _channelRepository.getChannelsForTeam(
          event.teamId,
        );
        final unread = await _fetchUnread(event.teamId, channels);
        mergeUnreadCache(unread);
        emit(
          ChannelsLoadedState(
            teamId: event.teamId,
            channels: channels,
            categories: current.categories,
            unreadCounts: unread,
            selectedChannel: channel,
            userId: current.userId,
            members: current.members,
          ),
        );
      }
    } catch (e) {
      emit(ChannelErrorState(e.toString()));
    }
  }

  Future<void> _onRealtimeChannelChanged(
    RealtimeChannelChangedEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is ChannelsLoadedState) {
      final teamId = current.selectedChannel?.teamId ?? current.teamId;
      if (teamId.isEmpty) return;
      try {
        final channels = await _channelRepository.getChannelsForTeam(teamId);
        final unread = await _fetchUnread(teamId, channels);
        mergeUnreadCache(unread);
        final currentId = current.selectedChannel?.id;
        emit(
          ChannelsLoadedState(
            teamId: teamId,
            channels: channels,
            categories: current.categories,
            unreadCounts: unread,
            selectedChannel: currentId != null
                ? (channels.where((c) => c.id == currentId).firstOrNull ??
                      current.selectedChannel)
                : null,
            userId: current.userId,
            members: current.members,
          ),
        );
      } catch (_) {
        // إبقاء الحالة الحالية عند فشل التحديث اللحظي.
      }
    }
  }

  // تحديث القناة محلياً بعد نجاح التعديل (الاسم/الغرض/الرأس/الخصوصية).
  void _onUpdateChannel(UpdateChannelEvent event, Emitter<ChannelState> emit) {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels
            .map((c) => c.id == event.channel.id ? event.channel : c)
            .toList(),
        categories: current.categories,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel?.id == event.channel.id
            ? event.channel
            : current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
  }

  // أرشفة القناة: إزالة محلية فورية ثم DELETE /channels/{id} على الخادم.
  Future<void> _onArchiveChannel(
    ArchiveChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels
            .where((c) => c.id != event.channel.id)
            .toList(),
        categories: current.categories
            .map(
              (c) => c.copyWith(
                channelIds: c.channelIds
                    .where((id) => id != event.channel.id)
                    .toList(),
              ),
            )
            .toList(),
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel?.id == event.channel.id
            ? null
            : current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
    try {
      await _channelRepository.deleteChannel(event.channel.id);
    } catch (_) {
      // يبقى الحذف محلياً عند فشل الخادم.
    }
  }

  Future<void> _onRefreshUnread(
    UpdateUnreadCountsEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    try {
      final unread = await _channelRepository.getUnreadCountsForTeam(
        current.teamId,
        channels: current.channels,
      );
      mergeUnreadCache(unread);
      emit(
        ChannelsLoadedState(
          teamId: current.teamId,
          channels: current.channels,
          categories: current.categories,
          unreadCounts: unread,
          selectedChannel: current.selectedChannel,
          userId: current.userId,
          members: current.members,
        ),
      );
    } catch (_) {}
  }

  // كتم/إلغاء كتم القناة — يطابق mute_channel في webapp
  // (notify_props.mark_unread = 'mention' يعني أن المنشنات فقط تظهر كغير مقروءة).
  Future<void> _onToggleMute(
    ToggleMuteEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final member = current.members[event.channelId];
    final muted = member?.notifyProps['mark_unread'] == 'mention';
    try {
      await _channelRepository.updateChannel(
        event.channelId,
        notifyProps: {'mark_unread': muted ? 'all' : 'mention'},
      );
      final updatedMembers = Map<String, ChannelMemberEntity>.of(
        current.members,
      );
      if (member != null) {
        updatedMembers[event.channelId] = member.copyWith(
          notifyProps: {
            ...member.notifyProps,
            'mark_unread': muted ? 'all' : 'mention',
          },
        );
      }
      emit(
        ChannelsLoadedState(
          teamId: current.teamId,
          channels: current.channels,
          categories: current.categories,
          unreadCounts: current.unreadCounts,
          selectedChannel: current.selectedChannel,
          userId: current.userId,
          members: updatedMembers,
        ),
      );
    } catch (_) {
      // إبقاء الحالة الحالية عند فشل تحديث الكتم.
    }
  }

  // إضافة/إزالة قناة من فئة المفضلة في الشريط الجانبي.
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final favorites = current.categories
        .where((c) => c.type == ChannelCategoryType.favorites)
        .toList();
    var favoriteCategory = favorites.isEmpty ? null : favorites.first;

    // بعض الخوادم لا تُنشئ فئة المفضلة تلقائياً — تُنشأ عند أول تفعيل.
    if (favoriteCategory == null) {
      try {
        favoriteCategory = await _channelRepository.createChannelCategory(
          event.userId,
          event.teamId,
          displayName: 'Favorites',
          type: ChannelCategoryType.favorites.value,
          channelIds: [event.channelId],
        );
        emit(
          ChannelsLoadedState(
            teamId: current.teamId,
            channels: current.channels,
            categories: [...current.categories, favoriteCategory],
            unreadCounts: current.unreadCounts,
            selectedChannel: current.selectedChannel,
            userId: current.userId,
            members: current.members,
          ),
        );
        return;
      } catch (_) {
        // فشل إنشاء الفئة — بدون تغيير.
        return;
      }
    }
    // بعد هذا الفرع (يرجع دائماً عند غياب الفئة) تصبح الفئة مؤكدة الوجود.
    final favoritesCategory = favoriteCategory;
    final isFavorited = favoritesCategory.channelIds.contains(event.channelId);
    final updatedCategories = current.categories
        .map(
          (c) => c.id == favoritesCategory.id
              ? c.copyWith(
                  channelIds: isFavorited
                      ? c.channelIds
                            .where((id) => id != event.channelId)
                            .toList()
                      : [...c.channelIds, event.channelId],
                )
              : c,
        )
        .toList();
    try {
      await _channelRepository.updateChannelCategories(
        event.teamId,
        event.userId,
        updatedCategories,
      );
      emit(
        ChannelsLoadedState(
          teamId: current.teamId,
          channels: current.channels,
          categories: updatedCategories,
          unreadCounts: current.unreadCounts,
          selectedChannel: current.selectedChannel,
          userId: current.userId,
          members: current.members,
        ),
      );
    } catch (_) {
      // إبقاء الحالة الحالية عند فشل تحديث المفضلة.
    }
  }

  // نقل قناة بين الفئات بعد سحب وإفلات في الشريط الجانبي.
  Future<void> _onMoveChannelToCategory(
    MoveChannelToCategoryEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;

    final updatedCategories = current.categories
        .map(
          (c) => c.copyWith(
            channelIds: c.id == event.targetCategoryId
                ? [...c.channelIds.where((id) => id != event.channelId),
                    event.channelId]
                : c.channelIds
                      .where((id) => id != event.channelId)
                      .toList(),
          ),
        )
        .toList();

    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels,
        categories: updatedCategories,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );

    try {
      await _channelRepository.updateChannelCategories(
        event.teamId,
        event.userId,
        updatedCategories,
      );
    } catch (_) {
      // يبقى التغيير محلياً عند فشل الحفظ — لا حاجة للتراجع الفوري.
    }
  }

  // إعادة تسمية فئة: تحديث محلي فوري ثم حفظ على الخادم.
  Future<void> _onRenameCategory(
    RenameCategoryEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final updated = current.categories
        .map(
          (c) => c.id == event.categoryId
              ? c.copyWith(displayName: event.newName)
              : c,
        )
        .toList();
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels,
        categories: updated,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
    try {
      await _channelRepository.updateChannelCategory(
        event.userId,
        event.teamId,
        event.categoryId,
        displayName: event.newName,
      );
    } catch (_) {
      // يبقى الاسم الجديد محلياً عند فشل الحفظ.
    }
  }

  // كتم/إلغاء كتم فئة — يطابق MuteCategory/UnmuteCategory في webapp.
  Future<void> _onToggleMuteCategory(
    ToggleMuteCategoryEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final updated = current.categories
        .map(
          (c) => c.id == event.categoryId
              ? c.copyWith(muted: event.muted)
              : c,
        )
        .toList();
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels,
        categories: updated,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
    try {
      await _channelRepository.updateChannelCategory(
        event.userId,
        event.teamId,
        event.categoryId,
        muted: event.muted,
      );
    } catch (_) {
      // يبقى الكتم جديد محلياً عند فشل الحفظ.
    }
  }

  // حذف فئة: قنواتها تنتقل لأول فئة متبقية (سلوك webapp)، ثم DELETE على الخادم.
  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    final removed = current.categories
        .where((c) => c.id == event.categoryId)
        .firstOrNull;
    if (removed == null) return;

    final remaining = current.categories
        .where((c) => c.id != event.categoryId)
        .toList();
    var updated = remaining;
    final target = remaining.firstOrNull;
    if (target != null && removed.channelIds.isNotEmpty) {
      updated = remaining
          .map(
            (c) => c.id == target.id
                ? c.copyWith(channelIds: [...c.channelIds, ...removed.channelIds])
                : c,
          )
          .toList();
    }

    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels,
        categories: updated,
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel,
        userId: current.userId,
        members: current.members,
      ),
    );
    try {
      await _channelRepository.deleteChannelCategory(
        event.userId,
        event.teamId,
        event.categoryId,
      );
    } catch (_) {
      // يبقى الحذف محلياً عند فشل الخادم.
    }
  }

  // إنشاء فئة جديدة وإلحاقها نهاية القائمة.
  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    try {
      final created = await _channelRepository.createChannelCategory(
        event.userId,
        event.teamId,
        displayName: event.displayName,
        channelIds: event.channelIds,
      );
      emit(
        ChannelsLoadedState(
          teamId: current.teamId,
          channels: current.channels,
          categories: [...current.categories, created],
          unreadCounts: current.unreadCounts,
          selectedChannel: current.selectedChannel,
          userId: current.userId,
          members: current.members,
        ),
      );
    } catch (_) {
      // لا تغيير عند فشل الإنشاء.
    }
  }

  // مغادرة قناة/إلغاء تفعيل DM: إزالة من القوائم والفئات والاختيار، ثم DELETE.
  Future<void> _onLeaveChannel(
    LeaveChannelEvent event,
    Emitter<ChannelState> emit,
  ) async {
    final current = state;
    if (current is! ChannelsLoadedState) return;
    emit(
      ChannelsLoadedState(
        teamId: current.teamId,
        channels: current.channels
            .where((c) => c.id != event.channelId)
            .toList(),
        categories: current.categories
            .map(
              (c) => c.copyWith(
                channelIds: c.channelIds
                    .where((id) => id != event.channelId)
                    .toList(),
              ),
            )
            .toList(),
        unreadCounts: current.unreadCounts,
        selectedChannel: current.selectedChannel?.id == event.channelId
            ? null
            : current.selectedChannel,
        userId: current.userId,
        members: Map<String, ChannelMemberEntity>.of(current.members)
          ..remove(event.channelId),
      ),
    );
    try {
      await _channelRepository.leaveChannel(
        event.channelId,
        event.userId,
      );
    } catch (_) {
      // يبقى الحذف محلياً عند فشل الخادم.
    }
  }

  // ذاكرة مؤقتة لعناصر غير المقروءة بين عمليات إعادة التحميل.
  static final Map<String, ChannelUnreadCounts> unreadCache = {};

  static void mergeUnreadCache(Map<String, ChannelUnreadCounts> unread) {
    if (unread.isNotEmpty) {
      unreadCache
        ..clear()
        ..addAll(unread);
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }
}
