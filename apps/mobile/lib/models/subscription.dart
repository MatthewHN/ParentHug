import '_parse.dart';
import 'enums.dart';

class Subscription {
  const Subscription({
    required this.id,
    required this.familyId,
    this.userId,
    this.plan = PlanTier.free,
    this.status = 'inactive',
    this.isActive = false,
    this.productId,
    this.rcEntitlement,
    this.expiresAt,
    this.trialStartedAt,
    this.trialEndsAt,
    this.manualPlan,
    this.manualAccessExpiresAt,
  });

  final String id;
  final String familyId;
  final String? userId;
  final PlanTier plan;
  final String status;
  final bool isActive;
  final String? productId;
  final String? rcEntitlement;
  final DateTime? expiresAt;
  final DateTime? trialStartedAt;
  final DateTime? trialEndsAt;
  final PlanTier? manualPlan;
  final DateTime? manualAccessExpiresAt;

  bool get hasManualAccess =>
      manualPlan != null &&
      (manualAccessExpiresAt == null ||
          manualAccessExpiresAt!.isAfter(DateTime.now()));

  bool get hasActiveTrial =>
      status == 'trial' &&
      trialEndsAt != null &&
      trialEndsAt!.isAfter(DateTime.now());

  int get trialDaysRemaining {
    if (!hasActiveTrial) return 0;
    final hours = trialEndsAt!.difference(DateTime.now()).inHours;
    return (hours / 24).ceil().clamp(1, 365);
  }

  bool get isSubscribed =>
      !hasManualAccess && !hasActiveTrial && isActive && effectivePlan.isPaid;

  /// Effective plan: only a currently-active, unexpired subscription counts.
  PlanTier get effectivePlan {
    if (hasManualAccess) return manualPlan!;
    if (hasActiveTrial) return PlanTier.pro;
    if (!isActive) return PlanTier.free;
    if (expiresAt != null && expiresAt!.isBefore(DateTime.now())) {
      return PlanTier.free;
    }
    return plan;
  }

  factory Subscription.fromMap(Map<String, dynamic> m) => Subscription(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        userId: m['user_id'] as String?,
        plan: PlanTier.from(m['plan'] as String?),
        status: (m['status'] as String?) ?? 'inactive',
        isActive: asBool(m['is_active']),
        productId: m['product_id'] as String?,
        rcEntitlement: m['rc_entitlement'] as String?,
        expiresAt: asDate(m['expires_at']),
        trialStartedAt: asDate(m['trial_started_at']),
        trialEndsAt: asDate(m['trial_ends_at']),
        manualPlan: m['manual_plan'] == null
            ? null
            : PlanTier.from(m['manual_plan'] as String?),
        manualAccessExpiresAt: asDate(m['manual_access_expires_at']),
      );
}
