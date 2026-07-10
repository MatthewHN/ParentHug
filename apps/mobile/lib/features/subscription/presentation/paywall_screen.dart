import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../services/revenuecat_service.dart';
import '../application/subscription_providers.dart';

/// Product identifier for the single Pro plan (yearly). Must match the product
/// created in App Store Connect / Google Play and attached to the `pro`
/// entitlement in RevenueCat.
const _proProductId = 'parenthug_pro_yearly';

/// Static display copy. When RevenueCat is configured the real localized price
/// and trial come from the store; these are the pre-billing fallbacks.
const _proPrice = r'$149';
const _trialDays = 3;
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

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await RevenueCatService.instance.offerings();
    if (mounted) setState(() => _offerings = offerings);
  }

  Package? _proPackage() {
    final all = _offerings?.all.values ?? const [];
    for (final offering in all) {
      for (final pkg in offering.availablePackages) {
        if (pkg.storeProduct.identifier == _proProductId) return pkg;
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
    final pkg = _proPackage();
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
                    'One subscription covers your whole family - unlimited support in every hard moment. Try it free for $_trialDays days.',
                    style: TextStyle(
                        color: AppColors.inkMuted, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  _ProCard(busy: _busy, onSelect: _purchase),
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton(
                      onPressed: _busy ? null : _restore,
                      child: const Text('Restore purchases'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your $_trialDays-day free trial converts to a $_proPrice/year subscription unless cancelled at least 24 hours before it ends. Manage or cancel anytime in your app store settings. Prices shown in USD; local prices may vary.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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

class _ProCard extends StatelessWidget {
  const _ProCard({required this.busy, required this.onSelect});

  final bool busy;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🫂', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              const Text('ParentHug Pro',
                  style:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text('$_trialDays-day free trial',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_proPrice,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: AppColors.ink)),
              Text('/year',
                  style: TextStyle(
                      color: AppColors.inkMuted, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Free for $_trialDays days, then $_proPrice/year.',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
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
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Start $_trialDays-day free trial',
            loading: busy,
            gradient: AppColors.hugGradient,
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }
}
