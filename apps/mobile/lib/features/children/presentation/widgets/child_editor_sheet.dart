import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_sheet.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/date_x.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/expandable_chip_field.dart';
import '../../../../models/child.dart';
import '../../../family/application/family_providers.dart';
import '../../application/children_providers.dart';
import '../../child_options.dart';
import '../../data/children_repository.dart';

Future<void> showChildEditor(BuildContext context, {Child? existing}) {
  return showAppSheet<void>(
    context: context,
    builder: (_) => _ChildEditor(existing: existing),
  );
}

class _ChildEditor extends ConsumerStatefulWidget {
  const _ChildEditor({this.existing});
  final Child? existing;

  @override
  ConsumerState<_ChildEditor> createState() => _ChildEditorState();
}

class _ChildEditorState extends ConsumerState<_ChildEditor> {
  late final TextEditingController _name;
  late final TextEditingController _notes;
  DateTime? _birthday;
  late final Set<String> _temperaments;
  late final Set<String> _goals;
  late final Set<String> _struggles;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _birthday = e?.birthday;
    _temperaments = {...?e?.temperaments};
    _goals = {...?e?.parentGoals};
    _struggles = {...?e?.commonStruggles};
  }

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      AppSnackbar.error(context, 'Add your child’s name.');
      return;
    }
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(childrenRepositoryProvider);
      final draft = Child(
        id: widget.existing?.id ?? '',
        familyId: familyId,
        name: _name.text.trim(),
        birthday: _birthday,
        temperaments: _temperaments.toList(),
        commonStruggles: _struggles.toList(),
        parentGoals: _goals.toList(),
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        createdBy: widget.existing?.createdBy ?? '',
        createdAt: widget.existing?.createdAt ?? DateTime.now(),
      );
      if (widget.existing == null) {
        await repo.create(familyId, draft);
      } else {
        await repo.update(draft);
      }
      ref.invalidate(childrenProvider);
      if (mounted) {
        Navigator.pop(context);
        AppSnackbar.success(context, 'Saved');
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Couldn’t save. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove() async {
    final existing = widget.existing;
    if (existing == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${existing.name}?'),
        content: const Text(
            'This removes this child’s profile and details from your family. This can’t be undone.'),
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
    setState(() => _busy = true);
    try {
      await ref.read(childrenRepositoryProvider).delete(existing.id);
      // Clear the focused child if it was the one we just removed.
      if (ref.read(selectedChildIdProvider) == existing.id) {
        ref.read(selectedChildIdProvider.notifier).state = null;
      }
      ref.invalidate(childrenProvider);
      if (mounted) {
        Navigator.pop(context);
        AppSnackbar.success(context, 'Removed');
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Couldn’t remove. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
                widget.existing == null
                    ? 'Add a child'
                    : 'Edit ${widget.existing!.name}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            AppTextField(label: 'Name', hint: 'e.g. Leo', controller: _name),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _birthday ?? DateTime(now.year - 3),
                  firstDate: DateTime(now.year - 19),
                  lastDate: now,
                );
                if (picked != null) setState(() => _birthday = picked);
              },
              child: Row(
                children: [
                  const Icon(Icons.cake_outlined, color: AppColors.inkFaint),
                  const SizedBox(width: 12),
                  Text(
                    _birthday == null
                        ? 'Select birthday'
                        : '${DateX.fullDate(_birthday!)}  ·  ${DateX.ageLabel(_birthday!)}',
                    style: TextStyle(
                        color: _birthday == null
                            ? AppColors.inkFaint
                            : AppColors.ink,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ExpandableChipField(
              label: 'Temperament',
              hint: 'Select temperament',
              color: AppColors.mint,
              options: ChildOptions.temperaments,
              selected: _temperaments,
              onChanged: (s) => setState(() {
                _temperaments
                  ..clear()
                  ..addAll(s);
              }),
            ),
            const SizedBox(height: 16),
            ExpandableChipField(
              label: 'Parenting goals',
              hint: 'Select goals',
              options: ChildOptions.goals,
              selected: _goals,
              onChanged: (s) => setState(() {
                _goals
                  ..clear()
                  ..addAll(s);
              }),
            ),
            const SizedBox(height: 16),
            ExpandableChipField(
              label: 'Common struggles',
              hint: 'Select struggles',
              color: AppColors.coral,
              options: ChildOptions.struggles,
              selected: _struggles,
              onChanged: (s) => setState(() {
                _struggles
                  ..clear()
                  ..addAll(s);
              }),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Notes (optional)',
              hint: 'Anything that helps ParentHug understand your child…',
              controller: _notes,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                label: widget.existing == null ? 'Add child' : 'Save changes',
                loading: _busy,
                onPressed: _save),
            if (widget.existing != null) ...[
              const SizedBox(height: 6),
              Center(
                child: TextButton.icon(
                  onPressed: _busy ? null : _remove,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: AppColors.coral),
                  label: const Text('Remove child',
                      style: TextStyle(color: AppColors.coral)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
