import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/date_x.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../../../models/child.dart';
import '../../../family/application/family_providers.dart';
import '../../application/children_providers.dart';
import '../../child_options.dart';
import '../../data/children_repository.dart';

Future<void> showChildEditor(BuildContext context, {Child? existing}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
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
  String? _temperament;
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
    _temperament = e?.temperament;
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
        temperament: _temperament,
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
            const _Label('Temperament'),
            const SizedBox(height: 10),
            _wrap([
              for (final t in ChildOptions.temperaments)
                SelectableChip(
                  label: t,
                  color: AppColors.mint,
                  selected: _temperament == t,
                  onTap: () => setState(
                      () => _temperament = _temperament == t ? null : t),
                ),
            ]),
            const SizedBox(height: 16),
            const _Label('Parenting goals'),
            const SizedBox(height: 10),
            _wrap([
              for (final g in ChildOptions.goals)
                SelectableChip(
                  label: g,
                  selected: _goals.contains(g),
                  onTap: () => setState(() =>
                      _goals.contains(g) ? _goals.remove(g) : _goals.add(g)),
                ),
            ]),
            const SizedBox(height: 16),
            const _Label('Common struggles'),
            const SizedBox(height: 10),
            _wrap([
              for (final s in ChildOptions.struggles)
                SelectableChip(
                  label: s,
                  color: AppColors.coral,
                  selected: _struggles.contains(s),
                  onTap: () => setState(() => _struggles.contains(s)
                      ? _struggles.remove(s)
                      : _struggles.add(s)),
                ),
            ]),
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
          ],
        ),
      ),
    );
  }

  Widget _wrap(List<Widget> children) =>
      Wrap(spacing: 8, runSpacing: 8, children: children);
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.w800, color: AppColors.ink, fontSize: 14.5));
}
