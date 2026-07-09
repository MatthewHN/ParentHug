import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_providers.dart';
import '../../../services/revenuecat_service.dart';
import '../data/auth_repository.dart';

/// Turns thrown auth errors into friendly copy.
String authErrorMessage(Object error) {
  if (error is AuthException) return error.message;
  return 'Something went wrong. Please try again.';
}

class AuthController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signIn(String email, String password) => _run(() async {
        await ref
            .read(authRepositoryProvider)
            .signIn(email: email, password: password);
        await _linkRevenueCat();
      });

  /// Returns true on success. If the project requires email confirmation the
  /// session may be null; callers should tell the user to check their inbox.
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) =>
      _run(() async {
        await ref.read(authRepositoryProvider).signUp(
              email: email,
              password: password,
              fullName: fullName,
            );
        await _linkRevenueCat();
      });

  Future<bool> sendReset(String email) =>
      _run(() => ref.read(authRepositoryProvider).sendPasswordReset(email));

  Future<void> signOut() async {
    await RevenueCatService.instance.logout();
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<void> _linkRevenueCat() async {
    final uid = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (uid != null) await RevenueCatService.instance.login(uid);
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>(AuthController.new);
