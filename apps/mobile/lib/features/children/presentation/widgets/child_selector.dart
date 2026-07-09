import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../application/children_providers.dart';

/// Horizontal row of children to focus context on. Writes to
/// [selectedChildIdProvider]. Shows nothing if there are no children.
class ChildSelector extends ConsumerWidget {
  const ChildSelector({super.key, this.includeAll = true});

  /// Whether to show an "All" chip (null selection).
  final bool includeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    if (children.isEmpty) return const SizedBox.shrink();

    final selected = ref.watch(selectedChildIdProvider);
    void select(String? id) =>
        ref.read(selectedChildIdProvider.notifier).state = id;

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        children: [
          if (includeAll)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SelectableChip(
                label: 'All',
                emoji: '👨‍👩‍👧',
                selected: selected == null,
                onTap: () => select(null),
              ),
            ),
          for (final child in children)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SelectableChip(
                label: child.name,
                selected: selected == child.id,
                color: AppColors.primary,
                onTap: () => select(child.id),
              ),
            ),
        ],
      ),
    );
  }
}
