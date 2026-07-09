import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/child.dart';
import '../../family/application/family_providers.dart';
import '../data/children_repository.dart';

final childrenProvider = FutureProvider<List<Child>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <Child>[]);
  return ref.watch(childrenRepositoryProvider).list(familyId);
});

/// Currently focused child. `null` means "all children".
final selectedChildIdProvider = StateProvider<String?>((ref) => null);

final selectedChildProvider = Provider<Child?>((ref) {
  final id = ref.watch(selectedChildIdProvider);
  final children = ref.watch(childrenProvider).valueOrNull ?? const [];
  if (id == null || children.isEmpty) return null;
  for (final c in children) {
    if (c.id == id) return c;
  }
  return null;
});

/// The child to use as AI context: the selected one, or the first child.
final contextChildProvider = Provider<Child?>((ref) {
  final selected = ref.watch(selectedChildProvider);
  if (selected != null) return selected;
  final children = ref.watch(childrenProvider).valueOrNull ?? const [];
  return children.isEmpty ? null : children.first;
});
