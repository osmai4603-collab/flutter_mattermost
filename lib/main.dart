import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mattermost/features/chat/presentation/cubit/drafts_cubit.dart';
import 'package:flutter_mattermost/features/chat/presentation/cubit/threads_summary_cubit.dart';
import 'package:flutter_mattermost/features/groups/presentation/cubit/team_groups_cubit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_mattermost/app/config/desktop_window.dart';
import 'package:flutter_mattermost/app/routes/app_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/i18n/app_settings_cubit.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_registrations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_history_cubit.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_preferences_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

// http://localhost:8065/api/v4/system/ping
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Desktop Window Manager settings
  await DesktopWindowConfig.initialize();

  // Initialize media playback (media_kit for video/audio in messages).
  MediaKit.ensureInitialized();

  // Initialize GetIt dependency injection
  await configureDependencies();

  // Register modal dialogs (webapp ModalController)
  registerMattermostModals();

  runApp(const MattermostApp());
}

class MattermostApp extends StatelessWidget {
  const MattermostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => getIt<TeamBloc>()),
        BlocProvider(create: (_) => getIt<ChannelBloc>()),
        BlocProvider(create: (_) => getIt<ChannelHistoryCubit>()),
        BlocProvider(create: (_) => getIt<PostBloc>()),
        BlocProvider(create: (_) => getIt<LhsBloc>()),
        BlocProvider(create: (_) => getIt<RhsBloc>()),
        BlocProvider(create: (_) => getIt<UserStatusBloc>()),
        BlocProvider(create: (_) => getIt<UserPreferencesBloc>()),
        BlocProvider(create: (_) => getIt<UserProfileBloc>()),
        BlocProvider(create: (_) => getIt<ThreadsBloc>()),
        BlocProvider(create: (_) => getIt<CallsBloc>()),
        BlocProvider(create: (_) => getIt<DraftsCubit>()),
        BlocProvider(create: (_) => getIt<ThreadsSummaryCubit>()),
        BlocProvider(create: (_) => getIt<TeamGroupsCubit>()),
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
