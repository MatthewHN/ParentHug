import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../models/board_item.dart';
import '../../../../models/enums.dart';
import '../../application/board_providers.dart';
import '../../data/board_repository.dart';
import 'board_item_editor.dart';

/// One illustrative example per category, so every card always shows something
/// even before the family has added their own entries.
const _categoryExamples = <BoardCategory, String>{
  BoardCategory.headsUp: 'Skipped their nap today — may be extra tired tonight.',
  BoardCategory.rules: 'Screens off one hour before bedtime.',
  BoardCategory.wins: 'Shared toys without being asked 🌟',
  BoardCategory.wants: 'Really into dinosaurs and building blocks right now.',
  BoardCategory.triggers: 'Gets overwhelmed in loud, crowded places.',
  BoardCategory.savedScripts:
      '“I can see you’re frustrated. I’m right here with you.”',
};

/// Horizontally-scrollable deck of category cards. Every category is always
/// present; the focused-child filter is applied upstream in [boardItemsProvider].
/// The next card peeks at the right edge, and bottom arrows/dots offer an
/// explicit way to move between categories.
class BoardCategoryCarousel extends StatefulWidget {
  const BoardCategoryCarousel({
    super.key,
    required this.items,
    required this.childNames,
  });

  final List<BoardItem> items;
  final Map<String, String> childNames;

  @override
  State<BoardCategoryCarousel> createState() => _BoardCategoryCarouselState();
}

class _BoardCategoryCarouselState extends State<BoardCategoryCarousel> {
  // Saved Scripts is intentionally not shown as a board category.
  static final _categories = BoardCategory.values
      .where((c) => c != BoardCategory.savedScripts)
      .toList();
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page.clamp(0, _categories.length - 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            onPageChanged: (p) => setState(() => _page = p),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final category = _categories[i];
              final items =
                  widget.items.where((it) => it.category == category).toList();
              return Padding(
                padding: EdgeInsets.only(
                    left: i == 0 ? 20 : 8, right: 12, top: 2, bottom: 6),
                child: _CategoryCard(
                  category: category,
                  items: items,
                  childNames: widget.childNames,
                ),
              );
            },
          ),
        ),
        _Controls(
          page: _page,
          count: _categories.length,
          onPrev: () => _goTo(_page - 1),
          onNext: () => _goTo(_page + 1),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({
    required this.category,
    required this.items,
    required this.childNames,
  });

  final BoardCategory category;
  final List<BoardItem> items;
  final Map<String, String> childNames;

  Future<void> _add(BuildContext context) => showBoardItemEditor(context,
      initialCategory: category, lockCategory: true);

  Future<void> _edit(BuildContext context, BoardItem item) =>
      showBoardItemEditor(context, existing: item, lockCategory: true);

  Future<void> _delete(
      BuildContext context, WidgetRef ref, BoardItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove this entry?'),
        content: const Text('This can’t be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.coral),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(boardRepositoryProvider).delete(item.id);
      ref.invalidate(boardItemsProvider);
      ref.invalidate(recentBoardItemsProvider);
      if (context.mounted) AppSnackbar.success(context, 'Removed');
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.error(context,
            'Only the note’s creator or a family admin can do that.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = AppColors.category(category.value);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 13, 12, 13),
            color: color.withValues(alpha: 0.12),
            child: Row(
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(category.label,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.5)),
                ),
                if (items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text('${items.length}',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.w800)),
                  ),
                _AddButton(color: color, onTap: () => _add(context)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? _EmptyCategory(category: category, color: color)
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return _EntryTile(
                        item: item,
                        color: color,
                        childName: item.childId == null
                            ? null
                            : childNames[item.childId],
                        onTap: () => _edit(context, item),
                        onDelete: () => _delete(context, ref, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.item,
    required this.color,
    required this.onTap,
    required this.onDelete,
    this.childName,
  });

  final BoardItem item;
  final Color color;
  final String? childName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: AppColors.ink)),
                    if ((item.body ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.body!,
                          style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 13.5,
                              height: 1.4)),
                    ],
                    if (childName != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.child_care_outlined,
                              size: 14, color: AppColors.inkFaint),
                          const SizedBox(width: 4),
                          Text(childName!,
                              style: const TextStyle(
                                  color: AppColors.inkFaint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
                tooltip: 'Remove',
                icon: const Icon(Icons.close_rounded,
                    size: 18, color: AppColors.inkFaint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory({required this.category, required this.color});
  final BoardCategory category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final example = _categoryExamples[category] ?? '';
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text('Example',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5)),
              ),
              const SizedBox(height: 8),
              Text(example,
                  style: const TextStyle(
                      color: AppColors.inkMuted, fontSize: 14, height: 1.4)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text('Tap ＋ to add your first ${category.label.toLowerCase()}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.inkFaint,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.page,
    required this.count,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int count;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _Arrow(
              icon: Icons.chevron_left_rounded,
              enabled: page > 0,
              onTap: onPrev),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < count; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == page ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == page ? AppColors.primary : AppColors.hairline,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
          ),
          _Arrow(
              icon: Icons.chevron_right_rounded,
              enabled: page < count - 1,
              onTap: onNext),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.enabled, required this.onTap});
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon),
      color: AppColors.primary,
      disabledColor: AppColors.hairline,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.hairline),
      ),
    );
  }
}
