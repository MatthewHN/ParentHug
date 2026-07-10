import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/enums.dart';
import '../../../models/subscription.dart';
import '../../../models/usage_limits.dart';
import '../../family/application/family_providers.dart';
import '../data/subscription_repository.dart';

/// Realtime keeps a Supabase manual-access change visible without waiting for
/// a RevenueCat refresh or an app relaunch.
final familySubscriptionProvider = StreamProvider<Subscription?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Stream.value(null);
  return ref.watch(subscriptionRepositoryProvider).watchFamily(id);
});

final usageProvider = FutureProvider<UsageLimits?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Future.value(null);
  return ref.watch(subscriptionRepositoryProvider).usage(id);
});

/// The family's effective plan.
///
/// Supabase is authoritative. RevenueCat only reports billing events to the
/// backend; it never grants access directly on the device.
final entitlementProvider = Provider<PlanTier>((ref) {
  final sub = ref.watch(familySubscriptionProvider).valueOrNull;
  return sub?.effectivePlan ?? PlanTier.free;
});

final hasProProvider = Provider<bool>(
  (ref) => ref.watch(entitlementProvider).rank >= PlanTier.pro.rank,
);
