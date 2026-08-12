import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/bot_account_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/bots_repository.dart';

// Events
abstract class BotsEvent extends Equatable {
  const BotsEvent();
  @override
  List<Object?> get props => [];
}

class LoadBotsEvent extends BotsEvent {}

class CreateBotEvent extends BotsEvent {
  final String username;
  final String displayName;
  final String description;
  const CreateBotEvent({
    required this.username,
    this.displayName = '',
    this.description = '',
  });
  @override
  List<Object?> get props => [username, displayName, description];
}

class UpdateBotEvent extends BotsEvent {
  final String botUserId;
  final String displayName;
  final String description;
  const UpdateBotEvent({
    required this.botUserId,
    required this.displayName,
    required this.description,
  });
  @override
  List<Object?> get props => [botUserId, displayName, description];
}

class DeleteBotEvent extends BotsEvent {
  final String botUserId;
  const DeleteBotEvent(this.botUserId);
  @override
  List<Object?> get props => [botUserId];
}

class EnableBotEvent extends BotsEvent {
  final String botUserId;
  const EnableBotEvent(this.botUserId);
  @override
  List<Object?> get props => [botUserId];
}

class DisableBotEvent extends BotsEvent {
  final String botUserId;
  const DisableBotEvent(this.botUserId);
  @override
  List<Object?> get props => [botUserId];
}

// States
abstract class BotsState extends Equatable {
  const BotsState();
  @override
  List<Object?> get props => [];
}

class BotsInitialState extends BotsState {}

class BotsLoadingState extends BotsState {}

class BotsLoadedState extends BotsState {
  final List<BotAccountEntity> bots;
  const BotsLoadedState(this.bots);
  @override
  List<Object?> get props => [bots];
}

class BotsErrorState extends BotsState {
  final String message;
  const BotsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class BotsBloc extends Bloc<BotsEvent, BotsState> {
  final BotsRepository _botsRepository;

  BotsBloc(this._botsRepository) : super(BotsInitialState()) {
    on<LoadBotsEvent>(_onLoad);
    on<CreateBotEvent>(_onCreate);
    on<UpdateBotEvent>(_onUpdate);
    on<DeleteBotEvent>(_onDelete);
    on<EnableBotEvent>(_onEnable);
    on<DisableBotEvent>(_onDisable);
  }

  Future<void> _onLoad(LoadBotsEvent event, Emitter<BotsState> emit) async {
    emit(BotsLoadingState());
    try {
      final bots = await _botsRepository.getBots();
      emit(BotsLoadedState(bots));
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(CreateBotEvent event, Emitter<BotsState> emit) async {
    emit(BotsLoadingState());
    try {
      await _botsRepository.createBot(
        username: event.username,
        displayName: event.displayName,
        description: event.description,
      );
      final bots = await _botsRepository.getBots();
      emit(BotsLoadedState(bots));
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateBotEvent event, Emitter<BotsState> emit) async {
    emit(BotsLoadingState());
    try {
      await _botsRepository.updateBot(
        event.botUserId,
        displayName: event.displayName,
        description: event.description,
      );
      final bots = await _botsRepository.getBots();
      emit(BotsLoadedState(bots));
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteBotEvent event, Emitter<BotsState> emit) async {
    try {
      await _botsRepository.deleteBot(event.botUserId);
      if (state is BotsLoadedState) {
        final current = (state as BotsLoadedState).bots;
        emit(
          BotsLoadedState(
            current.where((b) => b.userId != event.botUserId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  Future<void> _onEnable(EnableBotEvent event, Emitter<BotsState> emit) async {
    try {
      await _botsRepository.enableBot(event.botUserId);
      if (state is BotsLoadedState) {
        final current = (state as BotsLoadedState).bots;
        emit(BotsLoadedState(current.map(_rebuildWithUpdatedStatus).toList()));
      }
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  Future<void> _onDisable(
    DisableBotEvent event,
    Emitter<BotsState> emit,
  ) async {
    try {
      await _botsRepository.disableBot(event.botUserId);
      if (state is BotsLoadedState) {
        final current = (state as BotsLoadedState).bots;
        emit(BotsLoadedState(current.map(_rebuildWithUpdatedStatus).toList()));
      }
    } catch (e) {
      emit(BotsErrorState(e.toString()));
    }
  }

  BotAccountEntity _rebuildWithUpdatedStatus(BotAccountEntity bot) => bot.copyWith(
    isDeleted: !bot.isDeleted,
  );
}
