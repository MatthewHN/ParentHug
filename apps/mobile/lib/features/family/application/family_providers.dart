import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;

import '../../../core/providers/supabase_providers.dart';
import '../../../models/family.dart';
import '../../../models/family_invite.dart';
import '../../../models/family_member.dart';
import '../data/family_repository.dart';

/// All families the current user belongs to.
final myFamiliesProvider = FutureProvider<List<Family>>((ref) {
  ref.watch(currentUserProvider); // reload on login/logout
  return ref.watch(familyRepositoryProvider).myFamilies();
});

/// The selected family id. Defaults to the first family; can be switched.
class CurrentFamilyId extends Notifier<String?> {
  @override
  String? build() {
    final families = ref.watch(myFamiliesProvider).valueOrNull;
    if (families == null || families.isEmpty) return null;
    return families.first.id;
  }

  void select(String familyId) => state = familyId;
}

final currentFamilyIdProvider =
    NotifierProvider<CurrentFamilyId, String?>(CurrentFamilyId.new);

final currentFamilyProvider = Provider<Family?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  final families = ref.watch(myFamiliesProvider).valueOrNull ?? const [];
  if (families.isEmpty) return null;
  return families.firstWhere(
    (f) => f.id == id,
    orElse: () => families.first,
  );
});

final familyMembersProvider = FutureProvider<List<FamilyMember>>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Future.value(const []);
  return ref.watch(familyRepositoryProvider).members(id);
});

/// Whether the current user is an admin of the current family.
final isCurrentFamilyAdminProvider = Provider<bool>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  final members = ref.watch(familyMembersProvider).valueOrNull ?? const [];
  return members.any((m) => m.userId == uid && m.isAdmin);
});

/// The most recent unaccepted invite for the current family (for sharing).
final latestInviteProvider = FutureProvider<FamilyInvite?>((ref) {
  final id = ref.watch(currentFamilyIdProvider);
  if (id == null) return Future.value(null);
  return ref.watch(familyRepositoryProvider).latestActiveInvite(id);
});
