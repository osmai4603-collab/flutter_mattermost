import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';

void main() {
  Widget buildHost(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('MatterMenuScope opens on tap, runs item callback and closes', (
    tester,
  ) async {
    var tapped = false;
    var selected = '';

    await tester.pumpWidget(
      buildHost(
        MatterMenuScope(
          items: [
            MatterMenuItem(
              id: 'one',
              label: 'First',
              onTap: () => selected = 'one',
            ),
            MatterMenuItem(
              id: 'two',
              label: 'Second',
              onTap: () => tapped = true,
            ),
          ],
          child: const Text('menu-anchor'),
        ),
      ),
    );

    expect(find.text('First'), findsNothing);

    await tester.tap(find.text('menu-anchor'));
    await tester.pumpAndSettle();

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);

    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();

    expect(selected, 'one');
    expect(tapped, isFalse);
    expect(find.text('First'), findsNothing);
  });

  testWidgets('submenu expands and runs its item callback', (tester) async {
    var selected = '';

    await tester.pumpWidget(
      buildHost(
        MatterMenuScope(
          items: [
            MatterMenuItem(
              id: 'sort',
              label: 'Sort',
              submenu: [
                MatterMenuItem(
                  id: 'sort_alpha',
                  label: 'Alphabetical',
                  onTap: () => selected = 'sort_alpha',
                ),
                MatterMenuItem(
                  id: 'sort_recent',
                  label: 'Recent',
                  onTap: () => selected = 'sort_recent',
                ),
              ],
            ),
          ],
          child: const Text('menu-anchor'),
        ),
      ),
    );

    await tester.tap(find.text('menu-anchor'));
    await tester.pumpAndSettle();

    expect(find.text('Alphabetical'), findsNothing);

    // التمرير فوق بند القائمة الفرعية يفتحها تلقائياً.
    final gesture = await tester.createGesture();
    await gesture.addPointer(location: tester.getCenter(find.text('Sort')));
    await gesture.moveTo(tester.getCenter(find.text('Sort')));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    expect(find.text('Alphabetical'), findsOneWidget);

    await tester.tap(find.text('Alphabetical'));
    await tester.pumpAndSettle();

    expect(selected, 'sort_alpha');
    expect(find.text('Sort'), findsNothing);
  });

  testWidgets('dividers render and outside tap closes the menu', (tester) async {
    await tester.pumpWidget(
      buildHost(
        MatterMenuScope(
          items: [
            MatterMenuItem(
              id: 'a',
              label: 'Alpha',
              onTap: () {},
            ),
            const MatterMenuItem.divider(),
            MatterMenuItem(
              id: 'b',
              label: 'Beta',
              onTap: () {},
            ),
          ],
          child: const Text('menu-anchor'),
        ),
      ),
    );

    await tester.tap(find.text('menu-anchor'));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);

    // النقر خارج القائمة يغلقها.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('showContextMenuAt opens at position and item runs callback', (
    tester,
  ) async {
    var selected = '';

    await tester.pumpWidget(
      buildHost(
        Builder(
          builder: (context) => TextButton(
            onPressed: () {
              showContextMenuAt(
                context,
                position: const Offset(100, 100),
                items: [
                  MatterMenuItem(
                    id: 'ctx',
                    label: 'Context Item',
                    onTap: () => selected = 'ctx',
                  ),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Context Item'), findsOneWidget);

    await tester.tap(find.text('Context Item'));
    await tester.pumpAndSettle();

    expect(selected, 'ctx');
    expect(find.text('Context Item'), findsNothing);
  });
}
