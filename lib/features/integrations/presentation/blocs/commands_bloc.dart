import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/commands/slash_commands_registry.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/command_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/commands_repository.dart';

// Events
abstract class CommandsEvent extends Equatable {
  const CommandsEvent();
  @override
  List<Object?> get props => [];
}

class LoadCommandsEvent extends CommandsEvent {
  final String teamId;
  const LoadCommandsEvent(this.teamId);
  @override
  List<Object?> get props => [teamId];
}

class CreateCommandEvent extends CommandsEvent {
  final String teamId;
  final String trigger;
  final String url;
  final String method;
  final String username;
  const CreateCommandEvent({
    required this.teamId,
    required this.trigger,
    required this.url,
    this.method = 'POST',
    this.username = '',
  });
  @override
  List<Object?> get props => [teamId, trigger, url, method, username];
}

class UpdateCommandEvent extends CommandsEvent {
  final String commandId;
  final String trigger;
  final String url;
  final String method;
  final String username;
  const UpdateCommandEvent({
    required this.commandId,
    required this.trigger,
    required this.url,
    required this.method,
    this.username = '',
  });
  @override
  List<Object?> get props => [commandId, trigger, url, method, username];
}

class DeleteCommandEvent extends CommandsEvent {
  final String commandId;
  const DeleteCommandEvent(this.commandId);
  @override
  List<Object?> get props => [commandId];
}

class ExecuteCommandEvent extends CommandsEvent {
  final String command;
  final String channelId;
  final String teamId;
  const ExecuteCommandEvent({
    required this.command,
    required this.channelId,
    required this.teamId,
  });
  @override
  List<Object?> get props => [command, channelId, teamId];
}

abstract class CommandsState extends Equatable {
  const CommandsState();
  @override
  List<Object?> get props => [];
}

class CommandsInitialState extends CommandsState {}

class CommandsLoadingState extends CommandsState {}

class CommandsLoadedState extends CommandsState {
  final List<CommandEntity> commands;
  const CommandsLoadedState(this.commands);
  @override
  List<Object?> get props => [commands];
}

class CommandExecutionState extends CommandsState {
  final Map<String, dynamic> result;
  const CommandExecutionState(this.result);
  @override
  List<Object?> get props => [result];
}

class CommandsErrorState extends CommandsState {
  final String message;
  const CommandsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class CommandsBloc extends Bloc<CommandsEvent, CommandsState> {
  final CommandsRepository _commandsRepository;
  String _teamId = '';

  CommandsBloc(this._commandsRepository) : super(CommandsInitialState()) {
    on<LoadCommandsEvent>(_onLoad);
    on<CreateCommandEvent>(_onCreate);
    on<UpdateCommandEvent>(_onUpdate);
    on<DeleteCommandEvent>(_onDelete);
    on<ExecuteCommandEvent>(_onExecute);
  }

  Future<void> _onLoad(
    LoadCommandsEvent event,
    Emitter<CommandsState> emit,
  ) async {
    _teamId = event.teamId;
    emit(CommandsLoadingState());
    try {
      final commands = await _commandsRepository.getCommands(event.teamId);
      emit(CommandsLoadedState(commands));
    } catch (e) {
      emit(CommandsErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    CreateCommandEvent event,
    Emitter<CommandsState> emit,
  ) async {
    emit(CommandsLoadingState());
    try {
      await _commandsRepository.createCommand(
        teamId: event.teamId,
        trigger: event.trigger,
        url: event.url,
        method: event.method,
        username: event.username,
      );
      final commands = await _commandsRepository.getCommands(event.teamId);
      emit(CommandsLoadedState(commands));
    } catch (e) {
      emit(CommandsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateCommandEvent event,
    Emitter<CommandsState> emit,
  ) async {
    emit(CommandsLoadingState());
    try {
      await _commandsRepository.updateCommand(
        event.commandId,
        trigger: event.trigger,
        url: event.url,
        method: event.method,
        username: event.username,
      );
      final commands = await _commandsRepository.getCommands(_teamId);
      emit(CommandsLoadedState(commands));
    } catch (e) {
      emit(CommandsErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteCommandEvent event,
    Emitter<CommandsState> emit,
  ) async {
    try {
      await _commandsRepository.deleteCommand(event.commandId);
      if (state is CommandsLoadedState) {
        final current = (state as CommandsLoadedState).commands;
        emit(
          CommandsLoadedState(
            current.where((c) => c.id != event.commandId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(CommandsErrorState(e.toString()));
    }
  }

  Future<void> _onExecute(
    ExecuteCommandEvent event,
    Emitter<CommandsState> emit,
  ) async {
    try {
      final result = await _commandsRepository.executeCommand(
        command: event.command,
        channelId: event.channelId,
        teamId: event.teamId,
      );
      emit(CommandExecutionState(result));
    } catch (e) {
      emit(CommandsErrorState(e.toString()));
    }
  }
}
