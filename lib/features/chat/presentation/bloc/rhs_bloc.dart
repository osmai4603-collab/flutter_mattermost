import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';

/// لوحات RHS المطابقة لـ RHSStates في utils/constants.tsx (webapp).
enum RhsPanel {
  thread,
  search,
  mention,
  pinned,
  flagged,
  channelFiles,
  channelInfo,
  channelMembers,
  editHistory,
  plugin,
}

/// هل تُعرض اللوحة داخل RHS قابلة للتوسيع (overlay)؟
extension RhsPanelExpansion on RhsPanel {
  bool get expands =>
      this != RhsPanel.channelInfo && this != RhsPanel.channelMembers;
}

// Events
abstract class RhsEvent extends Equatable {
  const RhsEvent();
  @override
  List<Object?> get props => [];
}

class OpenThreadEvent extends RhsEvent {
  final String rootPostId;
  final String channelId;
  const OpenThreadEvent(this.rootPostId, this.channelId);
  @override
  List<Object?> get props => [rootPostId, channelId];
}

class CloseRhsEvent extends RhsEvent {}

/// فتح سجل تعديلات رسالة في RHS — مطابق فتح post edit history في webapp.
class OpenEditHistoryEvent extends RhsEvent {
  final String postId;
  const OpenEditHistoryEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class SendThreadPostEvent extends RhsEvent {
  final String channelId;
  final String rootPostId;
  final String message;
  final List<String> fileIds;
  final Map<String, dynamic>? metadata;
  final Completer<PostEntity>? completer;

  const SendThreadPostEvent({
    required this.channelId,
    required this.rootPostId,
    required this.message,
    this.fileIds = const [],
    this.metadata,
    this.completer,
  });

  @override
  List<Object?> get props => [channelId, rootPostId, message, fileIds, metadata];
}

class ThreadRealtimeUpdatedEvent extends RhsEvent {
  final PostEntity post;
  const ThreadRealtimeUpdatedEvent(this.post);
  @override
  List<Object?> get props => [post];
}

class ThreadRealtimeDeletedEvent extends RhsEvent {
  final String postId;
  const ThreadRealtimeDeletedEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class ShowMentionsEvent extends RhsEvent {}

class ShowFlaggedPostsEvent extends RhsEvent {}

class ShowPinnedPostsEvent extends RhsEvent {}

class ShowChannelFilesEvent extends RhsEvent {}

class ShowChannelInfoEvent extends RhsEvent {}

class ShowChannelMembersEvent extends RhsEvent {}

class ShowSearchResultsEvent extends RhsEvent {
  final String terms;
  const ShowSearchResultsEvent([this.terms = '']);
  @override
  List<Object?> get props => [terms];
}

class UpdateRhsSearchTermsEvent extends RhsEvent {
  final String terms;
  const UpdateRhsSearchTermsEvent(this.terms);
  @override
  List<Object?> get props => [terms];
}

class GoBackRhsEvent extends RhsEvent {}

class ToggleRhsExpandedEvent extends RhsEvent {}

class CollapseRhsExpandedEvent extends RhsEvent {}

// States
abstract class RhsState extends Equatable {
  const RhsState();
  @override
  List<Object?> get props => [];
}

class RhsClosedState extends RhsState {}

/// حالة مشتركة لكل اللوحات المفتوحة.
abstract class RhsPanelState extends RhsState {
  const RhsPanelState();

  RhsPanel get panel;
  bool get isExpanded;
}

class RhsThreadState extends RhsPanelState {
  final String rootPostId;
  final String channelId;
  final PostEntity? rootPost;
  final List<PostEntity> replies;
  final bool loading;
  final bool sending;
  final bool isExpanded;

  const RhsThreadState({
    required this.rootPostId,
    required this.channelId,
    this.rootPost,
    this.replies = const [],
    this.loading = false,
    this.sending = false,
    this.isExpanded = false,
  });

  @override
  RhsPanel get panel => RhsPanel.thread;

  RhsThreadState copyWith({
    PostEntity? rootPost,
    List<PostEntity>? replies,
    bool? loading,
    bool? sending,
    bool? isExpanded,
  }) => RhsThreadState(
    rootPostId: rootPostId,
    channelId: channelId,
    rootPost: rootPost ?? this.rootPost,
    replies: replies ?? this.replies,
    loading: loading ?? this.loading,
    sending: sending ?? this.sending,
    isExpanded: isExpanded ?? this.isExpanded,
  );

  @override
  List<Object?> get props => [
    rootPostId,
    channelId,
    rootPost,
    replies,
    loading,
    sending,
    isExpanded,
  ];
}

/// حالة سجل تعديلات رسالة في RHS — مطابق لوحة edit history في webapp.
class RhsEditHistoryState extends RhsPanelState {
  final String postId;
  final List<PostEntity> versions;
  final bool loading;
  @override
  final bool isExpanded;

  const RhsEditHistoryState({
    required this.postId,
    this.versions = const [],
    this.loading = false,
    this.isExpanded = false,
  });

  @override
  RhsPanel get panel => RhsPanel.editHistory;

  RhsEditHistoryState copyWith({
    List<PostEntity>? versions,
    bool? loading,
    bool? isExpanded,
  }) => RhsEditHistoryState(
    postId: postId,
    versions: versions ?? this.versions,
    loading: loading ?? this.loading,
    isExpanded: isExpanded ?? this.isExpanded,
  );

  @override
  List<Object?> get props => [postId, versions, loading, isExpanded];
}

/// حالة بحث/قوائم (mentions, flagged, pinned, files, search).
class RhsListState extends RhsPanelState {
  final RhsPanel panel;
  final String folderName;
  final String searchTerms;
  final bool loading;
  final bool isExpanded;

  const RhsListState({
    required this.panel,
    this.folderName = '',
    this.searchTerms = '',
    this.loading = false,
    this.isExpanded = false,
  });

  RhsListState copyWith({
    String? folderName,
    String? searchTerms,
    bool? loading,
    bool? isExpanded,
  }) => RhsListState(
    panel: panel,
    folderName: folderName ?? this.folderName,
    searchTerms: searchTerms ?? this.searchTerms,
    loading: loading ?? this.loading,
    isExpanded: isExpanded ?? this.isExpanded,
  );

  @override
  List<Object?> get props => [
    panel,
    folderName,
    searchTerms,
    loading,
    isExpanded,
  ];
}

/// لوحات معلومات القناة والأعضاء.
class RhsChannelState extends RhsPanelState {
  final RhsPanel panel;
  final String channelId;
  final bool isExpanded;

  const RhsChannelState({
    required this.panel,
    required this.channelId,
    this.isExpanded = false,
  });

  @override
  List<Object?> get props => [panel, channelId, isExpanded];
}

@LazySingleton()
class RhsBloc extends Bloc<RhsEvent, RhsState> {
  final PostRepository _postRepository;
  final ChannelBloc _channelBloc;

  /// سجل اللوحات السابقة (previousRhsStates في webapp) للزر رجوع.
  final List<RhsPanel> _previousPanels = [];

  /// هل توجد لوحة سابقة للرجوع إليها (يعرض زر الرجوع في رأس RHS)؟
  bool get hasPreviousPanels => _previousPanels.isNotEmpty;

  RhsBloc(this._postRepository, this._channelBloc) : super(RhsClosedState()) {
    on<OpenThreadEvent>(_onOpenThread);
    on<OpenEditHistoryEvent>(_onOpenEditHistory);
    on<CloseRhsEvent>(_onClose);
    on<SendThreadPostEvent>(_onSendThreadPost);
    on<ThreadRealtimeUpdatedEvent>(_onRealtimeUpdated);
    on<ShowMentionsEvent>(_showMentions);
    on<ShowFlaggedPostsEvent>(_showFlagged);
    on<ShowPinnedPostsEvent>(_showPinned);
    on<ShowChannelFilesEvent>(_showChannelFiles);
    on<ShowChannelInfoEvent>(_showChannelInfo);
    on<ShowChannelMembersEvent>(_showChannelMembers);
    on<ShowSearchResultsEvent>(_showSearch);
    on<UpdateRhsSearchTermsEvent>(_onUpdateTerms);
    on<GoBackRhsEvent>(_onGoBack);
    on<ToggleRhsExpandedEvent>(_onToggleExpanded);
    on<CollapseRhsExpandedEvent>(_onCollapseExpanded);

    _channelBloc.stream.listen((channelState) {
      if (state is RhsThreadState &&
          channelState is ChannelsLoadedState &&
          channelState.selectedChannel?.id !=
              (state as RhsThreadState).channelId) {
        add(CloseRhsEvent());
      }
    });
    on<ThreadRealtimeDeletedEvent>(_onRealtimeDeleted);
  }

  /// يستدعي previous state قبل فتح لوحة جديدة (كما webapp updateRhsState).
  void _pushPrevious(RhsPanel nextPanel) {
    final current = state;
    if (current is RhsPanelState && current.panel != nextPanel) {
      if (_previousPanels.isEmpty || _previousPanels.last != current.panel) {
        _previousPanels.add(current.panel);
      }
    } else if (current is! RhsPanelState) {
      _previousPanels.clear();
    }
  }

  Future<void> _onOpenThread(
    OpenThreadEvent event,
    Emitter<RhsState> emit,
  ) async {
    _pushPrevious(RhsPanel.thread);
    emit(
      RhsThreadState(
        rootPostId: event.rootPostId,
        channelId: event.channelId,
        loading: true,
      ),
    );
    try {
      final thread = await _postRepository.getPostThread(event.rootPostId);
      final rootPost = state is RhsThreadState
          ? ((state as RhsThreadState).rootPost ??
                thread.where((p) => p.id == event.rootPostId).firstOrNull)
          : null;
      emit(
        RhsThreadState(
          rootPostId: event.rootPostId,
          channelId: event.channelId,
          rootPost: rootPost,
          replies: thread.where((p) => p.id != event.rootPostId).toList(),
        ),
      );
    } catch (_) {
      if (state is RhsThreadState) {
        emit((state as RhsThreadState).copyWith(loading: false));
      }
    }
  }

  void _onClose(CloseRhsEvent event, Emitter<RhsState> emit) {
    _previousPanels.clear();
    emit(RhsClosedState());
  }

  /// يُستدعى من زر "Edited" أسفل الرسالة — يفتح سجل النسخ في RHS.
  Future<void> _onOpenEditHistory(
    OpenEditHistoryEvent event,
    Emitter<RhsState> emit,
  ) async {
    _pushPrevious(RhsPanel.editHistory);
    emit(RhsEditHistoryState(postId: event.postId, loading: true));
    try {
      final versions = await _postRepository.getPostEditHistory(event.postId);
      emit(RhsEditHistoryState(postId: event.postId, versions: versions));
    } catch (_) {
      if (state is RhsEditHistoryState) {
        emit((state as RhsEditHistoryState).copyWith(loading: false));
      }
    }
  }

  void _showMentions(ShowMentionsEvent event, Emitter<RhsState> emit) {
    _pushPrevious(RhsPanel.mention);
    emit(RhsListState(panel: RhsPanel.mention, folderName: 'mentions'));
  }

  void _showFlagged(ShowFlaggedPostsEvent event, Emitter<RhsState> emit) {
    _pushPrevious(RhsPanel.flagged);
    emit(RhsListState(panel: RhsPanel.flagged, folderName: 'flagged'));
  }

  void _showPinned(ShowPinnedPostsEvent event, Emitter<RhsState> emit) {
    if (_currentChannelId() == null) return;
    _pushPrevious(RhsPanel.pinned);
    emit(RhsListState(panel: RhsPanel.pinned, folderName: 'pinned'));
  }

  void _showChannelFiles(ShowChannelFilesEvent event, Emitter<RhsState> emit) {
    if (_currentChannelId() == null) return;
    _pushPrevious(RhsPanel.channelFiles);
    emit(RhsListState(panel: RhsPanel.channelFiles, folderName: 'files'));
  }

  void _showChannelInfo(ShowChannelInfoEvent event, Emitter<RhsState> emit) {
    final channelId = _currentChannelId();
    if (channelId == null) return;
    _pushPrevious(RhsPanel.channelInfo);
    emit(RhsChannelState(panel: RhsPanel.channelInfo, channelId: channelId));
  }

  void _showChannelMembers(
    ShowChannelMembersEvent event,
    Emitter<RhsState> emit,
  ) {
    final channelId = _currentChannelId();
    if (channelId == null) return;
    _pushPrevious(RhsPanel.channelMembers);
    emit(RhsChannelState(panel: RhsPanel.channelMembers, channelId: channelId));
  }

  void _showSearch(ShowSearchResultsEvent event, Emitter<RhsState> emit) {
    _pushPrevious(RhsPanel.search);
    emit(RhsListState(panel: RhsPanel.search, searchTerms: event.terms));
  }

  void _onUpdateTerms(UpdateRhsSearchTermsEvent event, Emitter<RhsState> emit) {
    final current = state;
    if (current is RhsListState && current.panel == RhsPanel.search) {
      emit(current.copyWith(searchTerms: event.terms));
    }
  }

  void _onGoBack(GoBackRhsEvent event, Emitter<RhsState> emit) {
    final current = state;
    if (current is! RhsPanelState) return;
    if (_previousPanels.isNotEmpty) {
      final panel = _previousPanels.removeLast();
      emit(_stateForPanel(panel, current));
    } else {
      emit(RhsClosedState());
    }
  }

  RhsState _stateForPanel(RhsPanel panel, RhsPanelState previous) {
    switch (panel) {
      case RhsPanel.thread:
        return previous is RhsThreadState
            ? previous.copyWith(isExpanded: previous.isExpanded)
            : RhsClosedState();
      case RhsPanel.channelInfo:
        final channelId = _currentChannelId();
        if (channelId == null) return RhsClosedState();
        return RhsChannelState(panel: panel, channelId: channelId);
      case RhsPanel.channelMembers:
        final channelId = _currentChannelId();
        if (channelId == null) return RhsClosedState();
        return RhsChannelState(panel: panel, channelId: channelId);
      default:
        return RhsListState(
          panel: panel,
          folderName: panel.name,
          isExpanded: previous.isExpanded,
        );
    }
  }

  void _onToggleExpanded(ToggleRhsExpandedEvent event, Emitter<RhsState> emit) {
    final current = state;
    if (current is RhsThreadState) {
      emit(current.copyWith(isExpanded: !current.isExpanded));
    } else if (current is RhsListState) {
      emit(current.copyWith(isExpanded: !current.isExpanded));
    }
  }

  void _onCollapseExpanded(
    CollapseRhsExpandedEvent event,
    Emitter<RhsState> emit,
  ) {
    final current = state;
    if (current is RhsThreadState && current.isExpanded) {
      emit(current.copyWith(isExpanded: false));
    } else if (current is RhsListState && current.isExpanded) {
      emit(current.copyWith(isExpanded: false));
    }
  }

  String? _currentChannelId() {
    final channelState = _channelBloc.state;
    if (channelState is ChannelsLoadedState) {
      return channelState.selectedChannel?.id;
    }
    return null;
  }

  Future<void> _onSendThreadPost(
    SendThreadPostEvent event,
    Emitter<RhsState> emit,
  ) async {
    final current = state;
    if (current is! RhsThreadState) return;
    emit(current.copyWith(sending: true));
    try {
      final sent = await _postRepository.sendPost(
        event.channelId,
        event.message,
        rootId: event.rootPostId,
        fileIds: event.fileIds,
        metadata: event.metadata,
      );
      emit(
        current.copyWith(sending: false, replies: [...current.replies, sent]),
      );
      event.completer?.complete(sent);
    } catch (e) {
      emit(current.copyWith(sending: false));
      event.completer?.completeError(e);
    }
  }

  void _onRealtimeUpdated(
    ThreadRealtimeUpdatedEvent event,
    Emitter<RhsState> emit,
  ) {
    final current = state;
    if (current is! RhsThreadState ||
        event.post.channelId != current.channelId ||
        event.post.rootId != current.rootPostId) {
      return;
    }
    final exists = current.replies.any((r) => r.id == event.post.id);
    final replies = exists
        ? current.replies
              .map((r) => r.id == event.post.id ? event.post : r)
              .toList()
        : [...current.replies, event.post];
    emit(current.copyWith(replies: replies));
  }

  void _onRealtimeDeleted(
    ThreadRealtimeDeletedEvent event,
    Emitter<RhsState> emit,
  ) {
    final current = state;
    if (current is! RhsThreadState) return;
    if (current.rootPostId == event.postId) {
      // Root post deleted, close RHS
      add(CloseRhsEvent());
      return;
    }
    final replies = current.replies.where((r) => r.id != event.postId).toList();
    if (replies.length != current.replies.length) {
      emit(current.copyWith(replies: replies));
    }
  }
}
