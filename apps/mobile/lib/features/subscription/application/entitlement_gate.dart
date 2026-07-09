import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../models/enums.dart';
import 'subscription_providers.dart';

/// Returns true if the family's plan meets [min]. Otherwise opens the paywall
/// and returns false. Use to gate premium actions before running them.
bool ensureEntitled(
  BuildContext context,
  WidgetRef ref, {
  PlanTier min = PlanTier.plus,
}) {
  final plan = ref.read(entitlementProvider);
  if (plan.rank >= min.rank) return true;
  context.push(AppRoutes.paywall);
  return false;
}
