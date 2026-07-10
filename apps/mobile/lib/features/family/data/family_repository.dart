import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/enums.dart';
import '../../../models/family.dart';
import '../../../models/family_invite.dart';
import '../../../models/family_member.dart';

class FamilyRepository {
  FamilyRepository(this._c);
  final SupabaseClient _c;

  Future<List<Family>> myFamilies() async {
    final uid = _c.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _c
        .from('family_members')
        .select('created_at, families!inner(*)')
        .eq('user_id', uid)
        .order('created_at');
    return rows
        .map((r) => r['families'])
        .whereType<Map>()
        .map((f) => Family.fromMap(Map<String, dynamic>.from(f)))
        .toList();
  }

  /// Creates a family and makes the caller its admin (atomic RPC).
  Future<String> createFamily(String name) async {
    final res = await _c.rpc('create_family', params: {'p_name': name});
    return res as String;
  }

  /// Joins a family via invite code (atomic RPC). Returns the family id.
  Future<String> redeemInvite(String code) async {
    final res = await _c.rpc('redeem_invite', params: {'p_code': code.trim()});
    return res as String;
  }

  Future<List<FamilyMember>> members(String familyId) async {
    final rows = await _c
        .from('family_members')
        .select('*, profiles(*)')
        .eq('family_id', familyId)
        .order('created_at');
    return rows
        .map((r) => FamilyMember.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }

  Future<FamilyInvite> createInvite(
    String familyId, {
    MemberRole role = MemberRole.parent,
    String? email,
  }) async {
    final uid = _c.auth.currentUser!.id;
    final row = await _c
        .from('family_invites')
        .insert({
          'family_id': familyId,
          'created_by': uid,
          'role': role.value,
          'invited_email': email,
        })
        .select()
        .single();
    return FamilyInvite.fromMap(Map<String, dynamic>.from(row));
  }

  Future<FamilyInvite?> latestActiveInvite(String familyId) async {
    final rows = await _c
        .from('family_invites')
        .select()
        .eq('family_id', familyId)
        .isFilter('accepted_at', null)
        .order('created_at', ascending: false)
        .limit(1);
    if (rows.isEmpty) return null;
    return FamilyInvite.fromMap(Map<String, dynamic>.from(rows.first));
  }

  Future<void> removeMember(String familyId, String userId) async {
    await _c
        .from('family_members')
        .delete()
        .eq('family_id', familyId)
        .eq('user_id', userId);
  }

  Future<void> renameFamily(String familyId, String name) async {
    await _c.from('families').update({'name': name}).eq('id', familyId);
  }
}

final familyRepositoryProvider = Provider<FamilyRepository>(
  (ref) => FamilyRepository(ref.watch(supabaseClientProvider)),
);
