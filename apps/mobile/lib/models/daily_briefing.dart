import '_parse.dart';

class DailyBriefing {
  const DailyBriefing({
    this.id,
    this.familyId,
    this.childId,
    this.tinyParentingMove = '',
    this.recentContext = '',
    this.watchFor = '',
    this.sayThisToday = '',
    this.memoryOfDay = '',
    this.beforeYouWalkIn = '',
    this.briefingDate,
  });

  final String? id;
  final String? familyId;
  final String? childId;
  final String tinyParentingMove;
  final String recentContext;
  final String watchFor;
  final String sayThisToday;
  final String memoryOfDay;
  final String beforeYouWalkIn;
  final DateTime? briefingDate;

  factory DailyBriefing.fromMap(Map<String, dynamic> m) => DailyBriefing(
        id: m['id'] as String?,
        familyId: m['family_id'] as String?,
        childId: m['child_id'] as String?,
        tinyParentingMove: (m['tiny_parenting_move'] as String?) ?? '',
        recentContext: (m['recent_context'] as String?) ?? '',
        watchFor: (m['watch_for'] as String?) ?? '',
        sayThisToday: (m['say_this_today'] as String?) ?? '',
        memoryOfDay: (m['memory_of_day'] as String?) ?? '',
        beforeYouWalkIn: (m['before_you_walk_in'] as String?) ?? '',
        briefingDate: asDate(m['briefing_date']),
      );
}
