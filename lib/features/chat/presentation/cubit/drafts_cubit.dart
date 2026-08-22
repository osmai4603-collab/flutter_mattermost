import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/drafts_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';

abstract class DraftsState extends Equatable {
  const DraftsState();
  @override
  List<Object?> get props => [];
}

class DraftsInitialState extends DraftsState {}

class DraftsLoadingState extends DraftsState {}

class DraftsLoadedState extends DraftsState {
  final List<DraftModel> drafts;
  final String teamId;

  const DraftsLoadedState({required this.drafts, required this.teamId});

  @override
  List<Object?> get props => [drafts, teamId];
}

class DraftsErrorState extends DraftsState {
  final String message;
  const DraftsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class DraftsCubit extends Cubit<DraftsState> {
  final DraftsRemoteDataSource _draftsRemoteDataSource;

  DraftsCubit(this._draftsRemoteDataSource) : super(DraftsInitialState());

  Future<void> loadDraftsForTeam(String userId, String teamId) async {
    emit(DraftsLoadingState());
    try {
      final drafts = await _draftsRemoteDataSource.getDraftsForTeam(
        userId.isEmpty ? 'me' : userId,
        teamId,
      );
      emit(DraftsLoadedState(drafts: drafts, teamId: teamId));
    } catch (e) {
      emit(DraftsErrorState(e.toString()));
    }
  }

  void updateDraftsLocally(List<DraftModel> drafts, String teamId) {
    emit(DraftsLoadedState(drafts: drafts, teamId: teamId));
  }
}
