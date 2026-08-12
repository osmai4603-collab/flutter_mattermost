import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcuts extends StatelessWidget {
  final Widget child;
  final VoidCallback onQuickSwitch;

  const AppShortcuts({
    super.key,
    required this.child,
    required this.onQuickSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
            const QuickSwitchIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK):
            const QuickSwitchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          QuickSwitchIntent: CallbackAction<QuickSwitchIntent>(
            onInvoke: (QuickSwitchIntent intent) => onQuickSwitch(),
          ),
        },
        child: child,
      ),
    );
  }
}

class QuickSwitchIntent extends Intent {
  const QuickSwitchIntent();
}
