import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/enums.dart';
import '../../../models/subscription.dart';
import '../../auth/application/auth_controller.dart';
import '../../children/application/children_providers.dart';
import '../../children/presentation/widgets/child_editor_sheet.dart';
import '../../family/application/family_providers.dart';
import '../../family/data/family_repository.dart';
import '../../onboarding/presentation/widgets/invite_code_card.dart';
import '../../subscription/application/subscription_providers.dart';

/// A deliberately quiet account screen: the parent sees their account, their
/// family, and the value of ParentHug - never implementation details.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(currentUserProvider)?.email ?? 'No email available';
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    final members = ref.watch(familyMembersProvider).valueOrNull ?? const [];
    final subscription = ref.watch(familySubscriptionProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            _EmailCard(email: email),
            const SizedBox(height: 12),
            const _ReviewCard(),
            const SizedBox(height: 16),
            _PlanCard(subscription: subscription),
            const SizedBox(height: 28),
            SectionHeader(
              title: 'Children',
              subtitle: children.isEmpty
                  ? 'Add a profile so support can feel more personal.'
                  : '${children.length} ${children.length == 1 ? 'profile' : 'profiles'} in your family',
              actionLabel: 'Add child',
              onAction: () => showChildEditor(context),
            ),
            const SizedBox(height: 10),
            if (children.isEmpty)
              AppCard(
                onTap: () => showChildEditor(context),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Add your first child',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.inkFaint),
                  ],
                ),
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
                                    ? (child.temperament ?? 'Add details')
                                    : '${child.ageLabel} old${child.temperament != null ? ' · ${child.temperament}' : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 28),
            const SectionHeader(title: 'Your family'),
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
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(members[i].displayName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
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
            const SizedBox(height: 30),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: 10),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _AccountAction(
                    icon: Icons.logout_rounded,
                    label: 'Sign out',
                    onTap: () =>
                        ref.read(authControllerProvider.notifier).signOut(),
                  ),
                  const Divider(height: 1),
                  _AccountAction(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete account',
                    destructive: true,
                    onTap: () => _confirmAccountDeletion(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('ParentHug v1.0.0',
                  style: TextStyle(color: AppColors.inkFaint, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAccountDeletion(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'This permanently removes your account and associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep account'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.coral),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.error(
            context, 'We could not delete your account. Please try again.');
      }
    }
  }
}

class _EmailCard extends StatelessWidget {
  const _EmailCard({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.mail_outline_rounded,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Signed in as',
                      style:
                          TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

  Future<void> _requestReview() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing();
    }
  }

  @override
  Widget build(BuildContext context) => AppCard(
        color: AppColors.yellowSoft,
        border: Border.all(color: const Color(0xFFF6D98C)),
        onTap: _requestReview,
        child: const Row(
          children: [
            Icon(Icons.favorite_rounded, color: AppColors.coral),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'If ParentHug has been useful, please leave a review. It helps us help more families.',
                style: TextStyle(fontWeight: FontWeight.w600, height: 1.35),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.inkMuted),
          ],
        ),
      );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.subscription});
  final Subscription? subscription;

  @override
  Widget build(BuildContext context) {
    final isTrial = subscription?.hasActiveTrial ?? false;
    final isSubscribed = subscription?.isSubscribed ?? false;
    final isManual = subscription?.hasManualAccess ?? false;
    final title = isTrial
        ? 'Your free trial'
        : isSubscribed
            ? 'You’re subscribed'
            : isManual
                ? 'Your family has full access'
                : 'Keep your family supported';
    final message = isTrial
        ? '${subscription!.trialDaysRemaining} ${subscription!.trialDaysRemaining == 1 ? 'day' : 'days'} left. A little more support can make a big difference at home.'
        : isSubscribed
            ? 'Thank you for investing in your family. We’re glad to be in your corner.'
            : isManual
                ? 'You have access to every ParentHug tool, whenever you need it.'
                : 'Your trial has ended. ParentHug is here when your family needs a steadier next step.';
    final needsPlan = !isTrial && !isSubscribed && !isManual;

    return Stack(
      children: [
        Positioned.fill(
          left: 8,
          top: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isTrial ? AppColors.yellow : AppColors.coral,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 14,
                  offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.workspace_premium_outlined, color: Colors.white),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(message,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.35)),
              if (needsPlan) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.push(AppRoutes.paywall),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  child: const Text('View subscription options'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InviteSection extends ConsumerWidget {
  const _InviteSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invite = ref.watch(latestInviteProvider).valueOrNull;
    if (invite != null) return InviteCodeCard(code: invite.code);
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
      child: const Row(
        children: [
          Icon(Icons.person_add_alt_1_outlined, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text('Invite a co-parent',
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

class _AccountAction extends StatelessWidget {
  const _AccountAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.coral : AppColors.ink;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w700))),
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.55)),
          ],
        ),
      ),
    );
  }
}
