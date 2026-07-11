import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/board_item.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../data/board_repository.dart';

/// The full (non-archived) board for the current family, filtered by the
/// focused child (`null` = whole family). The Board groups these by category
/// client-side into per-category cards.
final boardItemsProvider = FutureProvider<List<BoardItem>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <BoardItem>[]);
  final childId = ref.watch(selectedChildIdProvider);
  return ref.watch(boardRepositoryProvider).list(familyId, childId: childId);
});

/// Pinned items only (for the Today tab and board header).
final pinnedBoardItemsProvider = Provider<List<BoardItem>>((ref) {
  final all = ref.watch(boardItemsProvider).valueOrNull ?? const [];
  return all.where((i) => i.pinned).toList();
});

/// Recent board items for the current family/child (used by the Today tab's
/// "recent updates" section).
final recentBoardItemsProvider = FutureProvider<List<BoardItem>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <BoardItem>[]);
  final childId = ref.watch(selectedChildIdProvider);
  return ref.watch(boardRepositoryProvider).list(familyId, childId: childId);
});
