import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/enums.dart';
import '../../../models/repair_response.dart';
import '../../../services/edge_functions_service.dart';

class RepairRepository {
  RepairRepository(this._fn, this._c);
  final EdgeFunctionsService _fn;
  final SupabaseClient _c;

  Future<RepairResponse> generate({
    required String familyId,
    String? childId,
    required String situation,
    required ParentReaction reaction,
    required RepairTone tone,
  }) async {
    final uid = _c.auth.currentUser?.id;
    final data = await _fn.invoke('generate_repair_script', {
      'user_id': uid,
      'family_id': familyId,
      'child_id': childId,
      'situation': situation,
      'parent_reaction': reaction.value,
      'tone': tone.value,
    });
    return RepairResponse.fromMap(data);
  }

  Future<List<RepairResponse>> recent(String familyId, {int limit = 20}) async {
    final rows = await _c
        .from('repair_responses')
        .select()
        .eq('family_id', familyId)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows
        .map((r) => RepairResponse.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }
}

final repairRepositoryProvider = Provider<RepairRepository>(
  (ref) => RepairRepository(
    ref.watch(edgeFunctionsServiceProvider),
    ref.watch(supabaseClientProvider),
  ),
);
