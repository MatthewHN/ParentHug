import 'enums.dart';
import 'profile.dart';

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.role,
    this.profile,
  });

  final String id;
  final String familyId;
  final String userId;
  final MemberRole role;
  final Profile? profile;

  bool get isAdmin => role == MemberRole.admin;

  factory FamilyMember.fromMap(Map<String, dynamic> m) {
    final joined = m['profiles'];
    return FamilyMember(
      id: m['id'] as String,
      familyId: m['family_id'] as String,
      userId: m['user_id'] as String,
      role: MemberRole.from(m['role'] as String?),
      profile: joined is Map<String, dynamic> ? Profile.fromMap(joined) : null,
    );
  }

  String get displayName => profile?.displayName ?? 'Parent';
}
