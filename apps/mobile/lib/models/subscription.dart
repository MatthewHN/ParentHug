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

  /// Effective plan: only a currently-active, unexpired subscription counts.
  PlanTier get effectivePlan {
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
      );
}
