import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';

// Events
abstract class CallsEvent extends Equatable {
  const CallsEvent();
  @override
  List<Object?> get props => [];
}

class StartCallEvent extends CallsEvent {
  final String channelId;
  final bool video;
  const StartCallEvent(this.channelId, {this.video = false});
  @override
  List<Object?> get props => [channelId, video];
}

class JoinCallEvent extends CallsEvent {
  final String callId;
  const JoinCallEvent(this.callId);
  @override
  List<Object?> get props => [callId];
}

class EndCallEvent extends CallsEvent {}

class ToggleMuteEvent extends CallsEvent {}

class ToggleVideoEvent extends CallsEvent {}

class ToggleShareScreenEvent extends CallsEvent {}

class ToggleRaiseHandEvent extends CallsEvent {}

/// إرسال تفاعل (emoji) أثناء المكالمة — `react`.
class ToggleReactionEvent extends CallsEvent {
  final CallsEmoji emoji;
  const ToggleReactionEvent(this.emoji);
  @override
  List<Object?> get props => [emoji.name, emoji.literal];
}

class SwitchAudioOutputEvent extends CallsEvent {
  final AudioOutputDevice device;
  const SwitchAudioOutputEvent(this.device);
  @override
  List<Object?> get props => [device];
}

class IncomingCallEvent extends CallsEvent {
  final String callId;
  final String channelId;
  final String ownerId;
  const IncomingCallEvent({
    required this.callId,
    required this.channelId,
    this.ownerId = '',
  });
  @override
  List<Object?> get props => [callId, channelId, ownerId];
}

class RejectCallEvent extends CallsEvent {
  final String callId;
  const RejectCallEvent(this.callId);
  @override
  List<Object?> get props => [callId];
}

/// تغيّر حالة اتصال المكالمات (انقطاع/عودة) — يُراسَل من CallsManager.
class CallConnectionStatusChanged extends CallsEvent {
  final CallsWebSocketStatus status;
  const CallConnectionStatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}

/// تحديث المشاركين من CallsManager.
class ParticipantsChanged extends CallsEvent {
  final Map<String, CallParticipantState> participants;
  const ParticipantsChanged(this.participants);
  @override
  List<Object?> get props => [participants];
}

/// حدث تفاعل استُلم من مشارك آخر.
class ReactionReceived extends CallsEvent {
  final CallReactionEvent reaction;
  const ReactionReceived(this.reaction);
  @override
  List<Object?> get props => [reaction];
}

/// داخلي: حالة آلة الحالات (CallState) القادمة من CallsManager.callStateStream.
class CallStateFromManager extends CallsEvent {
  final CallState state;
  const CallStateFromManager(this.state);
  @override
  List<Object?> get props => [state];
}

// States
abstract class CallsState extends Equatable {
  const CallsState();
  @override
  List<Object?> get props => [];
}

class CallIdleState extends CallsState {}

class CallRingingState extends CallsState {
  final String callId;
  final String channelId;

  /// معرف مستخدم المتصل — لعرض اسمه في شريط الرنين.
  final String ownerId;
  const CallRingingState({
    required this.callId,
    required this.channelId,
    this.ownerId = '',
  });
  @override
  List<Object?> get props => [callId, channelId, ownerId];
}

class CallConnectedState extends CallsState {
  final String callId;
  final String channelId;
  final bool isMuted;
  final bool isVideoOn;
  final bool isSharingScreen;
  final bool isHandRaised;
  final AudioOutputDevice audioDevice;
  final Map<String, CallParticipantState> participants;
  final CallReactionEvent? lastReaction;

  const CallConnectedState({
    required this.callId,
    required this.channelId,
    this.isMuted = false,
    this.isVideoOn = false,
    this.isSharingScreen = false,
    this.isHandRaised = false,
    this.audioDevice = AudioOutputDevice.speaker,
    this.participants = const {},
    this.lastReaction,
  });
  
  CallConnectedState copyWith({
    bool? isMuted,
    bool? isVideoOn,
    bool? isSharingScreen,
    bool? isHandRaised,
    AudioOutputDevice? audioDevice,
    Map<String, CallParticipantState>? participants,
    CallReactionEvent? lastReaction,
  }) => CallConnectedState(
    callId: callId,
    channelId: channelId,
    isMuted: isMuted ?? this.isMuted,
    isVideoOn: isVideoOn ?? this.isVideoOn,
    isSharingScreen: isSharingScreen ?? this.isSharingScreen,
    isHandRaised: isHandRaised ?? this.isHandRaised,
    audioDevice: audioDevice ?? this.audioDevice,
    participants: participants ?? this.participants,
    lastReaction: lastReaction ?? this.lastReaction,
  );

  @override
  List<Object?> get props => [
        callId,
        channelId,
        isMuted,
        isVideoOn,
        isSharingScreen,
        isHandRaised,
        audioDevice,
        participants,
        lastReaction,
      ];
}

class CallReconnectingState extends CallsState {
  final String callId;
  const CallReconnectingState(this.callId);
  @override
  List<Object?> get props => [callId];
}

/// انتهت المكالمة خارجياً (call_end) — متميّزة عن CallIdleState كي تظهر
/// رسالة "انتهت المكالمة" قبل العودة إلى الخمول (مهلة قصيرة).
class CallEndedState extends CallsState {
  final String channelId;
  const CallEndedState({required this.channelId});
  @override
  List<Object?> get props => [channelId];
}

@injectable
class CallsBloc extends Bloc<CallsEvent, CallsState> {
  final CallsManager _callsManager;

  CallsBloc(this._callsManager) : super(CallIdleState()) {
    on<StartCallEvent>(_onStartCall);
    on<JoinCallEvent>(_onJoinCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleVideoEvent>(_onToggleVideo);
    on<ToggleShareScreenEvent>(_onToggleShareScreen);
    on<ToggleRaiseHandEvent>(_onToggleRaiseHand);
    on<ToggleReactionEvent>(_onToggleReaction);
    on<SwitchAudioOutputEvent>(_onSwitchAudioOutput);
    on<IncomingCallEvent>(_onIncomingCall);
    on<RejectCallEvent>(_onRejectCall);
    on<CallConnectionStatusChanged>(_onConnectionStatusChanged);
    on<ParticipantsChanged>(_onParticipantsChanged);
    on<ReactionReceived>(_onReactionReceived);
    on<CallStateFromManager>(_onCallStateFromManager);

    _callsManager.incomingCalls.listen(_onIncomingCallFromServer);
    _callsManager.participantsStream.listen(
      (p) => add(ParticipantsChanged(p)),
    );
    _callsManager.reactionsStream.listen(
      (r) => add(ReactionReceived(r)),
    );
    _callsManager.connectionStatusStream.listen(_onConnectionStatusChangedFromManager);
    _callsManager.callStateStream.listen((s) => add(CallStateFromManager(s)));
  }

  /// مؤقت ينهي حالة CallEndedState بعد عرض رسالة الانتهاء.
  Timer? _endedToIdleTimer;

  /// حالة آلة الحالات من CallsManager (المرحلة 3) — نميّز الانتهاء عن الخمول.
  void _onCallStateFromManager(
    CallStateFromManager event,
    Emitter<CallsState> emit,
  ) {
    switch (event.state) {
      case CallState.ringing:
      case CallState.joining:
      case CallState.connected:
      case CallState.reconnecting:
        break;
      case CallState.ended:
        final current = state;
        final channelId = switch (current) {
          CallConnectedState() => current.channelId,
          CallRingingState() => current.channelId,
          _ => null,
        };
        if (channelId != null && state is! CallEndedState) {
          _endedToIdleTimer?.cancel();
          emit(CallEndedState(channelId: channelId));
          _endedToIdleTimer = Timer(
            const Duration(seconds: 2),
            () => add(EndCallEvent()),
          );
        }
      case CallState.idle:
        if (state is CallEndedState || state is CallReconnectingState) {
          _endedToIdleTimer?.cancel();
          emit(CallIdleState());
        }
    }
  }

  void _onIncomingCallFromServer(CallStartedEvent event) {
    add(IncomingCallEvent(
      callId: event.callId,
      channelId: event.channelId,
      ownerId: event.ownerId,
    ));
  }

  void _onParticipantsChanged(
    ParticipantsChanged event,
    Emitter<CallsState> emit,
  ) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      // Sort participants: Hand raised first, then by join time/ID.
      final sortedParticipants = Map<String, CallParticipantState>.fromEntries(
        event.participants.entries.toList()
          ..sort((a, b) {
            if (a.value.isHandRaised && !b.value.isHandRaised) return -1;
            if (!a.value.isHandRaised && b.value.isHandRaised) return 1;
            return a.key.compareTo(b.key);
          }),
      );
      emit(current.copyWith(participants: sortedParticipants));
    }
  }

  void _onReactionReceived(
    ReactionReceived event,
    Emitter<CallsState> emit,
  ) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      emit(current.copyWith(lastReaction: event.reaction));
    }
  }

  void _onConnectionStatusChangedFromManager(CallsWebSocketStatus status) {
    add(CallConnectionStatusChanged(status));
  }

  /// انقطاع اتصال المكالمات → حالة إعادة اتصال، وعودته → متصل.
  void _onConnectionStatusChanged(
    CallConnectionStatusChanged event,
    Emitter<CallsState> emit,
  ) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      switch (event.status) {
        case CallsWebSocketStatus.reconnecting:
          emit(CallReconnectingState(current.callId));
          break;
        case CallsWebSocketStatus.connected:
        case CallsWebSocketStatus.connecting:
          emit(current.copyWith());
          break;
        case CallsWebSocketStatus.disconnected:
        case CallsWebSocketStatus.error:
          break;
      }
    }
  }

  /// إنهاء محلي من المستخدم — المغادرة تنظف الاتصال وتعيد الحالة إلى الخمول.
  void _onEndCall(EndCallEvent event, Emitter<CallsState> emit) {
    _endedToIdleTimer?.cancel();
    _callsManager.endCall();
    emit(CallIdleState());
  }

  void _onStartCall(StartCallEvent event, Emitter<CallsState> emit) async {
    try {
      await _callsManager.startCall(event.channelId, video: event.video);
      emit(CallConnectedState(
        callId: 'call_${DateTime.now().millisecondsSinceEpoch}',
        channelId: event.channelId,
        isVideoOn: event.video,
        audioDevice: _callsManager.audioSessionManager.currentDevice,
      ));
    } catch (_) {
      emit(CallIdleState());
    }
  }

  void _onJoinCall(JoinCallEvent event, Emitter<CallsState> emit) async {
    final current = state;
    if (current is! CallRingingState) return;
    try {
      await _callsManager.joinExistingCall(current.channelId);
      emit(CallConnectedState(
        callId: event.callId,
        channelId: current.channelId,
        audioDevice: _callsManager.audioSessionManager.currentDevice,
      ));
    } catch (_) {
      emit(CallIdleState());
    }
  }

  void _onToggleMute(ToggleMuteEvent event, Emitter<CallsState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      _callsManager.toggleMute();
      emit(current.copyWith(isMuted: !current.isMuted));
    }
  }

  void _onToggleVideo(ToggleVideoEvent event, Emitter<CallsState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      _callsManager.toggleVideo();
      emit(current.copyWith(isVideoOn: !current.isVideoOn));
    }
  }

  Future<void> _onToggleShareScreen(
    ToggleShareScreenEvent event,
    Emitter<CallsState> emit,
  ) async {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      await _callsManager.toggleScreenShare();
      emit(current.copyWith(isSharingScreen: !current.isSharingScreen));
    }
  }

  void _onToggleRaiseHand(ToggleRaiseHandEvent event, Emitter<CallsState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      final newHandState = !current.isHandRaised;
      _callsManager.raiseHand(newHandState);
      emit(current.copyWith(isHandRaised: newHandState));
    }
  }

  /// يرسل التفاعل فعلياً عبر إشارة `react` — يعرضه الخادم `user_reacted`.
  void _onToggleReaction(ToggleReactionEvent event, Emitter<CallsState> emit) {
    if (state is CallConnectedState) {
      _callsManager.sendReaction(event.emoji);
    }
  }

  void _onSwitchAudioOutput(
    SwitchAudioOutputEvent event,
    Emitter<CallsState> emit,
  ) async {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      await _callsManager.audioSessionManager.setAudioOutput(event.device);
      emit(current.copyWith(audioDevice: event.device));
    }
  }

  void _onIncomingCall(IncomingCallEvent event, Emitter<CallsState> emit) {
    if (state is CallIdleState) {
      emit(CallRingingState(
        callId: event.callId,
        channelId: event.channelId,
        ownerId: event.ownerId,
      ));
    }
  }

  void _onRejectCall(RejectCallEvent event, Emitter<CallsState> emit) async {
    if (state is CallRingingState) {
      final ringing = state as CallRingingState;
      await _callsManager.dismissIncomingCall(ringing.channelId);
    }
    emit(CallIdleState());
  }

  @override
  Future<void> close() {
    _endedToIdleTimer?.cancel();
    return super.close();
  }
}
