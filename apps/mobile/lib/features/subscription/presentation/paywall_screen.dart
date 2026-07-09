import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../models/enums.dart';
import '../../../services/revenuecat_service.dart';
import '../application/subscription_providers.dart';

/// Static pricing catalog (used for display; real prices come from the store
/// when RevenueCat is configured).
class _Plan {
  const _Plan(this.tier, this.emoji, this.monthly, this.yearly, this.features);
  final PlanTier tier;
  final String emoji;
  final String monthly;
  final String yearly;
  final List<String> features;
}

const _plans = [
  _Plan(PlanTier.plus, '🫶', r'$9.99', r'$59.99', [
    'Unlimited Hug Button',
    'Repair Mode',
    'Full Family Board',
    'Today’s ParentHug, daily',
    '2 parent accounts included',
    '2 child profiles',
    'Private Memories album',
  ]),
  _Plan(PlanTier.family, '🌟', r'$14.99', r'$89.99', [
    'Everything in Plus',
    'Up to 4 child profiles',
    'Extra caregivers',
    'Advanced memories',
    'Weekly family recap',
  ]),
];

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _yearly = true;
  bool _busy = false;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await RevenueCatService.instance.offerings();
    if (mounted) setState(() => _offerings = offerings);
  }

  Package? _packageFor(PlanTier tier) {
    final id = 'parenthug_${tier.value}_${_yearly ? 'yearly' : 'monthly'}';
    final all = _offerings?.all.values ?? const [];
    for (final offering in all) {
      for (final pkg in offering.availablePackages) {
        if (pkg.storeProduct.identifier == id) return pkg;
      }
    }
    return null;
  }

  Future<void> _purchase(PlanTier tier) async {
    if (!RevenueCatService.instance.isConfigured) {
      AppSnackbar.show(context,
          'In-app purchases activate once billing is configured. You have full demo access for now.');
      return;
    }
    final pkg = _packageFor(tier);
    if (pkg == null) {
      AppSnackbar.error(context, 'That plan isn’t available yet.');
      return;
    }
    setState(() => _busy = true);
    try {
      await RevenueCatService.instance.purchase(pkg);
      ref.invalidate(familySubscriptionProvider);
      if (mounted) {
        AppSnackbar.success(context, 'Welcome to ParentHug! 💛');
        context.pop();
      }
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code != PurchasesErrorCode.purchaseCancelledError && mounted) {
        AppSnackbar.error(context, 'Purchase didn’t complete.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _busy = true);
    try {
      await RevenueCatService.instance.restore();
      ref.invalidate(familySubscriptionProvider);
      if (mounted) AppSnackbar.success(context, 'Purchases restored.');
    } catch (_) {
      if (mounted) AppSnackbar.show(context, 'Nothing to restore.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  const Text('🫂', style: TextStyle(fontSize: 46)),
                  const SizedBox(height: 12),
                  Text('Unlock calmer parenting',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'One subscription covers your family - unlimited support in every hard moment.',
                    style: TextStyle(
                        color: AppColors.inkMuted, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  _BillingToggle(
                    yearly: _yearly,
                    onChanged: (v) => setState(() => _yearly = v),
                  ),
                  const SizedBox(height: 18),
                  for (final plan in _plans) ...[
                    _PlanCard(
                      plan: plan,
                      yearly: _yearly,
                      busy: _busy,
                      highlighted: plan.tier == PlanTier.plus,
                      onSelect: () => _purchase(plan.tier),
                    ),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton(
                      onPressed: _busy ? null : _restore,
                      child: const Text('Restore purchases'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Subscriptions renew automatically until cancelled. Manage or cancel anytime in your app store settings. Prices shown in USD; local prices may vary.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.inkFaint, fontSize: 11.5, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingToggle extends StatelessWidget {
  const _BillingToggle({required this.yearly, required this.onChanged});
  final bool yearly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.hairline, width: 1.5),
      ),
      child: Row(
        children: [
          _seg('Monthly', !yearly, () => onChanged(false)),
          _seg('Yearly · save 40%', yearly, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _seg(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.inkMuted,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.yearly,
    required this.busy,
    required this.highlighted,
    required this.onSelect,
  });

  final _Plan plan;
  final bool yearly;
  final bool busy;
  final bool highlighted;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final price = yearly ? plan.yearly : plan.monthly;
    final period = yearly ? '/year' : '/month';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.hairline,
          width: highlighted ? 2 : 1.5,
        ),
        boxShadow: highlighted ? AppShadows.soft : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(plan.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(plan.tier.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 18)),
              const Spacer(),
              if (highlighted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text('Most popular',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: AppColors.ink)),
              Text(period,
                  style: const TextStyle(
                      color: AppColors.inkMuted, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          for (final f in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.mint, size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(f,
                          style: const TextStyle(
                              color: AppColors.ink, fontSize: 14.5))),
                ],
              ),
            ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Choose ${plan.tier == PlanTier.plus ? 'Plus' : 'Family'}',
            loading: busy,
            gradient: highlighted
                ? AppColors.hugGradient
                : AppColors.skyGradient,
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }
}
