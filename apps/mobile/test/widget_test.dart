import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parenthug/core/widgets/buttons.dart';
import 'package:parenthug/core/widgets/expandable_chip_field.dart';
import 'package:parenthug/features/auth/data/auth_repository.dart';
import 'package:parenthug/features/board/presentation/widgets/board_category_carousel.dart';
import 'package:parenthug/features/children/application/children_providers.dart';
import 'package:parenthug/features/hug/presentation/hug_screen.dart';
import 'package:parenthug/features/library/presentation/library_screen.dart';
import 'package:parenthug/features/library/presentation/impostor_screen.dart';
import 'package:parenthug/features/library/presentation/charades_screen.dart';
import 'package:parenthug/models/child.dart';

void main() {
  testWidgets('PrimaryButton renders label and responds to taps',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Get help now',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Get help now'), findsOneWidget);
    await tester.tap(find.text('Get help now'));
    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows a spinner while loading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Loading', loading: true),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LibraryScreen renders the requested family play categories',
      (tester) async {
    // Tall surface so the whole ListView builds (it virtualizes by default).
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Avoid hitting Supabase for the shared header's avatar.
          myProfileProvider.overrideWith((ref) => Future.value(null)),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pump();

    // Header, requested category titles, and playable entries are present.
    expect(find.text('ParentHug'), findsOneWidget);
    expect(find.text('Bring to life'), findsOneWidget);
    expect(find.text('Games'), findsOneWidget);
    expect(find.text('Photo to video'), findsOneWidget);
    expect(find.text('Charades'), findsOneWidget);
    expect(find.text('Impostor'), findsOneWidget);
  });

  testWidgets('Charades tile opens its ready screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProfileProvider.overrideWith((ref) => Future.value(null)),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.tap(find.text('Charades'));
    await tester.pumpAndSettle();

    expect(find.text('Ready for Charades?'), findsOneWidget);
  });

  testWidgets('Charades round fits a small landscape screen and shows Done',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(640, 320));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: CharadesScreen()));
    await tester.tap(find.text('Start playing'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Go again'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Impostor creates one card per player', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ImpostorScreen()));

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your card'), findsOneWidget);
    expect(find.text('Player 1'), findsOneWidget);
    expect(find.text('Player 2'), findsOneWidget);
    expect(find.text('Player 3'), findsOneWidget);
  });

  testWidgets('ExpandableChipField expands and reports a selection',
      (tester) async {
    final selected = <String>{};
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => ExpandableChipField(
              label: 'Goals',
              hint: 'Select goals',
              options: const ['Alpha', 'Bravo', 'Charlie'],
              selected: selected,
              onChanged: (s) => setState(() {
                selected
                  ..clear()
                  ..addAll(s);
              }),
            ),
          ),
        ),
      ),
    );

    // Collapsed: shows the hint, not a selection.
    expect(find.text('Select goals'), findsOneWidget);

    // Tap the field (its hint sits inside the tappable box) to expand.
    await tester.tap(find.text('Select goals'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bravo'));
    await tester.pumpAndSettle();

    expect(selected, {'Bravo'});
    // Hint is gone once something is chosen.
    expect(find.text('Select goals'), findsNothing);
  });

  testWidgets('BoardCategoryCarousel always shows a category card + example',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: BoardCategoryCarousel(items: const [], childNames: const {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // First category is always present, with its seeded example.
    expect(find.text('Heads Up'), findsOneWidget);
    expect(find.text('Example'), findsWidgets);
  });

  testWidgets('HugScreen shows the panic button, tone, and empty-chat welcome',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProfileProvider.overrideWith((ref) => Future.value(null)),
          childrenProvider.overrideWith((ref) => Future.value(const <Child>[])),
        ],
        child: const MaterialApp(home: HugScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('I lost my cool'), findsOneWidget); // panic button
    expect(find.textContaining('Tone:'), findsOneWidget); // tone selector
    expect(find.textContaining('here with you'), findsOneWidget); // welcome
  });
}
