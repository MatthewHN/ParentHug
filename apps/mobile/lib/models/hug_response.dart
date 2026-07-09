import '_parse.dart';

/// A Hug Button result. Works for both the Edge Function payload and DB rows
/// (they share the same snake_case keys).
class HugResponse {
  const HugResponse({
    this.id,
    this.familyId,
    this.childId,
    this.situation = '',
    this.tone = 'gentle',
    required this.regulate,
    required this.sayThis,
    required this.doNext,
    required this.avoid,
    required this.repairLater,
    this.isSafety = false,
    this.createdAt,
  });

  final String? id;
  final String? familyId;
  final String? childId;
  final String situation;
  final String tone;
  final String regulate;
  final String sayThis;
  final String doNext;
  final String avoid;
  final String repairLater;
  final bool isSafety;
  final DateTime? createdAt;

  factory HugResponse.fromMap(Map<String, dynamic> m) => HugResponse(
        id: m['id'] as String?,
        familyId: m['family_id'] as String?,
        childId: m['child_id'] as String?,
        situation: (m['situation'] as String?) ?? '',
        tone: (m['tone'] as String?) ?? 'gentle',
        regulate: (m['regulate'] as String?) ?? '',
        sayThis: (m['say_this'] as String?) ?? '',
        doNext: (m['do_next'] as String?) ?? '',
        avoid: (m['avoid'] as String?) ?? '',
        repairLater: (m['repair_later'] as String?) ?? '',
        isSafety: asBool(m['safety']),
        createdAt: asDate(m['created_at']),
      );
}
