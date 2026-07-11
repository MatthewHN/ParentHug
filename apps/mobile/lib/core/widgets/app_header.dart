import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import 'app_logo.dart';
import 'avatar.dart';

/// The shared top bar on every main tab: a blue brand header with the mark +
/// name on the left, and a tappable profile avatar on the right that opens the
/// Profile screen. Optional [actions] render just before the avatar.
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider).valueOrNull;
    return AppBar(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      shape: const Border(bottom: BorderSide(color: AppColors.hairline)),
      toolbarHeight: 66,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleSpacing: 18,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugMark(size: 40),
          const SizedBox(width: 11),
          const Text(
            'ParentHug',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 23,
              letterSpacing: -0.4,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
      actions: [
        ...?actions,
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 14),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hairline, width: 1.5),
              ),
              child: Avatar(
                name: profile?.displayName,
                imageUrl: profile?.avatarUrl,
                size: 34,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
