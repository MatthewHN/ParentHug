import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_x.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/states.dart';
import '../../../models/board_item.dart';
import '../../../models/daily_briefing.dart';
import '../../auth/data/auth_repository.dart';
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
    final name = ref.watch(myProfileProvider).valueOrNull?.firstName ?? 'there';

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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _Greeting(name: name),
              const SizedBox(height: 16),
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

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateX.fullDate(DateTime.now()).toUpperCase(),
            style: const TextStyle(
                color: AppColors.inkFaint,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('${DateX.greetingForNow()}, $name 👋',
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class _BriefingBody extends ConsumerWidget {
  const _BriefingBody({required this.briefing});
  final DailyBriefing briefing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentBoardItemsProvider).valueOrNull ?? const [];
    final lastYear = ref.watch(thisDayLastYearProvider);

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

        // Before You Walk In
        if (briefing.beforeYouWalkIn.isNotEmpty) ...[
          _BeforeYouWalkIn(text: briefing.beforeYouWalkIn),
          const SizedBox(height: 14),
        ],

        // What's going on
        if (briefing.recentContext.isNotEmpty || briefing.watchFor.isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardLabel('🧭', 'What’s going on', AppColors.primary),
                const SizedBox(height: 10),
                if (briefing.recentContext.isNotEmpty)
                  Text(briefing.recentContext,
                      style: const TextStyle(
                          color: AppColors.ink, height: 1.5, fontSize: 15)),
                if (briefing.watchFor.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.yellowSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(briefing.watchFor,
                              style: const TextStyle(
                                  color: AppColors.ink, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 14),

        // Say this today
        if (briefing.sayThisToday.isNotEmpty) ...[
          _SayThisCard(text: briefing.sayThisToday),
          const SizedBox(height: 14),
        ],

        // Recent Family Board updates
        _RecentBoard(items: recent),
        const SizedBox(height: 14),

        // Memory of the day
        _MemoryOfDay(briefing: briefing, lastYear: lastYear),
        const SizedBox(height: 14),

        // Hug shortcut
        GradientCard(
          gradient: AppColors.hugGradient,
          onTap: () => context.go(AppRoutes.hug),
          child: Row(
            children: [
              const Text('🫂', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hard moment right now?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    SizedBox(height: 2),
                    Text('Tap for the next right words.',
                        style: TextStyle(color: Colors.white, height: 1.3)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroLabel(String text) => Text(text,
      style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 1.5));

  Widget _cardLabel(String emoji, String text, Color color) => Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 14)),
        ],
      );
}

class _BeforeYouWalkIn extends StatelessWidget {
  const _BeforeYouWalkIn({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.coralSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🚪', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text('Before you walk in',
                  style: TextStyle(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  AppSnackbar.success(context, 'Copied');
                },
                child: const Icon(Icons.copy_rounded,
                    size: 18, color: AppColors.coral),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text,
              style: const TextStyle(
                  color: AppColors.ink, height: 1.5, fontSize: 15)),
        ],
      ),
    );
  }
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

class _RecentBoard extends StatelessWidget {
  const _RecentBoard({required this.items});
  final List<BoardItem> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📌', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text('From your Family Board',
                  style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(AppRoutes.board),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                  'No updates yet - add a note to keep your support circle in sync.',
                  style: TextStyle(color: AppColors.inkMuted)),
            )
          else
            for (final item in items.take(3))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4, right: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.category(item.category.value),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.category.emoji}  ${item.title}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink)),
                          if ((item.body ?? '').isNotEmpty)
                            Text(item.body!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.inkMuted, fontSize: 13.5)),
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

class _MemoryOfDay extends StatelessWidget {
  const _MemoryOfDay({required this.briefing, required this.lastYear});
  final DailyBriefing briefing;
  final dynamic lastYear; // Memory?

  @override
  Widget build(BuildContext context) {
    if (lastYear != null) {
      return AppCard(
        padding: EdgeInsets.zero,
        onTap: () => context.go(AppRoutes.memories),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: MemoryPhoto(memory: lastYear),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✨ This day last year',
                      style: TextStyle(
                          color: AppColors.coral,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(lastYear.title ?? 'A moment worth remembering',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(),
          const SizedBox(height: 10),
          Text(
            briefing.memoryOfDay.isEmpty
                ? 'Capture one small moment today for your HugBook.'
                : briefing.memoryOfDay,
            style: const TextStyle(
                color: AppColors.ink, height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.go(AppRoutes.memories),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Add a memory'),
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
