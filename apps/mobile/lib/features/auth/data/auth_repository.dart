import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../models/profile.dart';

class AuthRepository {
  AuthRepository(this._c);
  final SupabaseClient _c;

  /// Returns true if a session is active immediately (email confirmation off).
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final res = await _c.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': fullName?.trim() ?? ''},
    );
    return res.session != null;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _c.auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<void> signOut() => _c.auth.signOut();

  Future<void> sendPasswordReset(String email) =>
      _c.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'app.parenthug://reset-callback',
      );

  Future<Profile?> myProfile() async {
    final uid = _c.auth.currentUser?.id;
    if (uid == null) return null;
    final row =
        await _c.from('profiles').select().eq('id', uid).maybeSingle();
    return row == null ? null : Profile.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> updateProfile({String? fullName, String? avatarUrl}) async {
    final uid = _c.auth.currentUser!.id;
    await _c.from('profiles').update({
      if (fullName != null) 'full_name': fullName.trim(),
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', uid);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(supabaseClientProvider)),
);

final myProfileProvider = FutureProvider<Profile?>((ref) {
  ref.watch(currentUserProvider); // refresh on auth change
  return ref.watch(authRepositoryProvider).myProfile();
});
