import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/enums.dart';
import '../../../models/repair_response.dart';
import '../../subscription/application/subscription_providers.dart';
import '../data/repair_repository.dart';

class RepairController extends AutoDisposeAsyncNotifier<RepairResponse?> {
  @override
  FutureOr<RepairResponse?> build() => null;

  Future<void> generate({
    required String familyId,
    String? childId,
    required String situation,
    required ParentReaction reaction,
    required RepairTone tone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(repairRepositoryProvider).generate(
            familyId: familyId,
            childId: childId,
            situation: situation,
            reaction: reaction,
            tone: tone,
          ),
    );
    ref.invalidate(usageProvider);
  }

  void reset() => state = const AsyncData(null);
}

final repairControllerProvider =
    AutoDisposeAsyncNotifierProvider<RepairController, RepairResponse?>(
  RepairController.new,
);
