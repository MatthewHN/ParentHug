import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/expandable_chip_field.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../models/enums.dart';
import '../../../models/repair_response.dart';
import '../../../services/edge_functions_service.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../../subscription/application/entitlement_gate.dart';
import '../application/repair_controller.dart';

class RepairScreen extends ConsumerStatefulWidget {
  const RepairScreen({super.key});

  @override
  ConsumerState<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends ConsumerState<RepairScreen> {
  final _situation = TextEditingController();
  ParentReaction _reaction = ParentReaction.yelled;
  RepairTone _tone = RepairTone.gentle;
  String? _childId;

  @override
  void initState() {
    super.initState();
    _childId = ref.read(selectedChildIdProvider);
  }

  @override
  void dispose() {
    _situation.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    if (!ensureEntitled(context, ref, min: PlanTier.pro)) return;
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    if (_situation.text.trim().isEmpty) {
      AppSnackbar.error(context, 'Tell us what happened.');
      return;
    }
    final children = ref.read(childrenProvider).valueOrNull ?? const [];
    if (children.isNotEmpty && _childId == null) {
      AppSnackbar.error(context, 'Choose which child this was with.');
      return;
    }
    await ref.read(repairControllerProvider.notifier).generate(
          familyId: familyId,
          childId: _childId,
          situation: _situation.text.trim(),
          reaction: _reaction,
          tone: _tone,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(repairControllerProvider);
    ref.listen(repairControllerProvider, (prev, next) {
      next.whenOrNull(error: (e, _) {
        if (e is EdgeFunctionException && e.isUpgradeRequired) {
          context.push(AppRoutes.paywall);
        } else {
          AppSnackbar.error(context, 'Couldn’t generate that right now.');
        }
      });
    });
    final result = state.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('I lost my cool')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (result != null)
              _RepairResult(
                response: result,
                onNew: () {
                  ref.read(repairControllerProvider.notifier).reset();
                  _situation.clear();
                },
              )
            else ...[
              const _RepairIntro(),
              const SizedBox(height: 18),
              _ChildPicker(
                selectedId: _childId,
                onSelect: (id) => setState(() => _childId = id),
              ),
              const Text('What happened?',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.ink)),
              const SizedBox(height: 10),
              TextField(
                controller: _situation,
                maxLines: 4,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText:
                      'e.g. I snapped at bedtime after asking three times.',
                ),
              ),
              const SizedBox(height: 18),
              ExpandableChipField(
                label: 'What did you do?',
                hint: 'Choose what happened',
                color: AppColors.coral,
                multiSelect: false,
                options: [for (final r in ParentReaction.values) r.label],
                selected: {_reaction.label},
                onChanged: (s) => setState(() {
                  if (s.isNotEmpty) {
                    _reaction = ParentReaction.values
                        .firstWhere((r) => r.label == s.first);
                  }
                }),
              ),
              const SizedBox(height: 16),
              ExpandableChipField(
                label: 'Tone',
                hint: 'Choose a tone',
                multiSelect: false,
                options: [for (final t in RepairTone.values) t.label],
                selected: {_tone.label},
                onChanged: (s) => setState(() {
                  if (s.isNotEmpty) {
                    _tone =
                        RepairTone.values.firstWhere((t) => t.label == s.first);
                  }
                }),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: '❤️ Repair',
                gradient: AppColors.warmGradient,
                loading: state.isLoading,
                onPressed: _generate,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RepairIntro extends StatelessWidget {
  const _RepairIntro();
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.coralSoft,
      child: Row(
        children: const [
          Text('🌈', style: TextStyle(fontSize: 30)),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Every parent loses it sometimes. Repair is how children learn that relationships survive hard moments.',
              style: TextStyle(color: AppColors.ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Required single-select "who was this with?" so the repair script can be
/// tuned to the right child (and their age). Renders nothing with no children.
class _ChildPicker extends ConsumerWidget {
  const _ChildPicker({required this.selectedId, required this.onSelect});
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Who was it with?'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final c in children)
              SelectableChip(
                label: c.name,
                selected: selectedId == c.id,
                onTap: () => onSelect(c.id),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _RepairResult extends StatelessWidget {
  const _RepairResult({
    required this.response,
    required this.onNew,
  });

  final RepairResponse response;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Card(
          emoji: '💬',
          label: 'What to say to your child',
          text: response.repairScript,
          color: AppColors.primary,
          emphasized: true,
        ),
        _Card(
          emoji: '✅',
          label: 'What to do next',
          text: response.followUp,
          color: const Color(0xFF2FB8C6),
        ),
        _Card(
          emoji: '🤍',
          label: 'For you',
          text: response.parentReassurance,
          color: const Color(0xFFB07CF6),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: onNew,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Start over'),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.emoji,
    required this.label,
    required this.text,
    required this.color,
    this.emphasized = false,
  });

  final String emoji;
  final String label;
  final String text;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        color: emphasized ? color.withValues(alpha: 0.10) : AppColors.surface,
        border: emphasized ? Border.all(color: color, width: 1.5) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(text,
                style: TextStyle(
                    color: AppColors.ink,
                    height: 1.5,
                    fontSize: emphasized ? 16 : 15,
                    fontWeight:
                        emphasized ? FontWeight.w700 : FontWeight.w500)),
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
          fontWeight: FontWeight.w800, color: AppColors.ink, fontSize: 15));
}
