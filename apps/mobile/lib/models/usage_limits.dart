import '_parse.dart';

class UsageLimits {
  const UsageLimits({
    required this.familyId,
    required this.periodMonth,
    this.hugCount = 0,
    this.repairCount = 0,
  });

  final String familyId;
  final String periodMonth;
  final int hugCount;
  final int repairCount;

  // Free-plan monthly allowances (mirrors the Edge Function).
  static const freeHugLimit = 3;
  static const freeRepairLimit = 1;

  int get hugsRemaining => (freeHugLimit - hugCount).clamp(0, freeHugLimit);
  int get repairsRemaining =>
      (freeRepairLimit - repairCount).clamp(0, freeRepairLimit);

  factory UsageLimits.fromMap(Map<String, dynamic> m) => UsageLimits(
        familyId: m['family_id'] as String,
        periodMonth: (m['period_month'] as String?) ?? '',
        hugCount: asInt(m['hug_count']),
        repairCount: asInt(m['repair_count']),
      );

  static String currentPeriod() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
  }
}
