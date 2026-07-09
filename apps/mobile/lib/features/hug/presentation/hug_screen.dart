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
import '../../../services/edge_functions_service.dart';
import '../../board/application/board_providers.dart';
import '../../board/data/board_repository.dart';
import '../../board/data/scripts_repository.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../../family/application/family_providers.dart';
import '../application/hug_controller.dart';
import 'widgets/hug_result_view.dart';

const _contextChips = <String, String>{
  'Tantrum': '😤',
  'Bedtime': '🌙',
  'Screen time': '📱',
  'Hitting': '✋',
  'Sibling fight': '👧👦',
  'Not listening': '🙉',
  'Picky eating': '🍽️',
  'Public meltdown': '🛒',
  'School refusal': '🏫',
  'Separation anxiety': '🥺',
  'I yelled': '😞',
};

class HugScreen extends ConsumerStatefulWidget {
  const HugScreen({super.key});

  @override
  ConsumerState<HugScreen> createState() => _HugScreenState();
}

class _HugScreenState extends ConsumerState<HugScreen> {
  final _situation = TextEditingController();
  final _scroll = ScrollController();
  HugTone _tone = HugTone.gentle;
  final Set<String> _tags = {};

  @override
  void dispose() {
    _situation.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    final base = _situation.text.trim();
    if (base.isEmpty && _tags.isEmpty) {
      AppSnackbar.error(context, 'Tell ParentHug what’s happening.');
      return;
    }
    final situation =
        _tags.isEmpty ? base : 'Context: ${_tags.join(', ')}.\n$base';
    await ref.read(hugControllerProvider.notifier).generate(
          familyId: familyId,
          childId: ref.read(selectedChildIdProvider),
          situation: situation,
          tone: _tone,
        );
    if (mounted) {
      _scroll.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<void> _withBusy(Future<void> Function() action, String done) async {
    try {
      await action();
      if (mounted) AppSnackbar.success(context, done);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Couldn’t do that right now.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hugControllerProvider);

    ref.listen(hugControllerProvider, (prev, next) {
      next.whenOrNull(error: (e, _) {
        if (e is EdgeFunctionException && e.isUpgradeRequired) {
          context.push(AppRoutes.paywall);
        } else {
          AppSnackbar.error(
              context, 'Couldn’t generate that right now. Please try again.');
        }
      });
    });

    final result = state.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hug Button'),
        actions: [
          IconButton(
            tooltip: 'I lost my cool',
            onPressed: () => context.push(AppRoutes.repair),
            icon: const Icon(Icons.healing_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (result != null) ...[
              HugResultView(
                response: result,
                busy: state.isLoading,
                onGentler: () =>
                    ref.read(hugControllerProvider.notifier).makeGentler(),
                onFirmer: () =>
                    ref.read(hugControllerProvider.notifier).makeFirmer(),
                onAdaptAge: () =>
                    ref.read(hugControllerProvider.notifier).adaptForAge(),
                onSave: () => _saveScript(result),
                onShare: () {
                  Clipboard.setData(ClipboardData(text: hugToText(result)));
                  AppSnackbar.success(context, 'Copied — share it with anyone');
                },
                onAddToBoard: () => _addToBoard(result),
                onNew: () {
                  ref.read(hugControllerProvider.notifier).reset();
                  _situation.clear();
                  setState(_tags.clear);
                },
              ),
            ] else ...[
              _IntroHeader(),
              const SizedBox(height: 18),
              const ChildSelector(),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What’s happening?',
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
                            'e.g. My 4-year-old is screaming because I turned off the iPad.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _Label('Add context'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final entry in _contextChips.entries)
                    SelectableChip(
                      label: entry.key,
                      emoji: entry.value,
                      selected: _tags.contains(entry.key),
                      color: AppColors.coral,
                      onTap: () => setState(() => _tags.contains(entry.key)
                          ? _tags.remove(entry.key)
                          : _tags.add(entry.key)),
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
                  for (final t in HugTone.values)
                    SelectableChip(
                      label: t.label,
                      emoji: t.emoji,
                      selected: _tone == t,
                      onTap: () => setState(() => _tone = t),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: 'Get help now',
                icon: Icons.volunteer_activism_rounded,
                loading: state.isLoading,
                onPressed: _generate,
              ),
              if (state.isLoading) ...[
                const SizedBox(height: 20),
                const _ThinkingCard(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveScript(response) {
    final familyId = ref.read(currentFamilyIdProvider)!;
    final childId = ref.read(selectedChildIdProvider);
    return _withBusy(() async {
      await ref.read(scriptsRepositoryProvider).save(
            familyId: familyId,
            childId: childId,
            title: 'In-the-moment script',
            body: hugToText(response),
            source: 'hug',
            sourceId: response.id,
          );
      ref.invalidate(savedScriptsProvider);
    }, 'Saved to your scripts');
  }

  Future<void> _addToBoard(response) {
    final familyId = ref.read(currentFamilyIdProvider)!;
    final childId = ref.read(selectedChildIdProvider);
    return _withBusy(() async {
      await ref.read(boardRepositoryProvider).create(
            familyId: familyId,
            childId: childId,
            category: BoardCategory.savedScripts,
            title: 'Say this',
            body: response.sayThis,
          );
      ref.invalidate(boardItemsProvider);
    }, 'Added to your Family Board');
  }
}

class _IntroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('The next right words',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        const Text(
          'Tell ParentHug what’s going on and get calm, practical guidance in seconds.',
          style: TextStyle(color: AppColors.inkMuted, fontSize: 15, height: 1.4),
        ),
      ],
    );
  }
}

class _ThinkingCard extends StatelessWidget {
  const _ThinkingCard();
  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primarySoft,
      child: Row(
        children: const [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(AppColors.primary)),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text('Finding the next right words…',
                style: TextStyle(
                    color: AppColors.ink, fontWeight: FontWeight.w600)),
          ),
        ],
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
