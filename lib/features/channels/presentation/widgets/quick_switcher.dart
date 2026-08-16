import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// Quick Switcher (Ctrl+K): بحث فوري في قنوات الفريق الحالي.
class QuickSwitcher extends StatefulWidget {
  final VoidCallback onClose;

  const QuickSwitcher({super.key, required this.onClose});

  @override
  State<QuickSwitcher> createState() => _QuickSwitcherState();
}

class _QuickSwitcherState extends State<QuickSwitcher> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';

  /// فهرس العنصر المحدد بلوحة المفاتيح (UP/DOWN) — يتحرك ضمن نتائج البحث.
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.onKeyEvent = _onKeyEvent;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// نتائج البحث الحالية — تُقرأ من حالة الـ Bloc في نفس اللحظة
  /// (تستخدمها دالة معالجة المفاتيح وفي عرض القائمة معاً).
  List<ChannelEntity> _results() {
    final state = context.read<ChannelBloc>().state;
    final channels = state is ChannelsLoadedState
        ? state.channels
        : const <ChannelEntity>[];
    final q = _query.toLowerCase();
    return [
      for (final ch in channels)
        if (q.isEmpty ||
            ch.displayName.toLowerCase().contains(q) ||
            ch.name.toLowerCase().contains(q))
          ch,
    ];
  }

  /// فتح القناة المحددة والانتقال إليها (نفس منطق onTap السابق للصفوف).
  void _openChannel(ChannelEntity channel) {
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    final teamName = context.read<TeamBloc>().state is TeamsLoadedState
        ? (context.read<TeamBloc>().state as TeamsLoadedState)
              .selectedTeam
              ?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
    widget.onClose();
  }

  /// تنقل بلوحة المفاتيح داخل النتائج: UP/DOWN لتحريك التحديد،
  /// ENTER لفتح القناة المحددة، ESC للإغلاق.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final results = _results();
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        if (results.isEmpty) return KeyEventResult.ignored;
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % results.length;
        });
        _scrollToSelected();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        if (results.isEmpty) return KeyEventResult.ignored;
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + results.length) %
              results.length;
        });
        _scrollToSelected();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
        if (results.isEmpty) return KeyEventResult.ignored;
        _openChannel(results[_selectedIndex]);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        widget.onClose();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  /// يمرر القائمة ليبقى العنصر المحدد بلوحة المفاتيح ظاهراً
  /// (ارتفاع الصف ثابت = 48 في itemExtent).
  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (_selectedIndex * 48.0).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: Container(
        width: 650,
        height: 500,
        decoration: BoxDecoration(
          color: theme.centerChannelBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Find Channels',
                style: TextStyle(fontSize: 22, fontWeight: .bold),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: .symmetric(horizontal: 16),
              child: Text(
                'Type to find a channel, Use UP/DOWN to browse, ENTER to select, ESC to dismiss.',

                style: TextStyle(fontSize: 14, fontWeight: .w300),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: (value) => setState(() {
                  _query = value;
                  _selectedIndex = 0;
                }),
                style: TextStyle(color: theme.centerChannelColor),
                decoration: InputDecoration(
                  // hintText: l10n.quickSwitcherPlaceholder,
                  // hintStyle: TextStyle(
                  //   color: theme.centerChannelColor.withValues(alpha: 0.5),
                  // ),
                  contentPadding: .all(6),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0.50,
                      color: theme.centerChannelColor.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0.50,
                      color: theme.centerChannelColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.buttonBg, width: 1.50),
                  ),
                ),
              ),
            ),
            const Divider(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'RECENT',
                style: TextStyle(fontSize: 14, fontWeight: .w300),
              ),
            ),
            Expanded(
              child: BlocBuilder<ChannelBloc, ChannelState>(
                builder: (context, state) {
                  final q = _query.toLowerCase();
                  final channels = state is ChannelsLoadedState
                      ? state.channels
                      : const <ChannelEntity>[];
                  final results = [
                    for (final ch in channels)
                      if (q.isEmpty ||
                          ch.displayName.toLowerCase().contains(q) ||
                          ch.name.toLowerCase().contains(q))
                        ch,
                  ];
                  if (results.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          spacing: 16,
                          children: [
                            Image.asset(
                              'assets/images/result.png',
                              width: 100,
                              fit: .cover,
                            ),
                            Text(
                              'No result for "$_query"',
                              style: TextStyle(
                                color: theme.centerChannelColor,
                                fontSize: 22,
                                fontWeight: .bold,
                              ),
                            ),
                            Text(
                              'Check the spelling or try another search.',
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: 14,
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView(
                    controller: _scrollController,
                    itemExtent: 48,
                    children: [
                      for (var i = 0; i < results.length; i++)
                        _ResultTile(
                          channel: results[i],
                          isSelected: i == _selectedIndex,
                          onTap: () => _openChannel(results[i]),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final ChannelEntity channel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResultTile({
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        dense: true,
        selected: isSelected,
        leading: channel.type == .open
            ? Image.asset(
                'assets/images/channel_icon.png',
                fit: .cover,
                width: 20,
              )
            : Icon(
                Icons.lock_outline,
                size: 18,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
        title: Text(
          channel.displayName,
          style: TextStyle(color: theme.centerChannelColor, fontSize: 13),
        ),
        onTap: onTap,
        hoverColor: theme.centerChannelColor.withValues(alpha: 0.05),
        selectedTileColor: theme.centerChannelColor.withValues(alpha: 0.06),
      ),
    );
  }
}

void showQuickSwitcher(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) =>
        QuickSwitcher(onClose: () => Navigator.of(context).pop()),
  );
}
