import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';

enum _MfaState { setup, confirm }

/// صفحة المصادقة متعددة العوامل (MFA) — مطابقة لـ MFA في webapp
class MfaPage extends StatefulWidget {
  final bool isSetup;

  const MfaPage({super.key, this.isSetup = true});

  @override
  State<MfaPage> createState() => _MfaPageState();
}

class _MfaPageState extends State<MfaPage> {
  late _MfaState _state;
  final _codeController = TextEditingController();
  final String _secret = 'ABCD EFGH IJKL MNOP'; // Placeholder secret

  @override
  void initState() {
    super.initState();
    _state = widget.isSetup ? _MfaState.setup : _MfaState.confirm;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_codeController.text.length == 6) {
      setState(() => _state = _MfaState.confirm);
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
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_state == _MfaState.setup) ...[
                    _buildSetupHeader(theme, l10n),
                    const SizedBox(height: 24),
                    _buildQrPlaceholder(theme),
                    const SizedBox(height: 24),
                    _buildSecretSection(theme, l10n),
                    const SizedBox(height: 32),
                    _buildCodeInput(theme, l10n),
                    const SizedBox(height: 24),
                    _buildActions(theme, l10n),
                  ] else ...[
                    _buildConfirmState(theme, l10n),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetupHeader(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.mfaSetupTitle,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.mfaSetupStep1,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 15,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQrPlaceholder(MattermostColors theme) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        border: Border.all(color: theme.centerChannelColor.withValues(alpha: 0.08)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_2, size: 120, color: theme.centerChannelColor),
            const SizedBox(height: 8),
            Text(
              '[QR Code]',
              style: TextStyle(color: theme.centerChannelColor.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecretSection(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.mfaSetupStep2_secret,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.centerChannelColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Text(
            _secret,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mfaSetupStep3_code,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: TextStyle(color: theme.centerChannelColor),
          decoration: InputDecoration(
            hintText: l10n.mfaSetupCode,
            counterText: '',
            filled: true,
            fillColor: theme.centerChannelColor.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              borderSide: BorderSide(color: theme.centerChannelColor.withValues(alpha: 0.16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(MattermostColors theme, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.buttonBg,
          foregroundColor: theme.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
        ),
        child: Text(
          l10n.mfaSetupSave,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildConfirmState(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 72),
        const SizedBox(height: 24),
        Text(
          l10n.mfaConfirmComplete,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.mfaConfirmSecure,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonBg,
              foregroundColor: theme.buttonColor,
            ),
            child: Text(l10n.mfaConfirmOkay),
          ),
        ),
      ],
    );
  }
}
