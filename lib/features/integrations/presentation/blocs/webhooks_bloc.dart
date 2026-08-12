import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_webhook_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/incoming_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/webhooks_repository.dart';

// Events
abstract class WebhooksEvent extends Equatable {
  const WebhooksEvent();
  @override
  List<Object?> get props => [];
}

class LoadIncomingWebhooksEvent extends WebhooksEvent {
  final String? teamId;
  const LoadIncomingWebhooksEvent({this.teamId});
}

class LoadOutgoingWebhooksEvent extends WebhooksEvent {
  final String? teamId;
  const LoadOutgoingWebhooksEvent({this.teamId});
}

class CreateIncomingWebhookEvent extends WebhooksEvent {
  final String channelId;
  final String displayName;
  const CreateIncomingWebhookEvent({
    required this.channelId,
    required this.displayName,
  });
  @override
  List<Object?> get props => [channelId, displayName];
}

class CreateOutgoingWebhookEvent extends WebhooksEvent {
  final String teamId;
  final String displayName;
  final List<String> callbackUrls;
  final List<String> triggerWords;
  const CreateOutgoingWebhookEvent({
    required this.teamId,
    required this.displayName,
    required this.callbackUrls,
    this.triggerWords = const [],
  });
  @override
  List<Object?> get props => [teamId, displayName, callbackUrls, triggerWords];
}

class UpdateIncomingWebhookEvent extends WebhooksEvent {
  final String hookId;
  final String channelId;
  final String displayName;
  const UpdateIncomingWebhookEvent({
    required this.hookId,
    required this.channelId,
    required this.displayName,
  });
  @override
  List<Object?> get props => [hookId, channelId, displayName];
}

class UpdateOutgoingWebhookEvent extends WebhooksEvent {
  final String hookId;
  final String displayName;
  final List<String> callbackUrls;
  final List<String> triggerWords;
  const UpdateOutgoingWebhookEvent({
    required this.hookId,
    required this.displayName,
    required this.callbackUrls,
    this.triggerWords = const [],
  });
  @override
  List<Object?> get props => [hookId, displayName, callbackUrls, triggerWords];
}

class DeleteIncomingWebhookEvent extends WebhooksEvent {
  final String hookId;
  const DeleteIncomingWebhookEvent(this.hookId);
  @override
  List<Object?> get props => [hookId];
}

class DeleteOutgoingWebhookEvent extends WebhooksEvent {
  final String hookId;
  const DeleteOutgoingWebhookEvent(this.hookId);
  @override
  List<Object?> get props => [hookId];
}

class RegenerateOutgoingWebhookTokenEvent extends WebhooksEvent {
  final String hookId;
  const RegenerateOutgoingWebhookTokenEvent(this.hookId);
  @override
  List<Object?> get props => [hookId];
}

// States
abstract class WebhooksState extends Equatable {
  const WebhooksState();
  @override
  List<Object?> get props => [];
}

class WebhooksInitialState extends WebhooksState {}

class WebhooksLoadingState extends WebhooksState {}

class IncomingWebhooksLoadedState extends WebhooksState {
  final List<IncomingWebhookEntity> webhooks;
  const IncomingWebhooksLoadedState(this.webhooks);
  @override
  List<Object?> get props => [webhooks];
}

class OutgoingWebhooksLoadedState extends WebhooksState {
  final List<OutgoingWebhookEntity> webhooks;
  const OutgoingWebhooksLoadedState(this.webhooks);
  @override
  List<Object?> get props => [webhooks];
}

class WebhooksErrorState extends WebhooksState {
  final String message;
  const WebhooksErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class WebhooksBloc extends Bloc<WebhooksEvent, WebhooksState> {
  final WebhooksRepository _webhooksRepository;

  WebhooksBloc(this._webhooksRepository) : super(WebhooksInitialState()) {
    on<LoadIncomingWebhooksEvent>(_onLoadIncoming);
    on<LoadOutgoingWebhooksEvent>(_onLoadOutgoing);
    on<CreateIncomingWebhookEvent>(_onCreateIncoming);
    on<CreateOutgoingWebhookEvent>(_onCreateOutgoing);
    on<UpdateIncomingWebhookEvent>(_onUpdateIncoming);
    on<UpdateOutgoingWebhookEvent>(_onUpdateOutgoing);
    on<DeleteIncomingWebhookEvent>(_onDeleteIncoming);
    on<DeleteOutgoingWebhookEvent>(_onDeleteOutgoing);
    on<RegenerateOutgoingWebhookTokenEvent>(_onRegenerateToken);
  }

  Future<void> _onLoadIncoming(
    LoadIncomingWebhooksEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      final webhooks = await _webhooksRepository.getIncomingWebhooks(
        teamId: event.teamId,
      );
      emit(IncomingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onLoadOutgoing(
    LoadOutgoingWebhooksEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      final webhooks = await _webhooksRepository.getOutgoingWebhooks(
        teamId: event.teamId,
      );
      emit(OutgoingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onCreateIncoming(
    CreateIncomingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      await _webhooksRepository.createIncomingWebhook(
        channelId: event.channelId,
        displayName: event.displayName,
      );
      final webhooks = await _webhooksRepository.getIncomingWebhooks();
      emit(IncomingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onCreateOutgoing(
    CreateOutgoingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      await _webhooksRepository.createOutgoingWebhook(
        teamId: event.teamId,
        displayName: event.displayName,
        callbackUrls: event.callbackUrls,
        triggerWords: event.triggerWords,
      );
      final webhooks = await _webhooksRepository.getOutgoingWebhooks(
        teamId: event.teamId,
      );
      emit(OutgoingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateIncoming(
    UpdateIncomingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      await _webhooksRepository.updateIncomingWebhook(
        event.hookId,
        channelId: event.channelId,
        displayName: event.displayName,
      );
      final webhooks = await _webhooksRepository.getIncomingWebhooks();
      emit(IncomingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateOutgoing(
    UpdateOutgoingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    emit(WebhooksLoadingState());
    try {
      await _webhooksRepository.updateOutgoingWebhook(
        event.hookId,
        displayName: event.displayName,
        callbackUrls: event.callbackUrls,
        triggerWords: event.triggerWords,
      );
      final webhooks = await _webhooksRepository.getOutgoingWebhooks();
      emit(OutgoingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteIncoming(
    DeleteIncomingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    try {
      await _webhooksRepository.deleteIncomingWebhook(event.hookId);
      if (state is IncomingWebhooksLoadedState) {
        final current = (state as IncomingWebhooksLoadedState).webhooks;
        emit(
          IncomingWebhooksLoadedState(
            current.where((w) => w.id != event.hookId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteOutgoing(
    DeleteOutgoingWebhookEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    try {
      await _webhooksRepository.deleteOutgoingWebhook(event.hookId);
      if (state is OutgoingWebhooksLoadedState) {
        final current = (state as OutgoingWebhooksLoadedState).webhooks;
        emit(
          OutgoingWebhooksLoadedState(
            current.where((w) => w.id != event.hookId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }

  Future<void> _onRegenerateToken(
    RegenerateOutgoingWebhookTokenEvent event,
    Emitter<WebhooksState> emit,
  ) async {
    try {
      await _webhooksRepository.regenerateOutgoingWebhookToken(event.hookId);
      final webhooks = await _webhooksRepository.getOutgoingWebhooks();
      emit(OutgoingWebhooksLoadedState(webhooks));
    } catch (e) {
      emit(WebhooksErrorState(e.toString()));
    }
  }
}
