import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/board_item.dart';
import '../../../models/enums.dart';

class BoardRepository {
  BoardRepository(this._c);
  final SupabaseClient _c;

  Future<List<BoardItem>> list(
    String familyId, {
    String? childId,
    BoardCategory? category,
    bool includeArchived = false,
  }) async {
    var query = _c.from('board_items').select().eq('family_id', familyId);
    if (!includeArchived) query = query.eq('archived', false);
    if (childId != null) query = query.eq('child_id', childId);
    if (category != null) query = query.eq('category', category.value);
    final rows = await query
        .order('pinned', ascending: false)
        .order('created_at', ascending: false);
    return rows
        .map((r) => BoardItem.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }

  Future<BoardItem> create({
    required String familyId,
    String? childId,
    required BoardCategory category,
    required String title,
    String? body,
  }) async {
    final uid = _c.auth.currentUser!.id;
    final row = await _c
        .from('board_items')
        .insert({
          'family_id': familyId,
          'child_id': childId,
          'category': category.value,
          'title': title,
          'body': body,
          'created_by': uid,
        })
        .select()
        .single();
    return BoardItem.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> update(
    String id, {
    String? title,
    String? body,
    BoardCategory? category,
    String? childId,
    bool clearChild = false,
  }) async {
    await _c.from('board_items').update({
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (category != null) 'category': category.value,
      if (clearChild) 'child_id': null else if (childId != null) 'child_id': childId,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> setPinned(String id, bool pinned) async {
    await _c.from('board_items').update({'pinned': pinned}).eq('id', id);
  }

  Future<void> setArchived(String id, bool archived) async {
    await _c.from('board_items').update({'archived': archived}).eq('id', id);
  }

  Future<void> delete(String id) async {
    await _c.from('board_items').delete().eq('id', id);
  }
}

final boardRepositoryProvider = Provider<BoardRepository>(
  (ref) => BoardRepository(ref.watch(supabaseClientProvider)),
);
