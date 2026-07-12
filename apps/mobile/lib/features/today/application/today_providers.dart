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
  // Wait for children rather than generating a briefing with an empty child ID
  // while profiles are still loading. On "All", use the first child so every
  // suggestion has complete developmental context.
  final children = await ref.watch(childrenProvider.future);
  final selectedChildId = ref.watch(selectedChildIdProvider);
  final selectedExists = children.any((child) => child.id == selectedChildId);
  final childId = selectedExists
      ? selectedChildId
      : children.isEmpty
          ? null
          : children.first.id;
  return ref
      .watch(briefingRepositoryProvider)
      .todayOrGenerate(familyId, childId);
});
