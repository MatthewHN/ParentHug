import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../models/enums.dart';
import '../../../models/repair_response.dart';
import '../../../services/edge_functions_service.dart';
import '../../board/application/board_providers.dart';
import '../../board/data/board_repository.dart';
import '../../board/data/scripts_repository.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../../family/application/family_providers.dart';
import '../../subscription/application/entitlement_gate.dart';
import '../application/repair_controller.dart';

String repairToText(RepairResponse r) => [
      '💬 What to say\n${r.repairScript}',
      '✅ What to do next\n${r.followUp}',
      '🤍 For you\n${r.parentReassurance}',
    ].join('\n\n');

class RepairScreen extends ConsumerStatefulWidget {
  const RepairScreen({super.key});

  @override
  ConsumerState<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends ConsumerState<RepairScreen> {
  final _situation = TextEditingController();
  ParentReaction _reaction = ParentReaction.yelled;
  RepairTone _tone = RepairTone.gentle;
  bool _actionBusy = false;

  @override
  void dispose() {
    _situation.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    if (!ensureEntitled(context, ref, min: PlanTier.plus)) return;
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    if (_situation.text.trim().isEmpty) {
      AppSnackbar.error(context, 'Tell us what happened.');
      return;
    }
    await ref.read(repairControllerProvider.notifier).generate(
          familyId: familyId,
          childId: ref.read(selectedChildIdProvider),
          situation: _situation.text.trim(),
          reaction: _reaction,
          tone: _tone,
        );
  }

  Future<void> _withBusy(Future<void> Function() action, String done) async {
    setState(() => _actionBusy = true);
    try {
      await action();
      if (mounted) AppSnackbar.success(context, done);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Couldn’t do that right now.');
    } finally {
      if (mounted) setState(() => _actionBusy = false);
    }
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
                busy: _actionBusy,
                onSave: () => _withBusy(() async {
                  final familyId = ref.read(currentFamilyIdProvider)!;
                  await ref.read(scriptsRepositoryProvider).save(
                        familyId: familyId,
                        childId: ref.read(selectedChildIdProvider),
                        title: 'Repair script',
                        body: repairToText(result),
                        source: 'repair',
                        sourceId: result.id,
                      );
                  ref.invalidate(savedScriptsProvider);
                }, 'Saved to your scripts'),
                onShare: () {
                  Clipboard.setData(ClipboardData(text: repairToText(result)));
                  AppSnackbar.success(context, 'Copied to share');
                },
                onAddToBoard: () => _withBusy(() async {
                  final familyId = ref.read(currentFamilyIdProvider)!;
                  await ref.read(boardRepositoryProvider).create(
                        familyId: familyId,
                        childId: ref.read(selectedChildIdProvider),
                        category: BoardCategory.savedScripts,
                        title: 'Repair script',
                        body: result.repairScript,
                      );
                  ref.invalidate(boardItemsProvider);
                }, 'Added to your Family Board'),
                onNew: () {
                  ref.read(repairControllerProvider.notifier).reset();
                  _situation.clear();
                },
              )
            else ...[
              const _RepairIntro(),
              const SizedBox(height: 18),
              const ChildSelector(),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What happened?',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.ink)),
                    const SizedBox(height: 12),
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
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _Label('What did you do?'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final r in ParentReaction.values)
                    SelectableChip(
                      label: r.label,
                      selected: _reaction == r,
                      color: AppColors.coral,
                      onTap: () => setState(() => _reaction = r),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              const _Label('Tone'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final t in RepairTone.values)
                    SelectableChip(
                      label: t.label,
                      selected: _tone == t,
                      onTap: () => setState(() => _tone = t),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: 'Get a repair script',
                icon: Icons.healing_rounded,
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

class _RepairResult extends StatelessWidget {
  const _RepairResult({
    required this.response,
    required this.busy,
    required this.onSave,
    required this.onShare,
    required this.onAddToBoard,
    required this.onNew,
  });

  final RepairResponse response;
  final bool busy;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onAddToBoard;
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: SecondaryButton(
                    label: 'Save', icon: Icons.bookmark_add_outlined, onPressed: onSave)),
            const SizedBox(width: 10),
            Expanded(
                child: SecondaryButton(
                    label: 'Share', icon: Icons.ios_share_rounded, onPressed: onShare)),
          ],
        ),
        const SizedBox(height: 10),
        SecondaryButton(
            label: 'Add to Family Board',
            icon: Icons.push_pin_outlined,
            onPressed: onAddToBoard),
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
                        color: color, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(text,
                style: TextStyle(
                    color: AppColors.ink,
                    height: 1.5,
                    fontSize: emphasized ? 16 : 15,
                    fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500)),
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
