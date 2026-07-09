import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/memory.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../data/memories_repository.dart';

final memoriesProvider = FutureProvider<List<Memory>>((ref) {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return Future.value(const <Memory>[]);
  final childId = ref.watch(selectedChildIdProvider);
  return ref.watch(memoriesRepositoryProvider).list(familyId, childId: childId);
});

/// A memory from this calendar day in a previous year ("This day last year").
final thisDayLastYearProvider = Provider<Memory?>((ref) {
  final memories = ref.watch(memoriesProvider).valueOrNull ?? const [];
  final now = DateTime.now();
  for (final m in memories) {
    if (m.memoryDate.month == now.month &&
        m.memoryDate.day == now.day &&
        m.memoryDate.year < now.year) {
      return m;
    }
  }
  return null;
});

/// Resolves a short-lived signed URL for a private memory image.
final memorySignedUrlProvider =
    FutureProvider.family<String?, String>((ref, storagePath) {
  return ref.watch(memoriesRepositoryProvider).signedUrl(storagePath);
});
