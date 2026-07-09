import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/enums.dart';
import '../../../models/hug_response.dart';
import '../../subscription/application/subscription_providers.dart';
import '../data/hug_repository.dart';

/// Holds the current Hug Button result and supports quick refinements.
class HugController extends AutoDisposeAsyncNotifier<HugResponse?> {
  String _situation = '';
  HugTone _tone = HugTone.gentle;
  String? _childId;
  String? _familyId;

  @override
  FutureOr<HugResponse?> build() => null;

  Future<void> generate({
    required String familyId,
    String? childId,
    required String situation,
    required HugTone tone,
  }) async {
    _familyId = familyId;
    _childId = childId;
    _situation = situation;
    _tone = tone;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(hugRepositoryProvider).generate(
            familyId: familyId,
            childId: childId,
            situation: situation,
            tone: tone,
          ),
    );
    ref.invalidate(usageProvider);
  }

  Future<void> _regenerate({String? situation, HugTone? tone}) {
    if (_familyId == null) return Future.value();
    return generate(
      familyId: _familyId!,
      childId: _childId,
      situation: situation ?? _situation,
      tone: tone ?? _tone,
    );
  }

  Future<void> makeGentler() => _regenerate(tone: HugTone.gentle);
  Future<void> makeFirmer() => _regenerate(tone: HugTone.firm);
  Future<void> adaptForAge() => _regenerate(
        situation:
            '$_situation\n\n(Please adapt the wording and approach for the child\'s age.)',
      );

  void reset() => state = const AsyncData(null);
}

final hugControllerProvider =
    AutoDisposeAsyncNotifierProvider<HugController, HugResponse?>(
  HugController.new,
);
