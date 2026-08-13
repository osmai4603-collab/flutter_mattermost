import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/app/routes/channel_route.dart';
import 'package:flutter_mattermost/app/routes/integration_route.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/app/routes/auth_routes.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: ChatRoutes.home,
  routes: [...authRoutes, channelRoute, integrationRoute, adminRoute],
  redirect: _onRouteRedirect,
  refreshListenable: _AppRefreshListenable(),
);

/// يجمع تدفقات الـ Blocs المعنية ليُعيد تشغيل redirect عند تغيرها.
class _AppRefreshListenable extends ChangeNotifier {
  final List<StreamSubscription> _subscriptions = [];

  _AppRefreshListenable() {
    _subscriptions.add(
      getIt<AuthBloc>().stream.listen((_) => notifyListeners()),
    );
    _subscriptions.add(
      getIt<TeamBloc>().stream.listen((_) => notifyListeners()),
    );
    _subscriptions.add(
      getIt<ChannelBloc>().stream.listen((_) => notifyListeners()),
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}

bool _isPublicAuthRoute(String route) {
  final publicRoutes = <String>{
    AuthRoutes.login,
    AuthRoutes.loginDesktop,
    AuthRoutes.error,
    AuthRoutes.resetPassword,
    AuthRoutes.resetPasswordComplete,
    AuthRoutes.signupUserComplete,
    AuthRoutes.signupUserCompleteDesktop,
    AuthRoutes.shouldVerifyEmail,
    AuthRoutes.doVerifyEmail,
    AuthRoutes.claim,
    AuthRoutes.termsOfService,
    AuthRoutes.helpBase,
    AuthRoutes.help,
    AuthRoutes.landing,
    AuthRoutes.selectTeam,
    AuthRoutes.oauthAuthorize,
    AuthRoutes.createTeam,
    AuthRoutes.mfa,
    AuthRoutes.preparingWorkspace,
    AuthRoutes.popout,
  };

  return publicRoutes.any((publicRoute) {
    if (publicRoute == AuthRoutes.help || publicRoute == AuthRoutes.helpBase) {
      return route.startsWith('/help');
    }
    return route == publicRoute || route.startsWith('$publicRoute/');
  });
}

FutureOr<String?> _onRouteRedirect(
  BuildContext context,
  GoRouterState state,
) async {
  final authState = getIt<AuthBloc>().state;
  final matchedLocation = state.matchedLocation;

  if (authState is UnauthenticatedState || authState is AuthInitialState) {
    return _isPublicAuthRoute(matchedLocation) ? null : AuthRoutes.login;
  }

  if (authState is AuthenticatedState) {
    if (_isPublicAuthRoute(matchedLocation)) {
      return ChatRoutes.home;
    }

    // Admin Console route access
    if (matchedLocation.startsWith('/admin_console')) {
      final user = authState.user;
      final roles = user.roles.split(' ').where((r) => r.isNotEmpty).toList();
      final hasAdminRole = roles.contains('system_admin') ||
          roles.contains('system_read_only_admin') ||
          roles.any((r) => r.startsWith('system_'));
      if (!hasAdminRole) {
        final teamState = getIt<TeamBloc>().state;
        final team = teamState is TeamsLoadedState ? teamState.selectedTeam : null;
        return team != null ? '/${team.name}' : '/';
      }
      return null;
    }

    final teamState = getIt<TeamBloc>().state;
    if (teamState is! TeamsLoadedState) {
      getIt<TeamBloc>().add(LoadMyTeamsEvent());
      return null;
    }

    // الانتقال من /home إلى مسار الفريق الافتراضي بعد تحميل الفرق.
    if (matchedLocation == ChatRoutes.home || matchedLocation == '/') {
      final team = teamState.selectedTeam;
      return team == null ? null : '/${team.name}';
    }

    // التأكد من صحة اسم الفريق في المسار.
    final selectedName = teamState.selectedTeam?.name;
    if (selectedName != null &&
        matchedLocation != '/$selectedName' &&
        !matchedLocation.startsWith('/$selectedName/')) {
      final known = teamState.teams.any(
        (t) =>
            matchedLocation == '/${t.name}' ||
            matchedLocation.startsWith('/${t.name}/'),
      );
      if (!known) {
        return '/$selectedName';
      }
    }
  }

  return null;
}
