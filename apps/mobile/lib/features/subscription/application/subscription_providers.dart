import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../models/enums.dart';
import '../../../models/subscription.dart';
import '../../../models/usage_limits.dart';
import '../../family/application/family_providers.dart';
import '../data/subscription_repository.dart';

final familySubscriptionProvider = FutureProvider<Subscription?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Future.value(null);
  return ref.watch(subscriptionRepositoryProvider).forFamily(id);
});

final usageProvider = FutureProvider<UsageLimits?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Future.value(null);
  return ref.watch(subscriptionRepositoryProvider).usage(id);
});

/// The family's effective plan.
///
/// When RevenueCat isn't configured we unlock everything so the product can be
/// demoed end-to-end pre-billing. Once configured, the DB subscription (kept in
/// sync by the RevenueCat webhook) is the source of truth.
final entitlementProvider = Provider<PlanTier>((ref) {
  if (!Env.isRevenueCatConfigured) return PlanTier.family;
  final sub = ref.watch(familySubscriptionProvider).valueOrNull;
  return sub?.effectivePlan ?? PlanTier.free;
});

final hasPlusProvider = Provider<bool>(
  (ref) => ref.watch(entitlementProvider).rank >= PlanTier.plus.rank,
);

final hasFamilyPlanProvider = Provider<bool>(
  (ref) => ref.watch(entitlementProvider) == PlanTier.family,
);

/// Max child profiles allowed by the current plan.
final maxChildrenProvider = Provider<int>((ref) {
  switch (ref.watch(entitlementProvider)) {
    case PlanTier.free:
      return 1;
    case PlanTier.plus:
      return 2;
    case PlanTier.family:
      return 4;
  }
});
