import '_parse.dart';

class RepairResponse {
  const RepairResponse({
    this.id,
    this.familyId,
    this.childId,
    this.situation = '',
    this.parentReaction = 'other',
    this.tone = 'gentle',
    required this.repairScript,
    required this.followUp,
    required this.parentReassurance,
    this.isSafety = false,
    this.createdAt,
  });

  final String? id;
  final String? familyId;
  final String? childId;
  final String situation;
  final String parentReaction;
  final String tone;
  final String repairScript;
  final String followUp;
  final String parentReassurance;
  final bool isSafety;
  final DateTime? createdAt;

  factory RepairResponse.fromMap(Map<String, dynamic> m) => RepairResponse(
        id: m['id'] as String?,
        familyId: m['family_id'] as String?,
        childId: m['child_id'] as String?,
        situation: (m['situation'] as String?) ?? '',
        parentReaction: (m['parent_reaction'] as String?) ?? 'other',
        tone: (m['tone'] as String?) ?? 'gentle',
        repairScript: (m['repair_script'] as String?) ?? '',
        followUp: (m['follow_up'] as String?) ?? '',
        parentReassurance: (m['parent_reassurance'] as String?) ?? '',
        isSafety: asBool(m['safety']),
        createdAt: asDate(m['created_at']),
      );
}
