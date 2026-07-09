import '_parse.dart';
import 'enums.dart';

class FamilyInvite {
  const FamilyInvite({
    required this.id,
    required this.familyId,
    required this.code,
    required this.role,
    required this.createdBy,
    this.invitedEmail,
    this.acceptedBy,
    this.expiresAt,
    required this.createdAt,
  });

  final String id;
  final String familyId;
  final String code;
  final MemberRole role;
  final String createdBy;
  final String? invitedEmail;
  final String? acceptedBy;
  final DateTime? expiresAt;
  final DateTime createdAt;

  bool get isAccepted => acceptedBy != null;
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isActive => !isAccepted && !isExpired;

  factory FamilyInvite.fromMap(Map<String, dynamic> m) => FamilyInvite(
        id: m['id'] as String,
        familyId: m['family_id'] as String,
        code: m['code'] as String,
        role: MemberRole.from(m['role'] as String?),
        createdBy: m['created_by'] as String? ?? '',
        invitedEmail: m['invited_email'] as String?,
        acceptedBy: m['accepted_by'] as String?,
        expiresAt: asDate(m['expires_at']),
        createdAt: asDateOr(m['created_at'], DateTime.now()),
      );
}
