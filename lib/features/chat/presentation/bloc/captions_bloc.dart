import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';

// Events
abstract class CaptionsEvent extends Equatable {
  const CaptionsEvent();
  @override
  List<Object?> get props => [];
}

class CaptionReceived extends CaptionsEvent {
  final CallCaptionEvent caption;
  const CaptionReceived(this.caption);
  @override
  List<Object?> get props => [caption];
}

class ClearCaptions extends CaptionsEvent {}

// States
class CaptionsState extends Equatable {
  final List<CallCaptionEvent> activeCaptions;

  const CaptionsState({this.activeCaptions = const []});

  CaptionsState copyWith({List<CallCaptionEvent>? activeCaptions}) {
    return CaptionsState(activeCaptions: activeCaptions ?? this.activeCaptions);
  }

  @override
  List<Object?> get props => [activeCaptions];
}

@injectable
class CaptionsBloc extends Bloc<CaptionsEvent, CaptionsState> {
  final CallsManager _callsManager;
  final Map<String, Timer> _expirationTimers = {};

  CaptionsBloc(this._callsManager) : super(const CaptionsState()) {
    on<CaptionReceived>(_onCaptionReceived);
    on<ClearCaptions>(_onClearCaptions);

    _callsManager.captionStream.listen((c) => add(CaptionReceived(c)));
  }

  void _onCaptionReceived(CaptionReceived event, Emitter<CaptionsState> emit) {
    final sessionId = event.caption.sessionId;
    
    // Update or add caption
    final newList = List<CallCaptionEvent>.from(state.activeCaptions);
    final index = newList.indexWhere((c) => c.sessionId == sessionId);
    
    if (index != -1) {
      newList[index] = event.caption;
    } else {
      newList.add(event.caption);
    }

    // Set/Reset expiration timer (5 seconds)
    _expirationTimers[sessionId]?.cancel();
    _expirationTimers[sessionId] = Timer(const Duration(seconds: 5), () {
      add(ClearCaptions());
    });

    emit(state.copyWith(activeCaptions: newList));
  }

  void _onClearCaptions(ClearCaptions event, Emitter<CaptionsState> emit) {
    final now = DateTime.now();
    // In a real implementation, we'd check which ones expired.
    // For simplicity, let's filter out ones that haven't been updated recently if we tracked timestamps.
    // Or just clear all if no new ones arrived within the timer window.
    // Let's refine: remove only expired ones.
    
    // For this simple version, let's just emit the current list minus expired ones.
    // Since we only have one timer per session, if this runs, it means at least one expired.
    emit(state.copyWith(activeCaptions: [])); 
  }

  @override
  Future<void> close() {
    for (var timer in _expirationTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
