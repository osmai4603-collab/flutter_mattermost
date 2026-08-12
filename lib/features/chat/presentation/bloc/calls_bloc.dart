import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';

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
  const CallConnectedState({
    required this.callId,
    required this.channelId,
    this.isMuted = false,
    this.isVideoOn = false,
    this.isSharingScreen = false,
  });
  
  CallConnectedState copyWith({
    bool? isMuted,
    bool? isVideoOn,
    bool? isSharingScreen,
  }) => CallConnectedState(
    callId: callId,
    channelId: channelId,
    isMuted: isMuted ?? this.isMuted,
    isVideoOn: isVideoOn ?? this.isVideoOn,
    isSharingScreen: isSharingScreen ?? this.isSharingScreen,
  );

  @override
  List<Object?> get props => [callId, channelId, isMuted, isVideoOn, isSharingScreen];
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
    on<IncomingCallEvent>(_onIncomingCall);
    on<RejectCallEvent>(_onRejectCall);
  }

  void _onStartCall(StartCallEvent event, Emitter<CallsState> emit) async {
    // Generate a temporary callId or get it from API
    final tempCallId = 'call_${DateTime.now().millisecondsSinceEpoch}';
    await _callsManager.startCall(event.channelId, video: event.video);
    emit(CallConnectedState(
      callId: tempCallId,
      channelId: event.channelId,
      isVideoOn: event.video,
    ));
  }

  void _onJoinCall(JoinCallEvent event, Emitter<CallsState> emit) async {
    // We need channelId, assuming we get it from state or event
    String channelId = '';
    if (state is CallRingingState) {
      channelId = (state as CallRingingState).channelId;
    }
    await _callsManager.startCall(channelId);
    emit(CallConnectedState(callId: event.callId, channelId: channelId));
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

  void _onIncomingCall(IncomingCallEvent event, Emitter<CallsState> emit) {
    if (state is CallIdleState) {
      emit(CallRingingState(callId: event.callId, channelId: event.channelId));
    }
  }

  void _onRejectCall(RejectCallEvent event, Emitter<CallsState> emit) {
    // Send reject signal
    emit(CallIdleState());
  }
}
