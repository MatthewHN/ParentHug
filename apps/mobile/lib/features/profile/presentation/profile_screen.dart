import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/enums.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_editor_sheet.dart';
import '../../family/application/family_providers.dart';
import '../../family/data/family_repository.dart';
import '../../onboarding/presentation/widgets/invite_code_card.dart';
import '../../subscription/application/subscription_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider).valueOrNull;
    final email = ref.watch(currentUserProvider)?.email ?? '';
    final family = ref.watch(currentFamilyProvider);
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final members = ref.watch(familyMembersProvider).valueOrNull ?? const [];
    final plan = ref.watch(entitlementProvider);
    final usage = ref.watch(usageProvider).valueOrNull;
    final maxChildren = ref.watch(maxChildrenProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // ---- Profile header ----
            AppCard(
              child: Row(
                children: [
                  Avatar(
                      name: profile?.displayName ?? 'Parent',
                      imageUrl: profile?.avatarUrl,
                      size: 58),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile?.displayName ?? 'Parent',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(email,
                            style: const TextStyle(color: AppColors.inkMuted)),
                        if (family != null) ...[
                          const SizedBox(height: 2),
                          Text(family.name,
                              style: const TextStyle(
                                  color: AppColors.inkFaint, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editName(context, ref, profile?.fullName ?? ''),
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.inkFaint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---- Plan card ----
            _PlanCard(plan: plan, hugsRemaining: usage?.hugsRemaining),
            const SizedBox(height: 20),

            // ---- Children ----
            SectionHeader(
              title: 'Children',
              emoji: '🧒',
              subtitle: '${children.length} of $maxChildren on your plan',
              actionLabel: '+ Add',
              onAction: () {
                if (children.length >= maxChildren) {
                  AppSnackbar.show(context,
                      'Upgrade your plan to add more children.');
                  context.push(AppRoutes.paywall);
                } else {
                  showChildEditor(context);
                }
              },
            ),
            const SizedBox(height: 10),
            if (children.isEmpty)
              const AppCard(
                child: Text('No children added yet.',
                    style: TextStyle(color: AppColors.inkMuted)),
              )
            else
              for (final child in children)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => showChildEditor(context, existing: child),
                    child: Row(
                      children: [
                        Avatar(name: child.name, imageUrl: child.avatarUrl),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(child.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                              Text(
                                child.birthday == null
                                    ? (child.temperament ?? 'Tap to add details')
                                    : '${child.ageLabel} old${child.temperament != null ? ' · ${child.temperament}' : ''}',
                                style: const TextStyle(
                                    color: AppColors.inkMuted, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.inkFaint),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 20),

            // ---- Family members ----
            SectionHeader(title: 'Your family', emoji: '👨‍👩‍👧'),
            const SizedBox(height: 10),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < members.length; i++) ...[
                    if (i > 0) const Divider(height: 20),
                    Row(
                      children: [
                        Avatar(
                            name: members[i].displayName,
                            imageUrl: members[i].profile?.avatarUrl,
                            size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(members[i].displayName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                        ),
                        _RoleBadge(role: members[i].role),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _InviteSection(),
            const SizedBox(height: 20),

            // ---- Tools ----
            SectionHeader(title: 'Tools', emoji: '🧰'),
            const SizedBox(height: 10),
            _Tile(
              icon: Icons.healing_outlined,
              color: AppColors.coral,
              title: 'Repair Mode',
              subtitle: 'Reconnect after a hard moment',
              onTap: () => context.push(AppRoutes.repair),
            ),
            _Tile(
              icon: Icons.workspace_premium_outlined,
              color: AppColors.yellow,
              title: 'Plans & pricing',
              subtitle: 'See what ParentHug Plus unlocks',
              onTap: () => context.push(AppRoutes.paywall),
            ),
            _Tile(
              icon: Icons.credit_card_outlined,
              color: AppColors.primary,
              title: 'Manage subscription',
              subtitle: 'Billing is handled by the App Store / Google Play',
              onTap: () => _manageSubscription(context),
            ),
            const SizedBox(height: 20),

            // ---- Sign out ----
            TextButton.icon(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout_rounded, color: AppColors.coral),
              label: const Text('Sign out',
                  style: TextStyle(
                      color: AppColors.coral, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('ParentHug v1.0.0',
                  style: TextStyle(color: AppColors.inkFaint, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _editName(BuildContext context, WidgetRef ref, String current) {
    final controller = TextEditingController(text: current);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(authRepositoryProvider)
                  .updateProfile(fullName: controller.text.trim());
              ref.invalidate(myProfileProvider);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _manageSubscription(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage subscription'),
        content: const Text(
          'ParentHug subscriptions are billed through your app store:\n\n'
          '• iOS: Settings → your Apple ID → Subscriptions\n'
          '• Android: Play Store → Payments & subscriptions\n\n'
          'Changes and cancellations are handled there.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, this.hugsRemaining});
  final PlanTier plan;
  final int? hugsRemaining;

  @override
  Widget build(BuildContext context) {
    final isFree = plan == PlanTier.free;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isFree ? AppColors.skyGradient : AppColors.warmGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(plan.label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isFree
                ? 'You’re on the free plan${hugsRemaining != null ? ' · $hugsRemaining Hugs left this month' : ''}.'
                : 'Thanks for supporting ParentHug 💛 Both parents are covered.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
          ),
          if (isFree) ...[
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => context.push(AppRoutes.paywall),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99)),
                child: const Text('Unlock everything',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InviteSection extends ConsumerWidget {
  const _InviteSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invite = ref.watch(latestInviteProvider).valueOrNull;
    if (invite != null) {
      return InviteCodeCard(code: invite.code);
    }
    return AppCard(
      onTap: () async {
        final familyId = ref.read(currentFamilyIdProvider);
        if (familyId == null) return;
        try {
          await ref.read(familyRepositoryProvider).createInvite(familyId);
          ref.invalidate(latestInviteProvider);
        } catch (_) {
          if (context.mounted) {
            AppSnackbar.error(context, 'Couldn’t create an invite.');
          }
        }
      },
      child: Row(
        children: const [
          Icon(Icons.person_add_alt_1_outlined, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text('Invite your co-parent',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.inkFaint),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final MemberRole role;
  @override
  Widget build(BuildContext context) {
    final color = role == MemberRole.admin ? AppColors.primary : AppColors.mint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(role.label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.inkMuted, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
