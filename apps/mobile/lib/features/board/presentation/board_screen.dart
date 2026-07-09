import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../core/widgets/states.dart';
import '../../../models/enums.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../application/board_providers.dart';
import '../data/board_repository.dart';
import 'widgets/board_item_card.dart';
import 'widgets/board_item_editor.dart';

class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(boardItemsProvider);
    final filter = ref.watch(boardCategoryFilterProvider);
    final children = {
      for (final c in ref.watch(childrenProvider).valueOrNull ?? const [])
        c.id: c.name
    };

    Future<void> guard(Future<void> Function() action, [String? ok]) async {
      try {
        await action();
        ref.invalidate(boardItemsProvider);
        ref.invalidate(recentBoardItemsProvider);
        if (ok != null && context.mounted) AppSnackbar.success(context, ok);
      } catch (_) {
        if (context.mounted) {
          AppSnackbar.error(
              context, 'Only the note’s creator or a family admin can do that.');
        }
      }
    }

    final repo = ref.read(boardRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Board'),
        actions: [
          IconButton(
            onPressed: () => showBoardItemEditor(context),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showBoardItemEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add note',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ChildSelector(),
            ),
            const SizedBox(height: 12),
            _CategoryFilter(
              selected: filter,
              onSelect: (c) =>
                  ref.read(boardCategoryFilterProvider.notifier).state = c,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: itemsAsync.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  onRetry: () => ref.invalidate(boardItemsProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyView(
                      emoji: '🧩',
                      title: 'Your Family Board is empty',
                      message:
                          'Keep both parents in sync — add heads-ups, rules, wins, and scripts.',
                      actionLabel: 'Add your first note',
                      onAction: () => showBoardItemEditor(context),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async =>
                        ref.invalidate(boardItemsProvider),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return BoardItemCard(
                          item: item,
                          childName:
                              item.childId == null ? null : children[item.childId],
                          onPin: () => guard(
                              () => repo.setPinned(item.id, !item.pinned)),
                          onEdit: () =>
                              showBoardItemEditor(context, existing: item),
                          onArchive: () => guard(
                              () => repo.setArchived(item.id, true), 'Archived'),
                          onDelete: () =>
                              _confirmDelete(context, () => guard(
                                  () => repo.delete(item.id), 'Deleted')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this note?'),
        content: const Text('This can’t be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.coral),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onSelect});
  final BoardCategory? selected;
  final ValueChanged<BoardCategory?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SelectableChip(
              label: 'All',
              selected: selected == null,
              onTap: () => onSelect(null),
            ),
          ),
          for (final c in BoardCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SelectableChip(
                label: c.label,
                emoji: c.emoji,
                selected: selected == c,
                color: AppColors.category(c.value),
                onTap: () => onSelect(c),
              ),
            ),
        ],
      ),
    );
  }
}
