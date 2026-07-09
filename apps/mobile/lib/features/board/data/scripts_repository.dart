import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/saved_script.dart';
import '../../family/application/family_providers.dart';

/// Saved Scripts library (the `saved_scripts` table - distinct from board notes).
class ScriptsRepository {
  ScriptsRepository(this._c);
  final SupabaseClient _c;

  Future<List<SavedScript>> list(String familyId, {String? childId}) async {
    var query = _c.from('saved_scripts').select().eq('family_id', familyId);
    if (childId != null) query = query.eq('child_id', childId);
    final rows = await query.order('created_at', ascending: false);
    return rows
        .map((r) => SavedScript.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }

  Future<SavedScript> save({
    required String familyId,
    String? childId,
    required String title,
    required String body,
    String source = 'manual',
    String? sourceId,
  }) async {
    final uid = _c.auth.currentUser!.id;
    final row = await _c
        .from('saved_scripts')
        .insert({
          'family_id': familyId,
          'child_id': childId,
          'title': title,
          'body': body,
          'source': source,
          'source_id': sourceId,
          'created_by': uid,
        })
        .select()
        .single();
    return SavedScript.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> delete(String id) async {
    await _c.from('saved_scripts').delete().eq('id', id);
  }
}

final scriptsRepositoryProvider = Provider<ScriptsRepository>(
  (ref) => ScriptsRepository(ref.watch(supabaseClientProvider)),
);

final savedScriptsProvider = FutureProvider<List<SavedScript>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <SavedScript>[]);
  return ref.watch(scriptsRepositoryProvider).list(familyId);
});
