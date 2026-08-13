import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
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

class SwitchAudioOutputEvent extends CallsEvent {
  final AudioOutputDevice device;
  const SwitchAudioOutputEvent(this.device);
  @override
  List<Object?> get props => [device];
}

class IncomingCallEvent extends CallsEvent {
  final String callId;
  final String channelId;
  const IncomingCallEvent({required this.callId, required this.channelId});
  @override
  List<Object?> get props => [callId, channelId];
}

class RejectCallEvent extends CallsEvent {
  final String callId;
  const RejectCallEvent(this.callId);
  @override
  List<Object?> get props => [callId];
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
  const CallRingingState({required this.callId, required this.channelId});
  @override
  List<Object?> get props => [callId, channelId];
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

  const CallConnectedState({
    required this.callId,
    required this.channelId,
    this.isMuted = false,
    this.isVideoOn = false,
    this.isSharingScreen = false,
    this.isHandRaised = false,
    this.audioDevice = AudioOutputDevice.speaker,
    this.participants = const {},
  });
  
  CallConnectedState copyWith({
    bool? isMuted,
    bool? isVideoOn,
    bool? isSharingScreen,
    bool? isHandRaised,
    AudioOutputDevice? audioDevice,
    Map<String, CallParticipantState>? participants,
  }) => CallConnectedState(
    callId: callId,
    channelId: channelId,
    isMuted: isMuted ?? this.isMuted,
    isVideoOn: isVideoOn ?? this.isVideoOn,
    isSharingScreen: isSharingScreen ?? this.isSharingScreen,
    isHandRaised: isHandRaised ?? this.isHandRaised,
    audioDevice: audioDevice ?? this.audioDevice,
    participants: participants ?? this.participants,
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
      ];
}

class CallReconnectingState extends CallsState {
  final String callId;
  const CallReconnectingState(this.callId);
  @override
  List<Object?> get props => [callId];
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
    on<SwitchAudioOutputEvent>(_onSwitchAudioOutput);
    on<IncomingCallEvent>(_onIncomingCall);
    on<RejectCallEvent>(_onRejectCall);
    
    _callsManager.incomingCalls.listen(_onIncomingCallFromServer);
    _callsManager.participantsStream.listen(_onParticipantsUpdated);
  }

  void _onIncomingCallFromServer(CallStartedEvent event) {
    add(IncomingCallEvent(callId: event.callId, channelId: event.channelId));
  }

  void _onParticipantsUpdated(Map<String, CallParticipantState> participants) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      emit(current.copyWith(participants: participants));
    }
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
      await _callsManager.startCall(current.channelId);
      emit(CallConnectedState(
        callId: event.callId,
        channelId: current.channelId,
        audioDevice: _callsManager.audioSessionManager.currentDevice,
      ));
    } catch (_) {
      emit(CallIdleState());
    }
  }

  void _onEndCall(EndCallEvent event, Emitter<CallsState> emit) {
    _callsManager.endCall();
    emit(CallIdleState());
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
      emit(CallRingingState(callId: event.callId, channelId: event.channelId));
    }
  }

  void _onRejectCall(RejectCallEvent event, Emitter<CallsState> emit) async {
    await _callsManager.endCall();
    emit(CallIdleState());
  }
}
