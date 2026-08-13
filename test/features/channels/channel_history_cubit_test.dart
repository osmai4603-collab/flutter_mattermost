import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_history_cubit.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';

import 'test_fakes.dart';

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 30));

void main() {
  group('ChannelHistoryCubit', () {
    late ChannelBloc bloc;
    late ChannelHistoryCubit cubit;
    late FakeWebSocketClientManager ws;

    setUp(() {
      final channels = [
        testChannel('c1', name: 'town-square'),
        testChannel('c2', name: 'design'),
        testChannel('c3', name: 'off-topic'),
      ];
      ws = FakeWebSocketClientManager();
      bloc = ChannelBloc(
        FakeChannelRepository(channels: channels),
        ws,
      );
      cubit = ChannelHistoryCubit(bloc);
    });

    tearDown(() async {
      await cubit.close();
      await bloc.close();
    });

    Future<void> loadAndSelect(String id) async {
      if (bloc.state is! ChannelsLoadedState) {
        bloc.add(const LoadChannelsForTeamEvent('team1'));
        await _settle();
        expect(bloc.state, isA<ChannelsLoadedState>());
      }
      final channel = (bloc.state as ChannelsLoadedState)
          .channels
          .firstWhere((c) => c.id == id);
      bloc.add(SelectChannelEvent(channel));
      await _settle();
    }

    test('initial state has no navigation', () {
      expect(cubit.state.canGoBack, isFalse);
      expect(cubit.state.canGoForward, isFalse);
      expect(cubit.state.currentId, isNull);
    });

    test('load selects first channel without back stack', () async {
      bloc.add(const LoadChannelsForTeamEvent('team1'));
      await _settle();
      expect(cubit.state.currentId, 'c1');
      expect(cubit.state.canGoBack, isFalse);
      expect(cubit.state.canGoForward, isFalse);
    });

    test('selecting channels builds back stack and clears forward', () async {
      await loadAndSelect('c2');
      expect(cubit.state.currentId, 'c2');
      expect(cubit.state.backStack, ['c1']);
      expect(cubit.state.canGoForward, isFalse);

      await loadAndSelect('c3');
      expect(cubit.state.currentId, 'c3');
      expect(cubit.state.backStack, ['c1', 'c2']);
      expect(cubit.state.canGoForward, isFalse);
    });

    test('goBack moves current to forward and dispatches selection', () async {
      await loadAndSelect('c2');
      await loadAndSelect('c3');

      cubit.goBack();

      expect(cubit.state.currentId, 'c2');
      expect(cubit.state.backStack, ['c1']);
      expect(cubit.state.forwardStack, ['c3']);
      expect(cubit.state.pendingTarget?.id, 'c2');
      // إرسال SelectChannelEvent إلى البلوك.
      await _settle();
      expect(
        (bloc.state as ChannelsLoadedState).selectedChannel?.id,
        'c2',
      );
      // حدث التغيير الذاتي لا يدفع القناة لسجل الرجوع مرة أخرى.
      expect(cubit.state.backStack, ['c1']);
      expect(cubit.state.forwardStack, ['c3']);
    });

    test('goForward restores channel and keeps back stack', () async {
      await loadAndSelect('c2');
      await loadAndSelect('c3');
      cubit.goBack();
      await _settle();

      cubit.goForward();

      expect(cubit.state.currentId, 'c3');
      expect(cubit.state.backStack, ['c1', 'c2']);
      expect(cubit.state.forwardStack, isEmpty);
      await _settle();
      expect(
        (bloc.state as ChannelsLoadedState).selectedChannel?.id,
        'c3',
      );
    });

    test('goBack is a no-op when stack empty', () async {
      await loadAndSelect('c2');
      // لا رجوع أبعد من أول قناة في السجل.
      cubit.goBack();
      expect(cubit.state.currentId, 'c1');
      cubit.goBack();
      expect(cubit.state.currentId, 'c1');
      expect(cubit.state.canGoBack, isFalse);
    });

    test('back-and-forth navigation does not duplicate entries', () async {
      await loadAndSelect('c2');
      await loadAndSelect('c1');
      cubit.goBack();
      await _settle();
      cubit.goForward();
      await _settle();
      expect(cubit.state.currentId, 'c1');
      expect(cubit.state.backStack, ['c2']);
      expect(cubit.state.forwardStack, isEmpty);
    });

    test('ackNavigation clears pendingTarget', () async {
      await loadAndSelect('c2');
      await loadAndSelect('c3');
      cubit.goBack();
      expect(cubit.state.pendingTarget, isNotNull);

      cubit.ackNavigation();

      expect(cubit.state.pendingTarget, isNull);
      expect(cubit.state.currentId, 'c2');
    });

    test('user_added increments realtime member count', () async {
      bloc.add(const LoadChannelsForTeamEvent('team1'));
      await _settle();

      // إحصاءات القناة الأولى تُجلب في الخلفية.
      final repo = FakeChannelRepository(
        channels: [
          testChannel('c1', name: 'town-square'),
        ],
        stats: const [
          ChannelStats(
            channelId: 'c1',
            memberCount: 3,
            guestsCount: 1,
            pinnedPostsCount: 2,
          ),
        ],
      );
      final statsBloc = ChannelBloc(repo, ws);
      final statsCubit = ChannelHistoryCubit(statsBloc);
      statsBloc.add(const LoadChannelsForTeamEvent('team1'));
      await _settle();
      await _settle();

      var loaded = statsBloc.state as ChannelsLoadedState;
      expect(loaded.channelStats['c1']?.memberCount, 3);
      expect(loaded.channelStats['c1']?.guestsCount, 1);
      expect(loaded.channelStats['c1']?.pinnedPostsCount, 2);

      ws.emit(
        UserAddedEvent(
          userId: 'u9',
          channelId: 'c1',
          seq: 1,
        ),
      );
      await _settle();

      loaded = statsBloc.state as ChannelsLoadedState;
      expect(loaded.channelStats['c1']?.memberCount, 4);

      await statsCubit.close();
      await statsBloc.close();
    });
  });
}