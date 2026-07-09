import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The initialized Supabase client (see main.dart).
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Streams auth state changes so dependent providers rebuild on login/logout.
final authChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

/// The currently signed-in user, or null. Rebuilds on auth changes.
final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authChangesProvider);
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

final currentUserIdProvider = Provider<String?>(
  (ref) => ref.watch(currentUserProvider)?.id,
);
