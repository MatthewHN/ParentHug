import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../../../models/board_item.dart';
import '../../../../models/enums.dart';
import '../../../children/application/children_providers.dart';
import '../../../family/application/family_providers.dart';
import '../../application/board_providers.dart';
import '../../data/board_repository.dart';

/// Opens the create/edit sheet for a board item.
Future<void> showBoardItemEditor(
  BuildContext context, {
  BoardItem? existing,
  BoardCategory? initialCategory,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _BoardItemEditor(
      existing: existing,
      initialCategory: initialCategory,
    ),
  );
}

class _BoardItemEditor extends ConsumerStatefulWidget {
  const _BoardItemEditor({this.existing, this.initialCategory});
  final BoardItem? existing;
  final BoardCategory? initialCategory;

  @override
  ConsumerState<_BoardItemEditor> createState() => _BoardItemEditorState();
}

class _BoardItemEditorState extends ConsumerState<_BoardItemEditor> {
  late BoardCategory _category;
  late String? _childId;
  late final TextEditingController _title;
  late final TextEditingController _body;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _category = e?.category ?? widget.initialCategory ?? BoardCategory.headsUp;
    _childId = e?.childId ?? ref.read(selectedChildIdProvider);
    _title = TextEditingController(text: e?.title ?? '');
    _body = TextEditingController(text: e?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      AppSnackbar.error(context, 'Add a short title.');
      return;
    }
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(boardRepositoryProvider);
      if (widget.existing == null) {
        await repo.create(
          familyId: familyId,
          childId: _childId,
          category: _category,
          title: _title.text.trim(),
          body: _body.text.trim().isEmpty ? null : _body.text.trim(),
        );
      } else {
        await repo.update(
          widget.existing!.id,
          title: _title.text.trim(),
          body: _body.text.trim(),
          category: _category,
          childId: _childId,
          clearChild: _childId == null,
        );
      }
      ref.invalidate(boardItemsProvider);
      ref.invalidate(recentBoardItemsProvider);
      if (mounted) {
        Navigator.of(context).pop();
        AppSnackbar.success(context, 'Saved to your Family Board');
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Couldn’t save. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.existing == null ? 'New board note' : 'Edit note',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const _Label('Category'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in BoardCategory.values)
                  SelectableChip(
                    label: c.label,
                    emoji: c.emoji,
                    selected: _category == c,
                    color: AppColors.category(c.value),
                    onTap: () => setState(() => _category = c),
                  ),
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 16),
              const _Label('About which child?'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SelectableChip(
                    label: 'Whole family',
                    selected: _childId == null,
                    onTap: () => setState(() => _childId = null),
                  ),
                  for (final child in children)
                    SelectableChip(
                      label: child.name,
                      selected: _childId == child.id,
                      onTap: () => setState(() => _childId = child.id),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            AppTextField(
              label: 'Title',
              hint: 'e.g. Screen time limit',
              controller: _title,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Details (optional)',
              hint: 'Add any context for your co-parent…',
              controller: _body,
              maxLines: 4,
              minLines: 2,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: widget.existing == null ? 'Add note' : 'Save changes',
              loading: _busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.w800, color: AppColors.ink, fontSize: 14.5));
}
