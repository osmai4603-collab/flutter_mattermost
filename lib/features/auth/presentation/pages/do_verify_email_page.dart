import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';

enum _VerifyState { loading, success, failure }

/// صفحة إجراء التحقق من البريد — مطابقة لـ DoVerifyEmail في webapp
class DoVerifyEmailPage extends StatefulWidget {
  final String? token;

  const DoVerifyEmailPage({super.key, this.token});

  @override
  State<DoVerifyEmailPage> createState() => _DoVerifyEmailPageState();
}

class _DoVerifyEmailPageState extends State<DoVerifyEmailPage> {
  _VerifyState _state = _VerifyState.loading;

  @override
  void initState() {
    super.initState();
    _performVerification();
  }

  Future<void> _performVerification() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      setState(() => _state = _VerifyState.failure);
      return;
    }
    try {
      await getIt<AuthRepository>().verifyUserEmail(token);
      if (!mounted) return;
      setState(() => _state = _VerifyState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _VerifyState.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_state == _VerifyState.loading) ...[
                    CircularProgressIndicator(color: theme.buttonBg),
                    const SizedBox(height: 24),
                    Text(
                      l10n.doVerifyEmailVerifying,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if (_state == _VerifyState.success) ...[
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.doVerifyEmailSuccessTitle,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.doVerifyEmailSuccessBody,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.72),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.buttonBg,
                          foregroundColor: theme.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                        ),
                        child: Text(
                          l10n.email_verifyReturn,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.doVerifyEmailFailureTitle,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.doVerifyEmailFailureBody,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.72),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.buttonBg,
                          foregroundColor: theme.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                        ),
                        child: Text(
                          l10n.email_verifyReturn,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
