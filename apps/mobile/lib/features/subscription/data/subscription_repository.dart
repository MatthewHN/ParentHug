import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/subscription.dart';
import '../../../models/usage_limits.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._c);
  final SupabaseClient _c;

  Stream<Subscription?> watchFamily(String familyId) => _c
      .from('subscriptions')
      .stream(primaryKey: ['id'])
      .eq('family_id', familyId)
      .map((rows) => rows.isEmpty
          ? null
          : Subscription.fromMap(Map<String, dynamic>.from(rows.first)));

  Future<UsageLimits?> usage(String familyId) async {
    final row = await _c
        .from('usage_limits')
        .select()
        .eq('family_id', familyId)
        .eq('period_month', UsageLimits.currentPeriod())
        .maybeSingle();
    return row == null
        ? null
        : UsageLimits.fromMap(Map<String, dynamic>.from(row));
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(ref.watch(supabaseClientProvider)),
);
