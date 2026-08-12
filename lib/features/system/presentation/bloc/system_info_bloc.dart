import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/system/domain/entities/system_info_entity.dart';
import 'package:flutter_mattermost/features/system/domain/repositories/system_repository.dart';

// Events
abstract class SystemInfoEvent extends Equatable {
  const SystemInfoEvent();
  @override
  List<Object?> get props => [];
}

class LoadSystemInfoEvent extends SystemInfoEvent {}

// States
abstract class SystemInfoState extends Equatable {
  const SystemInfoState();
  @override
  List<Object?> get props => [];
}

class SystemInfoInitialState extends SystemInfoState {}

class SystemInfoLoadingState extends SystemInfoState {}

class SystemInfoLoadedState extends SystemInfoState {
  final SystemInfoEntity info;
  const SystemInfoLoadedState(this.info);
  @override
  List<Object?> get props => [info];
}

class SystemInfoErrorState extends SystemInfoState {
  final String message;
  const SystemInfoErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class SystemInfoBloc extends Bloc<SystemInfoEvent, SystemInfoState> {
  final SystemRepository _systemRepository;

  SystemInfoBloc(this._systemRepository) : super(SystemInfoInitialState()) {
    on<LoadSystemInfoEvent>(_onLoadSystemInfo);
  }

  Future<void> _onLoadSystemInfo(
    LoadSystemInfoEvent event,
    Emitter<SystemInfoState> emit,
  ) async {
    emit(SystemInfoLoadingState());
    try {
      final info = await _systemRepository.getSystemInfo();
      emit(SystemInfoLoadedState(info));
    } catch (e) {
      emit(SystemInfoErrorState(e.toString()));
    }
  }
}
