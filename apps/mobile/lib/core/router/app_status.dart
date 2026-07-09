import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/family/application/family_providers.dart';
import '../../features/onboarding/application/onboarding_providers.dart';
import '../providers/supabase_providers.dart';

/// High-level app state that drives top-level routing.
enum AppStatus { loading, unauthenticated, onboarding, ready }

/// Derived synchronously from auth + family membership so the router redirect
/// can read it without awaiting.
final appStatusProvider = Provider<AppStatus>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return AppStatus.unauthenticated;

  final onboarding = ref.watch(onboardingInProgressProvider);
  final families = ref.watch(myFamiliesProvider);
  return families.when(
    data: (list) =>
        (list.isEmpty || onboarding) ? AppStatus.onboarding : AppStatus.ready,
    loading: () => AppStatus.loading,
    // If we can't load families, don't trap the user on a spinner — send them
    // to onboarding where they can create/join a family (and retry loads).
    error: (_, __) => AppStatus.onboarding,
  );
});
