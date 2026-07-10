import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/date_x.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../../../models/enums.dart';
import '../../../children/application/children_providers.dart';
import '../../../family/application/family_providers.dart';
import '../../application/memories_providers.dart';
import '../../data/memories_repository.dart';

class MemoryUploadSheet extends ConsumerStatefulWidget {
  const MemoryUploadSheet({
    super.key,
    required this.bytes,
    required this.fileExt,
  });

  final Uint8List bytes;
  final String fileExt;

  @override
  ConsumerState<MemoryUploadSheet> createState() => _MemoryUploadSheetState();
}

class _MemoryUploadSheetState extends ConsumerState<MemoryUploadSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  DateTime _date = DateTime.now();
  MilestoneType _milestone = MilestoneType.everyday;
  String? _childId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _childId = ref.read(selectedChildIdProvider);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(memoriesRepositoryProvider).upload(
            familyId: familyId,
            childId: _childId,
            bytes: widget.bytes,
            fileExt: widget.fileExt == 'png' ? 'png' : 'jpg',
            title: _title.text.trim().isEmpty ? null : _title.text.trim(),
            description: _description.text.trim().isEmpty
                ? null
                : _description.text.trim(),
            memoryDate: _date,
            milestone: _milestone,
          );
      ref.invalidate(memoriesProvider);
      if (mounted) {
        Navigator.pop(context);
        AppSnackbar.success(context, 'Added to your HugBook');
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Upload failed. Check your connection.');
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
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.memory(widget.bytes,
                  height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            AppTextField(
                label: 'Title',
                hint: 'e.g. First bike ride',
                controller: _title),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Description (optional)',
              hint: 'What made this moment special?',
              controller: _description,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 14),
            _DateRow(date: _date, onPick: (d) => setState(() => _date = d)),
            const SizedBox(height: 16),
            const _Label('Milestone'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in MilestoneType.values)
                  SelectableChip(
                    label: '${m.emoji} ${m.label}',
                    selected: _milestone == m,
                    onTap: () => setState(() => _milestone = m),
                  ),
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 16),
              const _Label('Who’s in it?'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SelectableChip(
                    label: 'Family',
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
            const SizedBox(height: 20),
            PrimaryButton(
                label: 'Save memory', loading: _busy, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.date, required this.onPick});
  final DateTime date;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Label('Date'),
        const Spacer(),
        TextButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) onPick(picked);
          },
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: Text(DateX.fullDate(date)),
        ),
      ],
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
