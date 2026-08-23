import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';

abstract class ThreadsSummaryState extends Equatable {
  const ThreadsSummaryState();
  @override
  List<Object?> get props => [];
}

class ThreadsSummaryInitialState extends ThreadsSummaryState {}

class ThreadsSummaryLoadingState extends ThreadsSummaryState {}

class ThreadsSummaryLoadedState extends ThreadsSummaryState {
  final String teamId;
  final Map<String, dynamic> summary;

  const ThreadsSummaryLoadedState({
    required this.teamId,
    required this.summary,
  });

  int get totalUnreadThreads => (summary['total_unread_threads'] as int?) ?? 0;
  int get totalUnreadMentions => (summary['total_unread_mentions'] as int?) ?? 0;

  @override
  List<Object?> get props => [teamId, summary];
}

class ThreadsSummaryErrorState extends ThreadsSummaryState {
  final String message;
  const ThreadsSummaryErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class ThreadsSummaryCubit extends Cubit<ThreadsSummaryState> {
  final ThreadsRemoteDataSource _threadsRemoteDataSource;

  ThreadsSummaryCubit(this._threadsRemoteDataSource)
      : super(ThreadsSummaryInitialState());

  Future<void> loadThreadsSummaryForTeam(String teamId) async {
    emit(ThreadsSummaryLoadingState());
    try {
      final summary = await _threadsRemoteDataSource.getThreadsForUser(
        teamId,
        totalsOnly: true,
      );
      emit(ThreadsSummaryLoadedState(teamId: teamId, summary: summary));
    } catch (e) {
      emit(ThreadsSummaryErrorState(e.toString()));
    }
  }

  void updateSummaryLocally(String teamId, Map<String, dynamic> summary) {
    emit(ThreadsSummaryLoadedState(teamId: teamId, summary: summary));
  }

  void clear() {
    emit(ThreadsSummaryInitialState());
  }
}
