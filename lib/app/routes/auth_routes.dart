import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/auth/presentation/pages/auth_flow_pages.dart';
import 'package:flutter_mattermost/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_mattermost/features/auth/presentation/pages/signup_page.dart';

abstract class AuthRoutes {
  static const String login = '/login';
  static const String loginDesktop = '/login/desktop';
  static const String error = '/error';
  static const String resetPassword = '/reset_password';
  static const String resetPasswordComplete = '/reset_password_complete';
  static const String signupUserComplete = '/signup_user_complete';
  static const String signupUserCompleteDesktop =
      '/signup_user_complete/desktop';
  static const String shouldVerifyEmail = '/should_verify_email';
  static const String doVerifyEmail = '/do_verify_email';
  static const String claim = '/claim';
  static const String termsOfService = '/terms_of_service';
  static const String help = '/help/:page';
  static const String helpBase = '/help';
  static const String landing = '/landing';
  static const String selectTeam = '/select_team';
  static const String oauthAuthorize = '/oauth/authorize';
  static const String createTeam = '/create_team';
  static const String mfa = '/mfa';
  static const String preparingWorkspace = '/preparing-workspace';
  static const String popout = '/_popout';
}

final List<RouteBase> authRoutes = [
  GoRoute(
    path: AuthRoutes.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AuthRoutes.loginDesktop,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AuthRoutes.error,
    builder: (context, state) => const ErrorPage(),
  ),
  GoRoute(
    path: AuthRoutes.resetPassword,
    builder: (context, state) => const ResetPasswordPage(),
  ),
  GoRoute(
    path: AuthRoutes.resetPasswordComplete,
    builder: (context, state) => const ResetPasswordCompletePage(),
  ),
  GoRoute(
    path: AuthRoutes.signupUserComplete,
    builder: (context, state) => const SignupPage(),
  ),
  GoRoute(
    path: AuthRoutes.signupUserCompleteDesktop,
    builder: (context, state) => const SignupPage(),
  ),
  GoRoute(
    path: AuthRoutes.shouldVerifyEmail,
    builder: (context, state) => const ShouldVerifyEmailPage(),
  ),
  GoRoute(
    path: AuthRoutes.doVerifyEmail,
    builder: (context, state) => const DoVerifyEmailPage(),
  ),
  GoRoute(
    path: AuthRoutes.claim,
    builder: (context, state) => const ClaimPage(),
  ),
  GoRoute(
    path: AuthRoutes.termsOfService,
    builder: (context, state) => const TermsOfServicePage(),
  ),
  GoRoute(
    path: AuthRoutes.helpBase,
    builder: (context, state) =>
        HelpPage(page: state.uri.queryParameters['page']),
  ),
  GoRoute(
    path: AuthRoutes.help,
    builder: (context, state) => HelpPage(page: state.pathParameters['page']),
  ),
  GoRoute(
    path: AuthRoutes.landing,
    builder: (context, state) => const LandingPage(),
  ),
  GoRoute(
    path: AuthRoutes.selectTeam,
    builder: (context, state) => const SelectTeamPage(),
  ),
  GoRoute(
    path: AuthRoutes.oauthAuthorize,
    builder: (context, state) => const OAuthAuthorizePage(),
  ),
  GoRoute(
    path: AuthRoutes.createTeam,
    builder: (context, state) => const CreateTeamPage(),
  ),
  GoRoute(path: AuthRoutes.mfa, builder: (context, state) => const MfaPage()),
  GoRoute(
    path: AuthRoutes.preparingWorkspace,
    builder: (context, state) => const PreparingWorkspacePage(),
  ),
  GoRoute(
    path: AuthRoutes.popout,
    builder: (context, state) => const PopoutPage(),
  ),
];
