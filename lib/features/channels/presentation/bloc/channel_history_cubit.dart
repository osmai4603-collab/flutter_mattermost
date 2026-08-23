import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// حالة سجل التنقل بين القنوات (مطابق أزرار Back/Forward في webapp):
/// حزمة سجل رجوع + حزمة تقدم حول القناة الحالية.
class ChannelHistoryState extends Equatable {
  /// القنوات السابقة (أقربها آخر عنصر).
  final List<String> backStack;

  /// القنوات التي تم التراجع عنها (أقربها آخر عنصر).
  final List<String> forwardStack;
  final String? currentId;

  /// القناة الهدف من goBack/goForward — تستهلك عبر BlocListener في الواجهة
  /// لتحديث مسار التطبيق ثم تُمسح عبر [ChannelHistoryCubit.ackNavigation].
  final ChannelEntity? pendingTarget;

  const ChannelHistoryState({
    this.backStack = const [],
    this.forwardStack = const [],
    this.currentId,
    this.pendingTarget,
  });

  bool get canGoBack => backStack.isNotEmpty;
  bool get canGoForward => forwardStack.isNotEmpty;

  @override
  List<Object?> get props => [backStack, forwardStack, currentId, pendingTarget];
}

/// يحفظ السجل الكامل للقنوات المزارة داخل التطبيق ويدفعها إلى
/// [ChannelBloc] عند الضغط على Back/Forward. يستمع لتيار [ChannelBloc]
/// نفسه فلا حاجة لتعديل كل مواقع إرسال SelectChannelEvent.
class ChannelHistoryCubit extends Cubit<ChannelHistoryState> {
  final ChannelBloc _channelBloc;
  StreamSubscription? _subscription;

  /// يمنع تسجيل القناة مرة ثانية في سجل الرجوع عند التنقل الذاتي
  /// (goBack/goForward) لأن الحالة تُحدَّث مسبقاً قبل إرسال SelectChannelEvent.
  bool _navigating = false;

  ChannelHistoryCubit(this._channelBloc) : super(const ChannelHistoryState()) {
    _subscription = _channelBloc.stream.listen((state) {
      if (state is ChannelsLoadedState) {
        _onChannelChanged(state.selectedChannel?.id);
      }
    });
  }

  void _onChannelChanged(String? id) {
    if (id == null) return;
    if (id == state.currentId) {
      // حدث التغيير الذاتي من goBack/goForward (الحالة سبقت الإرسال)
      // أو إعادة إصدار لنفس القناة — يمسح علم التنقل فقط.
      _navigating = false;
      return;
    }
    if (_navigating) {
      _navigating = false;
      return;
    }
    final current = state;
    final prevId = current.currentId;
    final back = (prevId == null || prevId == id)
        ? current.backStack
        : [...current.backStack.where((x) => x != id), prevId];
    emit(
      ChannelHistoryState(
        backStack: back,
        forwardStack: const [],
        currentId: id,
      ),
    );
  }

  /// العودة للقناة السابقة في السجل.
  void goBack() {
    if (!state.canGoBack) return;
    final back = [...state.backStack];
    final targetId = back.removeLast();
    final currentId = state.currentId;
    _navigateTo(
      targetId,
      backStack: back,
      forwardStack: currentId != null
          ? [...state.forwardStack.where((x) => x != targetId), currentId]
          : state.forwardStack,
    );
  }

  /// التقدم للقناة التي تم التراجع عنها.
  void goForward() {
    if (!state.canGoForward) return;
    final forward = [...state.forwardStack];
    final targetId = forward.removeLast();
    final currentId = state.currentId;
    _navigateTo(
      targetId,
      backStack: currentId != null
          ? [...state.backStack.where((x) => x != targetId), currentId]
          : state.backStack,
      forwardStack: forward,
    );
  }

  void _navigateTo(
    String targetId, {
    required List<String> backStack,
    required List<String> forwardStack,
  }) {
    final channelState = _channelBloc.state;
    final channel = channelState is ChannelsLoadedState
        ? channelState.channelById(targetId)
        : null;
    if (channel == null) return;
    _navigating = true;
    emit(
      ChannelHistoryState(
        backStack: backStack,
        forwardStack: forwardStack,
        currentId: targetId,
        pendingTarget: channel,
      ),
    );
    _channelBloc.add(SelectChannelEvent(channel));
  }

  /// مسح الهدف المعلق بعد تنفيذ التنقل في الواجهة (تحديث المسار).
  void ackNavigation() {
    final current = state;
    if (current.pendingTarget == null) return;
    emit(
      ChannelHistoryState(
        backStack: current.backStack,
        forwardStack: current.forwardStack,
        currentId: current.currentId,
      ),
    );
  }

  /// مسح سجل القنوات عند تسجيل الخروج.
  void clear() {
    _navigating = false;
    emit(const ChannelHistoryState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}