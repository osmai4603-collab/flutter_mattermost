import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/emoji_picker_overlay.dart';

void main() {
  testWidgets('emoji grid should have multiple columns', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final link = LayerLink();
    final portal = OverlayPortalController();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Stack(
            children: [
              Center(
                child: CompositedTransformTarget(
                  link: link,
                  child: const SizedBox(width: 24, height: 24),
                ),
              ),
              OverlayPortal(
                controller: portal,
                overlayChildBuilder: (_) => CompositedTransformFollower(
                  link: link,
                  targetAnchor: Alignment.topRight,
                  followerAnchor: Alignment.bottomRight,
                  offset: const Offset(0, -10),
                  child: EmojiPickerOverlay(
                    onEmojiSelected: (_) {},
                    onClose: portal.hide,
                  ),
                ),
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );

    portal.show();
    await tester.pumpAndSettle();

    final card = tester.widget<Card>(find.byType(Card));
    final cardSize = tester.getSize(find.byType(Card));
    final grid = tester.widget<GridView>(find.byType(GridView));
    final gridSize = tester.getSize(find.byType(GridView));

    final containerSizes = <Size>[];
    for (final e in tester.elementList(find.byType(Container))) {
      final size = e.renderObject is RenderBox
          ? (e.renderObject! as RenderBox).size
          : Size.zero;
      containerSizes.add(size);
    }
    containerSizes.sort((a, b) => a.width.compareTo(b.width));

    debugPrint('CARD SIZE: $cardSize');
    debugPrint('GRID SIZE: $gridSize');
    debugPrint('ALL CONTAINER SIZES (asc by width):');
    for (final s in containerSizes) {
      debugPrint('  $s');
    }

    final delegate = grid.gridDelegate
        as SliverGridDelegateWithMaxCrossAxisExtent;
    final columns = ((gridSize.width + delegate.crossAxisSpacing) /
            (delegate.maxCrossAxisExtent + delegate.crossAxisSpacing))
        .floor();

    debugPrint('CARD SIZE: $cardSize');
    debugPrint('GRID SIZE: $gridSize');
    debugPrint('COLUMNS(first tab): $columns');
    debugPrint('CARD widget: $card');

    expect(columns, greaterThan(1));
  });
}