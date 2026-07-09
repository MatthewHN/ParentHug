import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/subscription.dart';
import '../../../models/usage_limits.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._c);
  final SupabaseClient _c;

  Future<Subscription?> forFamily(String familyId) async {
    final row = await _c
        .from('subscriptions')
        .select()
        .eq('family_id', familyId)
        .maybeSingle();
    return row == null
        ? null
        : Subscription.fromMap(Map<String, dynamic>.from(row));
  }

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
