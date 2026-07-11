import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_sheet.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_x.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/buttons.dart';
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

class MemoriesScreen extends ConsumerStatefulWidget {
  const MemoriesScreen({super.key});

  @override
  ConsumerState<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends ConsumerState<MemoriesScreen> {
  final _searchController = TextEditingController();
  bool _searching = false;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() => setState(() {
        _searching = !_searching;
        if (!_searching) {
          _searchController.clear();
          _query = '';
        }
      });

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
      showAppSheet<void>(
        context: context,
        builder: (_) => MemoryUploadSheet(bytes: bytes, fileExt: ext),
      );
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Couldn’t open your photos.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final memoriesAsync = ref.watch(memoriesProvider);
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final upcoming = _upcomingBirthday(children);

    return Scaffold(
      appBar: const AppHeader(),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_memories',
        onPressed: () => _addMemory(context, ref),
        backgroundColor: AppColors.primary,
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
            final query = _query.trim().toLowerCase();
            final filteredMemories = query.isEmpty
                ? memories
                : memories
                    .where((memory) =>
                        memory.displayTitle.toLowerCase().contains(query))
                    .toList();
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => ref.invalidate(memoriesProvider),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
                children: [
                  const ChildSelector(),
                  const SizedBox(height: 16),
                  if (_searching) ...[
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) => setState(() => _query = value),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search memory titles',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (upcoming != null) ...[
                    _BirthdayCollageCard(
                      child: upcoming,
                      onCreate: () => _createCollage(context, ref, upcoming),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (memories.isEmpty)
                    _EmptyMemories(onAdd: () => _addMemory(context, ref))
                  else if (filteredMemories.isEmpty)
                    const _NoMatchingMemories()
                  else
                    ..._buildTimeline(context, filteredMemories),
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
    var isFirstGroup = true;
    groups.forEach((month, items) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(month,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.ink)),
            ),
            if (isFirstGroup)
              IconButton(
                tooltip:
                    _searching ? 'Close title search' : 'Search memory titles',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                    _searching ? Icons.close_rounded : Icons.search_rounded),
                onPressed: _toggleSearch,
              ),
          ],
        ),
      ));
      widgets.add(GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _MemoryTile(
          memory: items[i],
          onTap: () => _openMemory(context, items[i]),
        ),
      ));
      widgets.add(const SizedBox(height: 18));
      isFirstGroup = false;
    });
    return widgets;
  }

  void _openMemory(BuildContext context, Memory memory) {
    showAppSheet<void>(
      context: context,
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
    return Semantics(
      button: true,
      label: memory.displayTitle,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
            ),
            const SizedBox(height: 6),
            Text(
              memory.displayTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ],
        ),
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

class _NoMatchingMemories extends StatelessWidget {
  const _NoMatchingMemories();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: EmptyView(
          emoji: '🔎',
          title: 'No matching memories',
          message: 'Try a different word from the memory title.',
        ),
      );
}

class _MemoryDetail extends ConsumerStatefulWidget {
  const _MemoryDetail({required this.memory});
  final Memory memory;

  @override
  ConsumerState<_MemoryDetail> createState() => _MemoryDetailState();
}

class _MemoryDetailState extends ConsumerState<_MemoryDetail> {
  bool _busy = false;

  Memory get memory => widget.memory;

  Future<void> _download() async {
    setState(() => _busy = true);
    try {
      final bytes = await ref
          .read(memoriesRepositoryProvider)
          .downloadBytes(memory.storagePath);
      await Gal.putImageBytes(bytes);
      if (mounted) AppSnackbar.success(context, 'Saved to your photos');
    } on GalException catch (e) {
      if (mounted) {
        AppSnackbar.error(
            context,
            e.type == GalExceptionType.accessDenied
                ? 'Allow photo access to save memories.'
                : 'Couldn’t save that photo.');
      }
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Couldn’t save that photo.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final bytes = await ref
          .read(memoriesRepositoryProvider)
          .downloadBytes(memory.storagePath);
      final ext = memory.storagePath.split('.').last;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/memory.$ext');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], text: memory.title);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Couldn’t share that photo.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    Navigator.pop(context);
    try {
      await ref.read(memoriesRepositoryProvider).delete(memory);
      ref.invalidate(memoriesProvider);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Couldn’t delete that memory.');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(memory.displayTitle,
                style: Theme.of(context).textTheme.titleLarge),
          ],
          if ((memory.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(memory.description!,
                style: const TextStyle(color: AppColors.ink, height: 1.5)),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Download',
                  icon: Icons.download_rounded,
                  onPressed: _busy ? null : _download,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SecondaryButton(
                  label: 'Share',
                  icon: Icons.ios_share_rounded,
                  onPressed: _busy ? null : _share,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _busy ? null : _delete,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.coral),
              label: const Text('Delete memory',
                  style: TextStyle(color: AppColors.coral)),
            ),
          ),
        ],
      ),
    );
  }
}
