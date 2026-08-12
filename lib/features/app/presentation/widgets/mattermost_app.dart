import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mattermost/app/routes/app_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/i18n/app_settings_cubit.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/search_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_preferences_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

class MattermostApp extends StatefulWidget {
  const MattermostApp({super.key});

  @override
  State<MattermostApp> createState() => _MattermostAppState();
}

class _MattermostAppState extends State<MattermostApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => getIt<TeamBloc>()),
        BlocProvider(create: (_) => getIt<ChannelBloc>()),
        BlocProvider(create: (_) => getIt<PostBloc>()),
        BlocProvider(create: (_) => getIt<LhsBloc>()),
        BlocProvider(create: (_) => getIt<RhsBloc>()),
        BlocProvider(create: (_) => getIt<UserStatusBloc>()),
        BlocProvider(create: (_) => getIt<UserPreferencesBloc>()),
        BlocProvider(create: (_) => getIt<UserProfileBloc>()),
        BlocProvider(create: (_) => getIt<ThreadsBloc>()),
        BlocProvider(create: (_) => getIt<SearchBloc>()),
        BlocProvider(create: (_) => getIt<CallsBloc>()),
        // إعدادات الواجهة: اللغة EN/AR + الوضع (فاتح/داكن).
        BlocProvider(create: (_) => AppSettingsCubit()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppLocaleState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Mattermost Desktop',
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settings.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
