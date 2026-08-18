import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header_text_popover.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

import 'test_fakes.dart';

void main() {
  testWidgets('ChannelHeader shows live stats and opens text popover', (
    tester,
  ) async {
    final ws = FakeWebSocketClientManager();
    final channel = testChannel('c1', name: 'town-square')
        .copyWith(
          purpose: 'Release notes: **bold** and [link](https://example.com)',
        );
    final repo = FakeChannelRepository(
      channels: [channel],
      stats: const [
        ChannelStats(
          channelId: 'c1',
          memberCount: 3,
          guestsCount: 1,
          pinnedPostsCount: 2,
        ),
      ],
    );

    final authBloc = FakeAuthBloc();
    final teamBloc = TeamBloc(FakeTeamRepository());
    final channelBloc = ChannelBloc(repo, ws, teamBloc);
    final rhsBloc = RhsBloc(FakePostRepository(), channelBloc);
    final callsBloc = CallsBloc(FakeCallsManager());
    addTearDown(() => authBloc.close());
    addTearDown(() => channelBloc.close());
    addTearDown(() => rhsBloc.close());
    addTearDown(() => callsBloc.close());
    addTearDown(() => teamBloc.close());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<ChannelBloc>.value(value: channelBloc),
          BlocProvider<RhsBloc>.value(value: rhsBloc),
          BlocProvider<CallsBloc>.value(value: callsBloc),
          BlocProvider<TeamBloc>.value(value: teamBloc),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ChannelHeader()),
        ),
      ),
    );

    channelBloc.add(const LoadChannelsForTeamEvent('team1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // اسم القناة + العدد الحي للأعضاء + عدد المثبتات.
    expect(find.text('c1'), findsWidgets);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // شارة الضيوف (أيقونة الشخص بجانب الاسم).
    expect(find.byIcon(Icons.person_outline), findsOneWidget);

    // فتح النافذة المنبثقة لوصف القناة بالضغط على العنوان.
    await tester.tap(find.text('c1').first);
    await tester.pumpAndSettle();

    expect(find.byType(ChannelHeaderTextPopover), findsWidgets);
    expect(find.text('Copy text'), findsOneWidget);
    expect(find.text('Edit Header'), findsOneWidget);
    // عرض الـ Markdown كاملاً داخل النافذة.
    expect(
      find.textContaining('Release notes'),
      findsWidgets,
    );
  });

  testWidgets('ChannelHeader does not open popover for empty description', (
    tester,
  ) async {
    final ws = FakeWebSocketClientManager();
    final repo = FakeChannelRepository(
      channels: [testChannel('c1', name: 'town-square')],
    );

    final authBloc = FakeAuthBloc();
    final teamBloc = TeamBloc(FakeTeamRepository());
    final channelBloc = ChannelBloc(repo, ws, teamBloc);
    final rhsBloc = RhsBloc(FakePostRepository(), channelBloc);
    final callsBloc = CallsBloc(FakeCallsManager());
    addTearDown(() => authBloc.close());
    addTearDown(() => channelBloc.close());
    addTearDown(() => rhsBloc.close());
    addTearDown(() => callsBloc.close());
    addTearDown(() => teamBloc.close());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<ChannelBloc>.value(value: channelBloc),
          BlocProvider<RhsBloc>.value(value: rhsBloc),
          BlocProvider<CallsBloc>.value(value: callsBloc),
          BlocProvider<TeamBloc>.value(value: teamBloc),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ChannelHeader()),
        ),
      ),
    );

    channelBloc.add(const LoadChannelsForTeamEvent('team1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('c1').first);
    await tester.pumpAndSettle();

    expect(find.text('Copy text'), findsNothing);
  });
}