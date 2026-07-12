import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/states.dart';
import '../../../models/daily_briefing.dart';
import '../../board/application/board_providers.dart';
import '../../children/presentation/widgets/child_selector.dart';
import '../../memories/application/memories_providers.dart';
import '../../memories/presentation/widgets/memory_image.dart';
import '../application/today_providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefing = ref.watch(todayBriefingProvider);

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(todayBriefingProvider);
            ref.invalidate(recentBoardItemsProvider);
            ref.invalidate(memoriesProvider);
            await ref.read(todayBriefingProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              const ChildSelector(),
              const SizedBox(height: 18),
              briefing.when(
                loading: () => const _BriefingSkeleton(),
                error: (e, _) => ErrorView(
                  title: 'Couldn’t load today',
                  message: 'Pull to refresh, or try again.',
                  onRetry: () => ref.invalidate(todayBriefingProvider),
                ),
                data: (b) => _BriefingBody(briefing: b),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BriefingBody extends ConsumerWidget {
  const _BriefingBody({required this.briefing});
  final DailyBriefing briefing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryOfDay = ref.watch(memoryOfDayProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Today's ParentHug hero
        GradientCard(
          gradient: AppColors.skyGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroLabel('TODAY’S PARENTHUG'),
              const SizedBox(height: 10),
              Text(
                briefing.tinyParentingMove.isEmpty
                    ? 'Take one calm minute for connection today.'
                    : briefing.tinyParentingMove,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.35,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Say this today
        if (briefing.sayThisToday.isNotEmpty) ...[
          _SayThisCard(text: briefing.sayThisToday),
          const SizedBox(height: 14),
        ],

        // Memory of the day
        _MemoryOfDay(briefing: briefing, memory: memoryOfDay),
      ],
    );
  }

  Widget _heroLabel(String text) => Text(text,
      style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.5));
}

class _SayThisCard extends StatelessWidget {
  const _SayThisCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💬', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text('Say this today',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  AppSnackbar.success(context, 'Copied');
                },
                child: const Icon(Icons.copy_rounded,
                    size: 18, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text,
              style: const TextStyle(
                  color: AppColors.ink,
                  height: 1.5,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

class _MemoryOfDay extends StatelessWidget {
  const _MemoryOfDay({required this.briefing, required this.memory});
  final DailyBriefing briefing;
  final dynamic memory; // Memory?

  @override
  Widget build(BuildContext context) {
    if (memory != null) {
      return AppCard(
        padding: EdgeInsets.zero,
        onTap: () => context.go(AppRoutes.memories),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              child: MemoryPhoto(
                memory: memory,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✨ Memory of the day',
                      style: TextStyle(
                          color: AppColors.coral,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(memory.displayTitle,
                      style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go(AppRoutes.memories),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Image.asset('assets/kid.jpg',
                width: double.infinity, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label(),
                const SizedBox(height: 4),
                Text(
                  briefing.memoryOfDay.isEmpty
                      ? 'Your next memory belongs here.'
                      : briefing.memoryOfDay,
                  style: const TextStyle(
                      color: AppColors.ink, height: 1.5, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label() => Row(
        children: const [
          Text('📷', style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text('Memory of the day',
              style: TextStyle(
                  color: Color(0xFFB07CF6),
                  fontWeight: FontWeight.w800,
                  fontSize: 14)),
        ],
      );
}

class _BriefingSkeleton extends StatelessWidget {
  const _BriefingSkeleton();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              height: i == 0 ? 120 : 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
