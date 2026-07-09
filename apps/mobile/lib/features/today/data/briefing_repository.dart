import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/daily_briefing.dart';
import '../../../services/edge_functions_service.dart';

class BriefingRepository {
  BriefingRepository(this._fn, this._c);
  final EdgeFunctionsService _fn;
  final SupabaseClient _c;

  Future<DailyBriefing?> today(String familyId, String? childId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    var query = _c
        .from('daily_briefings')
        .select()
        .eq('family_id', familyId)
        .eq('briefing_date', today);
    query = childId != null
        ? query.eq('child_id', childId)
        : query.isFilter('child_id', null);
    final rows = await query.order('created_at', ascending: false).limit(1);
    if (rows.isEmpty) return null;
    return DailyBriefing.fromMap(Map<String, dynamic>.from(rows.first));
  }

  Future<DailyBriefing> generate(String familyId, String? childId) async {
    final uid = _c.auth.currentUser?.id;
    final data = await _fn.invoke('generate_daily_briefing', {
      'user_id': uid,
      'family_id': familyId,
      'child_id': childId,
    });
    return DailyBriefing.fromMap(data);
  }

  /// Returns today's briefing if it exists, otherwise generates a fresh one.
  Future<DailyBriefing> todayOrGenerate(
    String familyId,
    String? childId,
  ) async {
    final existing = await today(familyId, childId);
    return existing ?? await generate(familyId, childId);
  }
}

final briefingRepositoryProvider = Provider<BriefingRepository>(
  (ref) => BriefingRepository(
    ref.watch(edgeFunctionsServiceProvider),
    ref.watch(supabaseClientProvider),
  ),
);
