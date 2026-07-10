import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/board_item.dart';
import '../../../models/enums.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../data/board_repository.dart';

/// Active category filter on the Family Board (`null` = all).
final boardCategoryFilterProvider =
    StateProvider<BoardCategory?>((ref) => null);

/// The full (non-archived) board for the current family + child/category filter.
final boardItemsProvider = FutureProvider<List<BoardItem>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <BoardItem>[]);
  final childId = ref.watch(selectedChildIdProvider);
  final category = ref.watch(boardCategoryFilterProvider);
  return ref.watch(boardRepositoryProvider).list(
        familyId,
        childId: childId,
        category: category,
      );
});

/// Pinned items only (for the Today tab and board header).
final pinnedBoardItemsProvider = Provider<List<BoardItem>>((ref) {
  final all = ref.watch(boardItemsProvider).valueOrNull ?? const [];
  return all.where((i) => i.pinned).toList();
});

/// Recent board items for the current family/child, ignoring the category
/// filter (used by the Today tab's "recent updates" section).
final recentBoardItemsProvider = FutureProvider<List<BoardItem>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <BoardItem>[]);
  final childId = ref.watch(selectedChildIdProvider);
  return ref.watch(boardRepositoryProvider).list(familyId, childId: childId);
});
