import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/app/routes/auth_routes.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryAction,
    this.footer,
    this.heroText,
  });

  final String title;
  final String subtitle;
  final Widget? primaryAction;
  final Widget? footer;
  final String? heroText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompact = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Flex(
                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isCompact
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isCompact)
                      SizedBox(
                        width: constraints.maxWidth * 0.42,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 64),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heroText ?? 'Mattermost',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.02,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'All your team communication, search, and collaboration in one place.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          heroText ?? 'Mattermost',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Container(
                      width: isCompact ? 500 : 500,
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: colorScheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Mattermost Desktop',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          if (primaryAction != null) ...[
                            const SizedBox(height: 24),
                            primaryAction!,
                          ],
                          if (footer != null) ...[
                            const SizedBox(height: 24),
                            footer!,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Error',
      subtitle: 'An unexpected error occurred while loading this workspace.',
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AuthPageShell(
      title: 'Reset password',
      subtitle:
          'To reset your password, enter the email address you used to sign up.',
      primaryAction: Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Email address',
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AuthRoutes.resetPasswordComplete),
              child: const Text('Reset my password'),
            ),
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Remembered your password?',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          TextButton(
            onPressed: () => context.go(AuthRoutes.login),
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordCompletePage extends StatelessWidget {
  const ResetPasswordCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Password reset',
      subtitle:
          'Your password was reset successfully and you can continue signing in.',
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.go(AuthRoutes.login),
          child: const Text('Back to sign in'),
        ),
      ),
    );
  }
}

class SignupUserCompletePage extends StatelessWidget {
  const SignupUserCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Create your account',
      subtitle:
          'Set up your user information and the team invitation details for this server.',
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.go(AuthRoutes.login),
          child: const Text('Create account'),
        ),
      ),
    );
  }
}

class ShouldVerifyEmailPage extends StatelessWidget {
  const ShouldVerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Verify your email',
      subtitle:
          'Check your inbox and click the verification link before continuing.',
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.go(AuthRoutes.doVerifyEmail),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}

class DoVerifyEmailPage extends StatelessWidget {
  const DoVerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Email verification',
      subtitle:
          'This screen confirms the email verification action for the account.',
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.go(AuthRoutes.login),
          child: const Text('Return to sign in'),
        ),
      ),
    );
  }
}

class ClaimPage extends StatelessWidget {
  const ClaimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Claim account',
      subtitle: 'Claiming an account requires the server-side onboarding flow.',
    );
  }
}

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AuthPageShell(
      title: 'Terms of service',
      subtitle: 'Review and accept the server terms before you continue.',
      primaryAction: Column(
        children: [
          CheckboxListTile(
            value: _accepted,
            onChanged: (value) => setState(() => _accepted = value ?? false),
            title: Text(
              'I agree to the server terms and privacy policy',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: colorScheme.primary,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _accepted ? () => context.go(AuthRoutes.login) : null,
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key, this.page});

  final String? page;

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Help',
      subtitle: page == null
          ? 'Support documentation is available from the server help system.'
          : 'Page: $page',
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Desktop landing',
      subtitle:
          'This page is the desktop app landing experience for the Mattermost client.',
    );
  }
}

class SelectTeamPage extends StatelessWidget {
  const SelectTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Select a team',
      subtitle: 'Choose an available team to continue into the app.',
    );
  }
}

class OAuthAuthorizePage extends StatelessWidget {
  const OAuthAuthorizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Authorize app',
      subtitle:
          'This OAuth authorization flow is handled through the server sign-in flow.',
    );
  }
}

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Create a team',
      subtitle: 'Create a new team from the onboarding flow.',
    );
  }
}

class MfaPage extends StatefulWidget {
  const MfaPage({super.key});

  @override
  State<MfaPage> createState() => _MfaPageState();
}

class _MfaPageState extends State<MfaPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AuthPageShell(
      title: 'Multi-factor authentication',
      subtitle: 'Enter the MFA code from your authenticator app to continue.',
      primaryAction: Column(
        children: [
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Authentication code',
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Verify code'),
            ),
          ),
        ],
      ),
    );
  }
}

class PreparingWorkspacePage extends StatelessWidget {
  const PreparingWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Preparing your workspace',
      subtitle: 'The desktop client is setting up your workspace and channels.',
    );
  }
}

class PopoutPage extends StatelessWidget {
  const PopoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageShell(
      title: 'Pop-out view',
      subtitle:
          'This view opens in a separate pop-out surface for the current channel.',
    );
  }
}
