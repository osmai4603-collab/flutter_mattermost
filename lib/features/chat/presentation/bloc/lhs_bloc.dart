import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Events
abstract class LhsEvent extends Equatable {
  const LhsEvent();
  @override
  List<Object?> get props => [];
}

class ToggleLhsSearchEvent extends LhsEvent {
  final bool? active;
  const ToggleLhsSearchEvent({this.active});
  @override
  List<Object?> get props => [active];
}

class UpdateLhsSearchQueryEvent extends LhsEvent {
  final String query;
  const UpdateLhsSearchQueryEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class ClearLhsSearchEvent extends LhsEvent {}

class ToggleUnreadsOnlyEvent extends LhsEvent {}

class ToggleCategoryCollapsedEvent extends LhsEvent {
  final String categoryId;
  const ToggleCategoryCollapsedEvent(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class ExpandCategoryEvent extends LhsEvent {
  final String categoryId;
  const ExpandCategoryEvent(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class CollapseCategoryEvent extends LhsEvent {
  final String categoryId;
  const CollapseCategoryEvent(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

// States
abstract class LhsState extends Equatable {
  const LhsState();
  @override
  List<Object?> get props => [];
}

class LhsInitialState extends LhsState {}

class LhsSearchState extends LhsState {
  final bool searchActive;
  final String query;
  final bool unreadsOnly;

  /// معرّفات الفئات المطوية (sidebar_category collapse في webapp).
  final Set<String> collapsedCategories;

  const LhsSearchState({
    this.searchActive = false,
    this.query = '',
    this.unreadsOnly = false,
    this.collapsedCategories = const {},
  });

  LhsSearchState copyWith({
    bool? searchActive,
    String? query,
    bool? unreadsOnly,
    Set<String>? collapsedCategories,
  }) => LhsSearchState(
    searchActive: searchActive ?? this.searchActive,
    query: query ?? this.query,
    unreadsOnly: unreadsOnly ?? this.unreadsOnly,
    collapsedCategories: collapsedCategories ?? this.collapsedCategories,
  );

  @override
  List<Object?> get props => [
    searchActive,
    query,
    unreadsOnly,
    collapsedCategories,
  ];
}

@LazySingleton()
class LhsBloc extends Bloc<LhsEvent, LhsState> {
  // الحالة الابتدائية LhsSearchState مباشرة حتى لا تلجأ الواجهة إلى
  // fallback فارغ يخفي البحث/الطي عند أي حالة أخرى.
  LhsBloc() : super(const LhsSearchState()) {
    on<ToggleLhsSearchEvent>(_onToggleSearch);
    on<UpdateLhsSearchQueryEvent>(_onUpdateQuery);
    on<ClearLhsSearchEvent>(_onClear);
    on<ToggleUnreadsOnlyEvent>(_onToggleUnreads);
    on<ToggleCategoryCollapsedEvent>(_onToggleCategory);
    on<ExpandCategoryEvent>(_onExpandCategory);
    on<CollapseCategoryEvent>(_onCollapseCategory);
  }

  void _onToggleSearch(ToggleLhsSearchEvent event, Emitter<LhsState> emit) {
    if (state is! LhsSearchState) {
      emit(const LhsSearchState(searchActive: true));
    } else {
      final current = state as LhsSearchState;
      emit(
        current.copyWith(searchActive: event.active ?? !current.searchActive),
      );
    }
  }

  void _onUpdateQuery(UpdateLhsSearchQueryEvent event, Emitter<LhsState> emit) {
    if (state is LhsSearchState) {
      emit((state as LhsSearchState).copyWith(query: event.query.trim()));
    } else {
      emit(LhsSearchState(searchActive: true, query: event.query.trim()));
    }
  }

  void _onClear(ClearLhsSearchEvent event, Emitter<LhsState> emit) {
    emit(const LhsSearchState());
  }

  void _onToggleUnreads(ToggleUnreadsOnlyEvent event, Emitter<LhsState> emit) {
    if (state is LhsSearchState) {
      final current = state as LhsSearchState;
      emit(current.copyWith(unreadsOnly: !current.unreadsOnly));
    }
  }

  void _onToggleCategory(
    ToggleCategoryCollapsedEvent event,
    Emitter<LhsState> emit,
  ) {
    final collapsed = state is LhsSearchState
        ? (state as LhsSearchState).collapsedCategories
        : const <String>{};
    final next = {...collapsed};
    if (!next.remove(event.categoryId)) {
      next.add(event.categoryId);
    }
    emit(
      (state is LhsSearchState
              ? state as LhsSearchState
              : const LhsSearchState())
          .copyWith(collapsedCategories: next),
    );
  }

  void _onExpandCategory(ExpandCategoryEvent event, Emitter<LhsState> emit) {
    final collapsed = state is LhsSearchState
        ? (state as LhsSearchState).collapsedCategories
        : const <String>{};
    final next = {...collapsed}..remove(event.categoryId);
    emit(
      (state is LhsSearchState
              ? state as LhsSearchState
              : const LhsSearchState())
          .copyWith(collapsedCategories: next),
    );
  }

  void _onCollapseCategory(
    CollapseCategoryEvent event,
    Emitter<LhsState> emit,
  ) {
    final collapsed = state is LhsSearchState
        ? (state as LhsSearchState).collapsedCategories
        : const <String>{};
    final next = {...collapsed}..add(event.categoryId);
    emit(
      (state is LhsSearchState
              ? state as LhsSearchState
              : const LhsSearchState())
          .copyWith(collapsedCategories: next),
    );
  }
}
