import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_x.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/states.dart';
import '../../../models/child.dart';
import '../../../models/enums.dart';
import '../../../models/memory.dart';
import '../../../services/edge_functions_service.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../../family/application/family_providers.dart';
import '../application/memories_providers.dart';
import '../data/memories_repository.dart';
import 'widgets/memory_image.dart';
import 'widgets/memory_upload_sheet.dart';

class MemoriesScreen extends ConsumerWidget {
  const MemoriesScreen({super.key});

  Future<void> _addMemory(BuildContext context, WidgetRef ref) async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2200,
        imageQuality: 88,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final ext = file.name.contains('.')
          ? file.name.split('.').last.toLowerCase()
          : 'jpg';
      if (!context.mounted) return;
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => MemoryUploadSheet(bytes: bytes, fileExt: ext),
      );
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Couldn’t open your photos.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(memoriesProvider);
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final lastYear = ref.watch(thisDayLastYearProvider);
    final upcoming = _upcomingBirthday(children);

    return Scaffold(
      appBar: const AppHeader(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMemory(context, ref),
        backgroundColor: AppColors.coral,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Add memory',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        top: false,
        child: memoriesAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) =>
              ErrorView(onRetry: () => ref.invalidate(memoriesProvider)),
          data: (memories) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => ref.invalidate(memoriesProvider),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
                children: [
                  const ChildSelector(),
                  const SizedBox(height: 16),
                  if (upcoming != null) ...[
                    _BirthdayCollageCard(
                      child: upcoming,
                      onCreate: () => _createCollage(context, ref, upcoming),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (lastYear != null) ...[
                    _ThisDayLastYear(memory: lastYear),
                    const SizedBox(height: 16),
                  ],
                  if (memories.isEmpty)
                    _EmptyMemories(onAdd: () => _addMemory(context, ref))
                  else
                    ..._buildTimeline(context, memories),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(BuildContext context, List<Memory> memories) {
    // Preserve the date-desc order while grouping by month.
    final groups = <String, List<Memory>>{};
    for (final m in memories) {
      groups.putIfAbsent(m.monthYear, () => []).add(m);
    }
    final widgets = <Widget>[];
    groups.forEach((month, items) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Text(month,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.ink)),
      ));
      widgets.add(GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _MemoryTile(
          memory: items[i],
          onTap: () => _openMemory(context, items[i]),
        ),
      ));
      widgets.add(const SizedBox(height: 18));
    });
    return widgets;
  }

  void _openMemory(BuildContext context, Memory memory) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MemoryDetail(memory: memory),
    );
  }

  Future<void> _createCollage(
      BuildContext context, WidgetRef ref, Child child) async {
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
    );
    try {
      final res = await ref.read(edgeFunctionsServiceProvider).invoke(
        'generate_birthday_collage',
        {'family_id': familyId, 'child_id': child.id},
      );
      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loader
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('${child.name}’s Birthday Collage 🎂'),
          content: Text(
              res['message']?.toString() ?? 'We’re getting the collage ready.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it')),
          ],
        ),
      );
    } catch (_) {
      if (context.mounted) {
        Navigator.pop(context);
        AppSnackbar.error(context, 'Couldn’t start the collage right now.');
      }
    }
  }

  Child? _upcomingBirthday(List<Child> children) {
    for (final c in children) {
      if (c.birthday != null && DateX.daysUntilBirthday(c.birthday!) <= 30) {
        return c;
      }
    }
    return null;
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({required this.memory, required this.onTap});
  final Memory memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MemoryPhoto(memory: memory),
            if (memory.milestoneType != MilestoneType.everyday)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Text(memory.milestoneType.emoji,
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThisDayLastYear extends StatelessWidget {
  const _ThisDayLastYear({required this.memory});
  final Memory memory;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: AspectRatio(
                aspectRatio: 16 / 9, child: MemoryPhoto(memory: memory)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('This day last year',
                          style: TextStyle(
                              color: AppColors.coral,
                              fontWeight: FontWeight.w800,
                              fontSize: 13)),
                      Text(memory.title ?? DateX.fullDate(memory.memoryDate),
                          style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthdayCollageCard extends StatelessWidget {
  const _BirthdayCollageCard({required this.child, required this.onCreate});
  final Child child;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final days =
        child.birthday == null ? 0 : DateX.daysUntilBirthday(child.birthday!);
    final turning =
        child.ageYears == null ? '' : ' turns ${child.ageYears! + 1}';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎂', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${child.name}$turning ${days == 0 ? 'today' : 'in $days days'}!',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Create a birthday collage from previous birthdays.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onCreate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 18, color: AppColors.coral),
                  SizedBox(width: 8),
                  Text('Create collage',
                      style: TextStyle(
                          color: AppColors.coral, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMemories extends StatelessWidget {
  const _EmptyMemories({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: EmptyView(
        emoji: '📸',
        title: 'Your HugBook is empty',
        message:
            'Save the little moments - first steps, silly faces, big milestones. They’re private to your family.',
        actionLabel: 'Add your first memory',
        onAction: onAdd,
      ),
    );
  }
}

class _MemoryDetail extends ConsumerWidget {
  const _MemoryDetail({required this.memory});
  final Memory memory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
            borderRadius: BorderRadius.circular(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 340),
              child: MemoryPhoto(memory: memory, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  '${memory.milestoneType.emoji} ${memory.milestoneType.label}',
                  style: const TextStyle(
                      color: AppColors.coral, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(DateX.fullDate(memory.memoryDate),
                  style: const TextStyle(color: AppColors.inkMuted)),
            ],
          ),
          if ((memory.title ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(memory.title!, style: Theme.of(context).textTheme.titleLarge),
          ],
          if ((memory.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(memory.description!,
                style: const TextStyle(color: AppColors.ink, height: 1.5)),
          ],
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(memoriesRepositoryProvider).delete(memory);
                ref.invalidate(memoriesProvider);
              } catch (_) {
                if (context.mounted) {
                  AppSnackbar.error(context, 'Couldn’t delete that memory.');
                }
              }
            },
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.coral),
            label: const Text('Delete memory',
                style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }
}
