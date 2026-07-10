import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/child.dart';

class ChildrenRepository {
  ChildrenRepository(this._c);
  final SupabaseClient _c;

  Future<List<Child>> list(String familyId) async {
    final rows = await _c
        .from('children')
        .select()
        .eq('family_id', familyId)
        .order('created_at');
    return rows
        .map((r) => Child.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }

  Future<Child> create(String familyId, Child child) async {
    final uid = _c.auth.currentUser!.id;
    final row = await _c
        .from('children')
        .insert({
          ...child.toWrite(),
          'family_id': familyId,
          'created_by': uid,
        })
        .select()
        .single();
    return Child.fromMap(Map<String, dynamic>.from(row));
  }

  Future<Child> update(Child child) async {
    final row = await _c
        .from('children')
        .update(child.toWrite())
        .eq('id', child.id)
        .select()
        .single();
    return Child.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> delete(String id) async {
    await _c.from('children').delete().eq('id', id);
  }
}

final childrenRepositoryProvider = Provider<ChildrenRepository>(
  (ref) => ChildrenRepository(ref.watch(supabaseClientProvider)),
);
