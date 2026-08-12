import 'package:flutter_mattermost/features/common/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

abstract class SplashRoutes {
  static const String splash = '/splash';
}

final List<RouteBase> splashRoutes = [
  GoRoute(
    path: SplashRoutes.splash,
    builder: (context, state) => const SplashPage(),
  ),
];
