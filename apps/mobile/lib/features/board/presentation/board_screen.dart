import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/states.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../application/board_providers.dart';
import 'widgets/board_category_carousel.dart';

/// The Family Board: one always-present card per category (Rules, Wins, Heads
/// Up…), laid out as a horizontal deck. Pick a child up top to see just their
/// entries; tap a card's ＋ to add to that category (no category picker needed).
class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(boardItemsProvider);
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final childNames = {for (final c in children) c.id: c.name};

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ChildSelector(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: itemsAsync.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  onRetry: () => ref.invalidate(boardItemsProvider),
                ),
                data: (items) => BoardCategoryCarousel(
                  items: items,
                  childNames: childNames,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
