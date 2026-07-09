import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/daily_briefing.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../data/briefing_repository.dart';

/// Today's briefing for the current family + focused child. Fetches the stored
/// briefing if present, otherwise generates a fresh one via the Edge Function.
final todayBriefingProvider =
    FutureProvider.autoDispose<DailyBriefing>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) {
    return const DailyBriefing();
  }
  final childId = ref.watch(selectedChildIdProvider);
  return ref.watch(briefingRepositoryProvider).todayOrGenerate(familyId, childId);
});
