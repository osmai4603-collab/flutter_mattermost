import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';

enum _ResendStatus { none, pending, success, failure }

/// صفحة طلب التحقق من البريد — مطابقة لـ ShouldVerifyEmail في webapp
class ShouldVerifyEmailPage extends StatefulWidget {
  final String? email;

  const ShouldVerifyEmailPage({super.key, this.email});

  @override
  State<ShouldVerifyEmailPage> createState() => _ShouldVerifyEmailPageState();
}

class _ShouldVerifyEmailPageState extends State<ShouldVerifyEmailPage> {
  _ResendStatus _status = _ResendStatus.none;

  Future<void> _handleResend() async {
    final email = widget.email;
    if (email == null || email.isEmpty) return;
    setState(() => _status = _ResendStatus.pending);
    try {
      await getIt<AuthRepository>().sendVerificationEmail(email);
      if (!mounted) return;
      setState(() => _status = _ResendStatus.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _ResendStatus.failure);
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
                  // Illustration icon 284px width
                  Container(
                    width: 284,
                    height: 180,
                    decoration: BoxDecoration(
                      color: theme.buttonBg.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.mark_email_unread_outlined,
                        size: 96,
                        color: theme.buttonBg,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title 40px / 600 weight
                  Text(
                    l10n.email_verifyAlmost,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),                  const SizedBox(height: 12),

                  // Message 16px
                  Text(
                    l10n.email_verifyNotVerifiedBody,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.72),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Status feedback message
                  if (_status == _ResendStatus.success) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.email_verifySent,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else if (_status == _ResendStatus.failure) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.email_verifyFailed,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Resend Button (48px height)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _status == _ResendStatus.pending ? null : _handleResend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonBg,
                        foregroundColor: theme.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        ),
                      ),
                      child: _status == _ResendStatus.pending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.buttonColor,
                              ),
                            )
                          : Text(
                              l10n.email_verifyResend,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Return to log in
                  TextButton(
                    onPressed: () => context.go('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.buttonBg,
                    ),
                    child: Text(
                      l10n.email_verifyReturn,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
