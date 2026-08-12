import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/utils/timezone_offset.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';

/// نوع نتيجة البحث — مطابق SearchTypeSelector (All/Messages/Files) في webapp.
enum SearchResultType { messages, files }

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

/// تنفيذ بحث جديد (webapp performSearch — posts+files، per_page 20).
class PerformSearchEvent extends SearchEvent {
  final String terms;
  final String teamId;
  final SearchResultType type;
  const PerformSearchEvent({
    required this.terms,
    required this.teamId,
    this.type = SearchResultType.messages,
  });
  @override
  List<Object?> get props => [terms, teamId, type];
}

/// تغيير نوع النتائج (Messages ↔ Files) دون إعادة تنفيذ الطلب.
class ChangeSearchTypeEvent extends SearchEvent {
  final SearchResultType type;
  const ChangeSearchTypeEvent(this.type);
  @override
  List<Object?> get props => [type];
}

/// تحميل الصفحة التالية عند التمرير (webapp loadMorePosts/loadMoreFiles).
class LoadMoreSearchEvent extends SearchEvent {}

/// مسح حالة البحث عند إغلاق اللوحة.
class ClearSearchEvent extends SearchEvent {}

// States
abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {
  final String? terms;
  final String teamId;
  final SearchResultType type;
  const SearchLoadingState({this.terms, this.teamId = '', this.type = SearchResultType.messages});
  @override
  List<Object?> get props => [terms, teamId, type];
}

class SearchLoadedState extends SearchState {
  final String terms;
  final String teamId;
  final SearchResultType type;
  final List<PostEntity> posts;
  final List<FileInfoEntity> files;
  final int page;
  final bool hasMore;
  final bool loadingMore;
  final String? error;

  const SearchLoadedState({
    required this.terms,
    required this.teamId,
    required this.type,
    this.posts = const [],
    this.files = const [],
    this.page = 0,
    this.hasMore = false,
    this.loadingMore = false,
    this.error,
  });

  @override
  List<Object?> get props => [terms, teamId, type, posts, files, page, hasMore, loadingMore, error];
}

@LazySingleton()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostRemoteDataSource _postDataSource;
  final FilesRemoteDataSource _filesDataSource;

  static const int perPage = 20;
  static const int loadMoreBuffer = 30;

  SearchBloc(this._postDataSource, this._filesDataSource)
    : super(SearchInitialState()) {
    on<PerformSearchEvent>(_onPerformSearch);
    on<ChangeSearchTypeEvent>(_onChangeType);
    on<LoadMoreSearchEvent>(_onLoadMore);
    on<ClearSearchEvent>((event, emit) => emit(SearchInitialState()));
  }

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    final terms = event.terms.trim();
    emit(SearchLoadingState(terms: terms, teamId: event.teamId, type: event.type));
    if (terms.isEmpty) {
      emit(SearchInitialState());
      return;
    }

    if (event.type == SearchResultType.files) {
      await _searchFiles(event.teamId, terms, 0, emit);
    } else {
      await _searchPosts(event.teamId, terms, 0, emit);
    }
  }

  Future<void> _onChangeType(
    ChangeSearchTypeEvent event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    if (current is! SearchLoadedState && current is! SearchLoadingState) return;
    final terms = current is SearchLoadedState ? current.terms : (current as SearchLoadingState).terms ?? '';
    final teamId = current is SearchLoadedState ? current.teamId : (current as SearchLoadingState).teamId;
    if (terms.trim().isEmpty) {
      emit(SearchLoadedState(terms: '', teamId: teamId, type: event.type));
      return;
    }
    if (event.type == SearchResultType.files) {
      await _searchFiles(teamId, terms, 0, emit);
    } else {
      await _searchPosts(teamId, terms, 0, emit);
    }
  }

  Future<void> _onLoadMore(
    LoadMoreSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    if (current is! SearchLoadedState || current.loadingMore || !current.hasMore) {
      return;
    }
    emit(
      SearchLoadedState(
        terms: current.terms,
        teamId: current.teamId,
        type: current.type,
        posts: current.posts,
        files: current.files,
        page: current.page,
        hasMore: current.hasMore,
        loadingMore: true,
      ),
    );
    final nextPage = current.page + 1;
    if (current.type == SearchResultType.files) {
      await _searchFiles(current.teamId, current.terms, nextPage, emit);
    } else {
      await _searchPosts(current.teamId, current.terms, nextPage, emit);
    }
  }

  Future<void> _searchPosts(
    String teamId,
    String terms,
    int page,
    Emitter<SearchState> emit,
  ) async {
    final previous = state is SearchLoadedState ? state as SearchLoadedState : null;
    try {
      final dtos = await _postDataSource.searchPostsInTeam(teamId, {
        'terms': terms,
        'is_or_search': false,
        'include_deleted_channels': true,
        'time_zone_offset': TimeZoneOffset.deviceOffsetSeconds(),
        'page': page,
        'per_page': perPage,
      });
      final posts = dtos.map((dto) => dto.toEntity()).toList();
      final merged = page == 0
          ? posts
          : [...(previous?.posts ?? const <PostEntity>[]), ...posts];
      emit(
        SearchLoadedState(
          terms: terms,
          teamId: teamId,
          type: SearchResultType.messages,
          posts: merged,
          page: page,
          hasMore: posts.length >= perPage,
        ),
      );
    } catch (e) {
      emit(
        SearchLoadedState(
          terms: terms,
          teamId: teamId,
          type: SearchResultType.messages,
          posts: previous?.posts ?? const [],
          page: page,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _searchFiles(
    String teamId,
    String terms,
    int page,
    Emitter<SearchState> emit,
  ) async {
    final previous = state is SearchLoadedState ? state as SearchLoadedState : null;
    try {
      final files = await _filesDataSource.searchFilesInTeam(teamId, {
        'terms': terms,
        'is_or_search': false,
        'include_deleted_channels': true,
        'time_zone_offset': TimeZoneOffset.deviceOffsetSeconds(),
        'page': page,
        'per_page': perPage,
      });
      final entities = files.map((f) => f.toEntity()).toList();
      final merged = page == 0
          ? entities
          : [...(previous?.files ?? const <FileInfoEntity>[]), ...entities];
      emit(
        SearchLoadedState(
          terms: terms,
          teamId: teamId,
          type: SearchResultType.files,
          files: merged,
          page: page,
          hasMore: files.length >= perPage,
        ),
      );
    } catch (e) {
      emit(
        SearchLoadedState(
          terms: terms,
          teamId: teamId,
          type: SearchResultType.files,
          files: previous?.files ?? const [],
          page: page,
          error: e.toString(),
        ),
      );
    }
  }

  FileInfoEntity _toFileInfoEntity(Map<String, dynamic> json) {
    final dto = FileInfoModel.fromMap(json);
    return FileInfoEntity(
      serverId: '',
      id: dto.id,
      postId: dto.postId,
      userId: dto.userId,
      name: dto.name,
      extension: dto.extension,
      size: dto.size,
      mimeType: dto.mimeType,
      width: dto.width ?? 0,
      height: dto.height ?? 0,
    );
  }
}
