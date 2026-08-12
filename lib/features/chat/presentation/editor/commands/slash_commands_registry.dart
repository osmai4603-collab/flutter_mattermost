import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';

/// كيف يُعالج أمر slash: محلياً في المحرر أو عبر الخادم.
enum SlashCommandAction {
  status,
  header,
  purpose,
  shrug,
  code,
  collapse,
  expand,
  server,
}

/// أمر slash مدمج — نظير slash_commands في webapp
/// (webapp/channels/src/components/suggestion/slash_command).
class SlashCommand {
  final String trigger;
  final String hint;
  final SlashCommandAction action;
  final String Function(AppLocalizations l10n) description;

  const SlashCommand({
    required this.trigger,
    required this.hint,
    required this.action,
    required this.description,
  });
}

/// سجل أوامر السلاش المدمجة — يستخدم مفاتيح الترجمات `apiCommand_*`
/// الموجودة في ملفات .arb (مطابقة لأوصاف أوامر الخادم).
class SlashCommandsRegistry {
  SlashCommandsRegistry._();

  static SlashCommand _cmd(
    String trigger,
    SlashCommandAction action, {
    String key = '',
    String? hintKey,
  }) {
    return SlashCommand(
      trigger: trigger,
      hint: hintKey == null ? '' : '[$hintKey]',
      action: action,
      description: (l10n) {
        final lookup = {
          'away': l10n.apiCommand_awayDesc,
          'code': l10n.apiCommand_codeDesc,
          'collapse': l10n.apiCommand_collapseDesc,
          'dnd': l10n.apiCommand_dndDesc,
          'expand': l10n.apiCommand_expandDesc,
          'header': l10n.autocompleteCommandHeaderDesc,
          'join': l10n.apiCommand_joinDesc,
          'leave': l10n.apiCommand_leaveDesc,
          'me': l10n.apiCommand_meDesc,
          'mute': l10n.apiCommand_muteDesc,
          'offline': l10n.apiCommand_offlineDesc,
          'online': l10n.apiCommand_onlineDesc,
          'purpose': l10n.autocompleteCommandPurposeDesc,
          'shrug': l10n.apiCommand_shrugDesc,
        };
        return lookup[key.isEmpty ? trigger : key] ?? trigger;
      },
    );
  }

  /// الأوامر المدمجة (محلية + أوامر خادم معروفة).
  static final List<SlashCommand> builtIn = [
    SlashCommand(
      trigger: 'online',
      hint: '',
      action: SlashCommandAction.status,
      description: (l10n) => l10n.apiCommand_onlineDesc,
    ),
    SlashCommand(
      trigger: 'away',
      hint: '',
      action: SlashCommandAction.status,
      description: (l10n) => l10n.apiCommand_awayDesc,
    ),
    SlashCommand(
      trigger: 'dnd',
      hint: '',
      action: SlashCommandAction.status,
      description: (l10n) => l10n.apiCommand_dndDesc,
    ),
    SlashCommand(
      trigger: 'offline',
      hint: '',
      action: SlashCommandAction.status,
      description: (l10n) => l10n.apiCommand_offlineDesc,
    ),
    _cmd('shrug', SlashCommandAction.shrug, hintKey: 'message'),
    _cmd('code', SlashCommandAction.code, hintKey: 'text'),
    _cmd('me', SlashCommandAction.server, key: 'me', hintKey: 'the following text'),
    _cmd('header', SlashCommandAction.header, hintKey: 'your text here'),
    _cmd('purpose', SlashCommandAction.purpose, hintKey: 'the purpose of the channel'),
    _cmd('join', SlashCommandAction.server, key: 'join', hintKey: 'channel'),
    _cmd('leave', SlashCommandAction.server),
    _cmd('mute', SlashCommandAction.server),
    SlashCommand(
      trigger: 'collapse',
      hint: '',
      action: SlashCommandAction.collapse,
      description: (l10n) => l10n.apiCommand_collapseDesc,
    ),
    SlashCommand(
      trigger: 'expand',
      hint: '',
      action: SlashCommandAction.expand,
      description: (l10n) => l10n.apiCommand_expandDesc,
    ),
  ];

  /// مطابقة تامة حسب trigger (بدون `/`).
  static SlashCommand? match(String trigger) {
    for (final cmd in builtIn) {
      if (cmd.trigger == trigger) return cmd;
    }
    return null;
  }

  /// تصفية الأوامر المدمجة حسب الاستعلام (مطابقة بادئة + احتواء).
  static List<SlashCommand> search(String query) {
    final q = query.toLowerCase();
    if (q.isEmpty) return builtIn;
    return builtIn.where((c) => c.trigger.startsWith(q)).toList();
  }
}