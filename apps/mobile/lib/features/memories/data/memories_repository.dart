import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/enums.dart';
import '../../../models/memory.dart';

class MemoriesRepository {
  MemoriesRepository(this._c);
  final SupabaseClient _c;
  static const _uuid = Uuid();
  static const _bucket = 'memories';

  Future<List<Memory>> list(String familyId, {String? childId}) async {
    var query = _c.from('memories').select().eq('family_id', familyId);
    if (childId != null) query = query.eq('child_id', childId);
    final rows = await query.order('memory_date', ascending: false);
    return rows
        .map((r) => Memory.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }

  Future<Memory> upload({
    required String familyId,
    String? childId,
    required Uint8List bytes,
    String fileExt = 'jpg',
    String? title,
    String? description,
    required DateTime memoryDate,
    MilestoneType milestone = MilestoneType.everyday,
  }) async {
    final uid = _c.auth.currentUser!.id;
    // First path segment MUST be the family id (Storage RLS relies on it).
    final path = '$familyId/${childId ?? 'family'}/${_uuid.v4()}.$fileExt';
    await _c.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/${fileExt == 'jpg' ? 'jpeg' : fileExt}',
            upsert: false,
          ),
        );
    final row = await _c
        .from('memories')
        .insert({
          'family_id': familyId,
          'child_id': childId,
          'uploaded_by': uid,
          'storage_path': path,
          'title': title,
          'description': description,
          'memory_date': memoryDate.toIso8601String().split('T').first,
          'milestone_type': milestone.value,
        })
        .select()
        .single();
    return Memory.fromMap(Map<String, dynamic>.from(row));
  }

  Future<String?> signedUrl(String storagePath, {int expiresIn = 3600}) async {
    try {
      return await _c.storage
          .from(_bucket)
          .createSignedUrl(storagePath, expiresIn);
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(Memory memory) async {
    try {
      await _c.storage.from(_bucket).remove([memory.storagePath]);
    } catch (_) {
      // Ignore storage errors — still remove the DB row.
    }
    await _c.from('memories').delete().eq('id', memory.id);
  }
}

final memoriesRepositoryProvider = Provider<MemoriesRepository>(
  (ref) => MemoriesRepository(ref.watch(supabaseClientProvider)),
);
