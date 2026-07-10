import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/providers/supabase_providers.dart';
import '../../../models/profile.dart';

class AuthRepository {
  AuthRepository(this._c);
  final SupabaseClient _c;

  GoogleSignIn _googleSignIn() => GoogleSignIn(
        clientId: Env.googleIosClientId.isEmpty ? null : Env.googleIosClientId,
        serverClientId:
            Env.googleWebClientId.isEmpty ? null : Env.googleWebClientId,
      );

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

  /// Native Google sign-in → exchanges the Google ID token for a Supabase
  /// session (no browser round-trip). Returns false if the user cancels the
  /// Google sheet; throws [AuthException] on a real failure.
  Future<bool> signInWithGoogle() async {
    final account = await _googleSignIn().signIn();
    if (account == null) return false; // user dismissed the sheet
    final tokens = await account.authentication;
    final idToken = tokens.idToken;
    if (idToken == null) {
      throw const AuthException('Google sign-in failed: missing ID token.');
    }
    await _c.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: tokens.accessToken,
    );
    return true;
  }

  /// Native Apple sign-in (iOS). Uses a SHA-256-hashed nonce for replay
  /// protection: Apple signs the hashed nonce; Supabase verifies the raw one.
  Future<bool> signInWithApple() async {
    final rawNonce = _randomNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Apple sign-in failed: missing identity token.');
    }
    await _c.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    // Apple only returns the name on the FIRST authorization. Persist it so the
    // profile isn't left blank (the ID token itself carries no name claim).
    final name = [credential.givenName, credential.familyName]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(' ')
        .trim();
    if (name.isNotEmpty) {
      try {
        await updateProfile(fullName: name);
      } catch (_) {
        // Never fail sign-in just because the name couldn't be saved.
      }
    }
    return true;
  }

  /// Cryptographically-random nonce (unreserved URL characters only).
  String _randomNonce([int length = 32]) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<void> signOut() async {
    // Google retains the last account locally unless its native session is
    // disconnected too. Ignore failures so Supabase logout always completes.
    try {
      await _googleSignIn().disconnect();
    } catch (_) {}
    await _c.auth.signOut();
  }

  Future<void> sendPasswordReset(String email) => _c.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'app.parenthug://reset-callback',
      );

  Future<Profile?> myProfile() async {
    final uid = _c.auth.currentUser?.id;
    if (uid == null) return null;
    final row = await _c.from('profiles').select().eq('id', uid).maybeSingle();
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
