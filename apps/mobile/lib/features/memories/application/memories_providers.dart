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

/// The newest uploaded memory for the active child (or the whole family).
/// This uses upload time rather than the photo's calendar date so new uploads
/// appear on Today immediately.
final memoryOfDayProvider = Provider<Memory?>((ref) {
  final memories = ref.watch(memoriesProvider).valueOrNull ?? const [];
  if (memories.isEmpty) return null;
  return memories.reduce(
    (latest, memory) =>
        memory.createdAt.isAfter(latest.createdAt) ? memory : latest,
  );
});

/// Resolves a short-lived signed URL for a private memory image.
final memorySignedUrlProvider =
    FutureProvider.family<String?, String>((ref, storagePath) {
  return ref.watch(memoriesRepositoryProvider).signedUrl(storagePath);
});
