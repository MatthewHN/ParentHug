import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/enums.dart';
import '../../../models/hug_response.dart';
import '../../../services/edge_functions_service.dart';

class HugRepository {
  HugRepository(this._fn, this._c);
  final EdgeFunctionsService _fn;
  final SupabaseClient _c;

  /// Calls the generate_hug_response Edge Function (which holds all AI logic).
  Future<HugResponse> generate({
    required String familyId,
    String? childId,
    required String situation,
    required HugTone tone,
  }) async {
    final uid = _c.auth.currentUser?.id;
    final data = await _fn.invoke('generate_hug_response', {
      'user_id': uid,
      'family_id': familyId,
      'child_id': childId,
      'situation': situation,
      'tone': tone.value,
    });
    return HugResponse.fromMap(data);
  }

  Future<List<HugResponse>> recent(String familyId, {int limit = 20}) async {
    final rows = await _c
        .from('hug_responses')
        .select()
        .eq('family_id', familyId)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows
        .map((r) => HugResponse.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }
}

final hugRepositoryProvider = Provider<HugRepository>(
  (ref) => HugRepository(
    ref.watch(edgeFunctionsServiceProvider),
    ref.watch(supabaseClientProvider),
  ),
);
