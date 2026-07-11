import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../services/revenuecat_service.dart';
import '../application/subscription_providers.dart';

/// Product identifiers for the Pro plans. Both map to the same `pro`
/// entitlement in RevenueCat — they only differ in billing period/price. These
/// must match the products created in App Store Connect / Google Play.
const _yearlyProductId = 'parenthug_pro_yearly';
const _semiannualProductId = 'parenthug_pro_6month';

const _trialDays = 3;

/// Static display copy. When RevenueCat is configured the real localized price
/// comes from the store; these are the pre-billing fallbacks.
const _plans = <_Plan>[
  _Plan(
    productId: _yearlyProductId,
    title: '12 months',
    price: r'$149',
    periodShort: 'year',
    perMonth: r'≈ $12.42 / mo',
    badge: 'Best value',
  ),
  _Plan(
    productId: _semiannualProductId,
    title: '6 months',
    price: r'$99.99',
    periodShort: '6 months',
    perMonth: r'≈ $16.67 / mo',
  ),
];

const _proFeatures = [
  'Unlimited Hug Button',
  'Repair Mode for after hard moments',
  'Full Family Board',
  'Today’s ParentHug, every day',
  'Your partner & caregivers included',
  'Up to 20 child profiles',
  'Private Memories album',
];

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _busy = false;
  Offerings? _offerings;
  String _selectedProductId = _yearlyProductId;

  _Plan get _selectedPlan =>
      _plans.firstWhere((p) => p.productId == _selectedProductId);

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await RevenueCatService.instance.offerings();
    if (mounted) setState(() => _offerings = offerings);
  }

  Package? _packageFor(String productId) {
    final all = _offerings?.all.values ?? const [];
    for (final offering in all) {
      for (final pkg in offering.availablePackages) {
        if (pkg.storeProduct.identifier == productId) return pkg;
      }
    }
    return null;
  }

  Future<void> _purchase() async {
    if (!RevenueCatService.instance.isConfigured) {
      AppSnackbar.show(context,
          'In-app purchases activate once billing is configured. You have full demo access for now.');
      return;
    }
    final pkg = _packageFor(_selectedProductId);
    if (pkg == null) {
      AppSnackbar.error(context, 'The plan isn’t available yet.');
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
    final plan = _selectedPlan;
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
                    'One subscription covers your whole family — unlimited support in every hard moment. Try it free for $_trialDays days.',
                    style: TextStyle(
                        color: AppColors.inkMuted, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  const _FeatureList(),
                  const SizedBox(height: 20),
                  const Text('Choose your plan',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  for (final p in _plans) ...[
                    _PlanOption(
                      plan: p,
                      selected: p.productId == _selectedProductId,
                      onTap: () =>
                          setState(() => _selectedProductId = p.productId),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 4),
                  PrimaryButton(
                    label: 'Start $_trialDays-day free trial',
                    loading: _busy,
                    gradient: AppColors.hugGradient,
                    onPressed: _purchase,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: _busy ? null : _restore,
                      child: const Text('Restore purchases'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your $_trialDays-day free trial converts to a ${plan.price}/${plan.periodShort} subscription unless cancelled at least 24 hours before it ends. Manage or cancel anytime in your app store settings. Prices shown in USD; local prices may vary.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.inkFaint, fontSize: 11.5, height: 1.4),
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

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('🫂', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Everything in ParentHug Pro',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),
          for (final f in _proFeatures)
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
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.hairline,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : AppColors.inkFaint,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(plan.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      if (plan.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.mint,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(plan.badge!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10.5)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(plan.perMonth,
                      style: const TextStyle(
                          color: AppColors.inkMuted, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(plan.price,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: AppColors.ink)),
                Text('/ ${plan.periodShort}',
                    style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Plan {
  const _Plan({
    required this.productId,
    required this.title,
    required this.price,
    required this.periodShort,
    required this.perMonth,
    this.badge,
  });

  final String productId;
  final String title;
  final String price;
  final String periodShort;
  final String perMonth;
  final String? badge;
}
