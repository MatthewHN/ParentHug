import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/enums.dart';
import '../../../models/hug_response.dart';
import '../../../services/review_prompter.dart';
import '../../subscription/application/subscription_providers.dart';
import '../data/hug_repository.dart';

/// Composes a Hug response into shareable/copyable text.
String hugToText(HugResponse r) => [
      '🫂 First, regulate\n${r.regulate}',
      '💬 Say this\n${r.sayThis}',
      '✅ Do this next\n${r.doNext}',
      '🚫 Avoid this\n${r.avoid}',
      '💛 Repair later\n${r.repairLater}',
    ].join('\n\n');

/// One turn in the Hug conversation.
sealed class HugTurn {
  const HugTurn();
}

class UserTurn extends HugTurn {
  const UserTurn(this.text);
  final String text;
}

class BotTurn extends HugTurn {
  const BotTurn(this.response);
  final HugResponse response;
}

class HugChatState {
  const HugChatState({this.turns = const [], this.sending = false});
  final List<HugTurn> turns;
  final bool sending;

  HugChatState copyWith({List<HugTurn>? turns, bool? sending}) => HugChatState(
        turns: turns ?? this.turns,
        sending: sending ?? this.sending,
      );
}

/// Drives the Hug page's chat thread: append the parent's message, ask the
/// backend, append the response. Kept alive while the tab is mounted so the
/// conversation survives tab switches.
class HugChatController extends AutoDisposeNotifier<HugChatState> {
  @override
  HugChatState build() => const HugChatState();

  /// Sends [text]; rethrows on failure so the UI can route upgrade-required to
  /// the paywall or surface an error.
  Future<void> send({
    required String familyId,
    String? childId,
    required String text,
    required HugTone tone,
  }) async {
    state = state.copyWith(
      turns: [...state.turns, UserTurn(text)],
      sending: true,
    );
    try {
      final res = await ref.read(hugRepositoryProvider).generate(
            familyId: familyId,
            childId: childId,
            situation: text,
            tone: tone,
          );
      state = state.copyWith(
        turns: [...state.turns, BotTurn(res)],
        sending: false,
      );
      ref.invalidate(usageProvider);
      unawaited(ReviewPrompter.instance.recordPositiveAction());
    } catch (_) {
      state = state.copyWith(sending: false);
      rethrow;
    }
  }

  void reset() => state = const HugChatState();
}

final hugChatControllerProvider =
    AutoDisposeNotifierProvider<HugChatController, HugChatState>(
  HugChatController.new,
);
