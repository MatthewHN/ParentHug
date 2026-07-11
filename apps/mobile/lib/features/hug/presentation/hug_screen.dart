import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_header.dart';
import '../../../models/enums.dart';
import '../../../models/hug_response.dart';
import '../../../services/edge_functions_service.dart';
import '../../children/application/children_providers.dart';
import '../../family/application/family_providers.dart';
import '../application/hug_chat_controller.dart';

/// A bright emergency red for the "I lost my cool" panic button.
const _alertRed = Color(0xFFE5322D);

/// The Hug page is a calm chatbot for everyday moments, with a prominent panic
/// button up top that opens Repair Mode for "I just lost my cool" emergencies.
class HugScreen extends ConsumerStatefulWidget {
  const HugScreen({super.key});

  @override
  ConsumerState<HugScreen> createState() => _HugScreenState();
}

class _HugScreenState extends ConsumerState<HugScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  HugTone _tone = HugTone.gentle;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    // Default to the focused child (or the first one) so the reply is tailored.
    final childId = ref.read(contextChildProvider)?.id;
    _input.clear();
    FocusScope.of(context).unfocus();
    try {
      await ref.read(hugChatControllerProvider.notifier).send(
            familyId: familyId,
            childId: childId,
            text: text,
            tone: _tone,
          );
    } catch (e) {
      if (!mounted) return;
      if (e is EdgeFunctionException && e.isUpgradeRequired) {
        context.push(AppRoutes.paywall);
      } else {
        AppSnackbar.error(
            context, 'Couldn’t respond right now. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(hugChatControllerProvider);
    ref.listen(hugChatControllerProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppHeader(
        actions: [
          if (chat.turns.isNotEmpty)
            IconButton(
              tooltip: 'Clear conversation',
              onPressed: () =>
                  ref.read(hugChatControllerProvider.notifier).reset(),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: _PanicButton(
                onTap: () => context.push(AppRoutes.repair),
              ),
            ),
            const _WhoRow(),
            Expanded(
              child: chat.turns.isEmpty && !chat.sending
                  ? _EmptyChat(onPrompt: (t) {
                      _input.text = t;
                      _input.selection = TextSelection.fromPosition(
                          TextPosition(offset: t.length));
                    })
                  : ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: chat.turns.length + (chat.sending ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i >= chat.turns.length) {
                          return const _TypingBubble();
                        }
                        final turn = chat.turns[i];
                        if (turn is UserTurn) {
                          return _UserBubble(text: turn.text);
                        }
                        return _BotBubble(response: (turn as BotTurn).response);
                      },
                    ),
            ),
            _InputBar(
              controller: _input,
              tone: _tone,
              sending: chat.sending,
              onTone: (t) => setState(() => _tone = t),
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanicButton extends StatelessWidget {
  const _PanicButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _alertRed,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sos_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('I lost my cool',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 17)),
                      SizedBox(height: 1),
                      Text('Tap for a calm repair, right now.',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhoRow extends ConsumerWidget {
  const _WhoRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider).valueOrNull ?? const [];
    if (children.isEmpty) return const SizedBox(height: 4);
    // Highlight the effective child (explicitly selected, else the first).
    final activeId = ref.watch(contextChildProvider)?.id;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: Text('About',
                  style: TextStyle(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ),
          for (final c in children)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Choice(
                label: c.name,
                selected: activeId == c.id,
                onTap: () =>
                    ref.read(selectedChildIdProvider.notifier).state = c.id,
              ),
            ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(99),
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                  color: selected ? AppColors.primary : AppColors.hairline,
                  width: 1.5),
            ),
            child: Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5)),
          ),
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.onPrompt});
  final ValueChanged<String> onPrompt;

  static const _prompts = [
    'My child is having a tantrum right now',
    'Bedtime is a battle tonight',
    'They won’t listen and I’m losing patience',
    'Sibling fight just broke out',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      children: [
        _BotBubbleShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Hi, I’m here with you. 🫂',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      color: AppColors.ink)),
              SizedBox(height: 6),
              Text(
                'Tell me what’s going on and I’ll help you find calm, practical words. For a hard moment you already reacted to, tap the red button above.',
                style:
                    TextStyle(color: AppColors.ink, height: 1.45, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Try one of these',
              style: TextStyle(
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ),
        for (final p in _prompts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onPrompt(p),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(p,
                            style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      ),
                      const Icon(Icons.north_east_rounded,
                          size: 16, color: AppColors.inkFaint),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, height: 1.35)),
      ),
    );
  }
}

/// The visual shell for an assistant message (left-aligned white bubble).
class _BotBubbleShell extends StatelessWidget {
  const _BotBubbleShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10, right: 36),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
          border: Border.all(color: AppColors.hairline),
        ),
        child: child,
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({required this.response});
  final HugResponse response;

  @override
  Widget build(BuildContext context) {
    return _BotBubbleShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (response.isSafety) ...[
            _line('🤍',
                'If anyone may be in danger, contact your local emergency number. You deserve support.',
                emphasize: false),
            const Divider(height: 20),
          ],
          _line('🫂', response.regulate),
          _line('💬', response.sayThis, emphasize: true),
          _line('✅', response.doNext),
          _line('🚫', response.avoid),
          _line('💛', response.repairLater),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Clipboard.setData(ClipboardData(text: hugToText(response)));
                AppSnackbar.success(context, 'Copied');
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.copy_rounded,
                    size: 17, color: AppColors.inkFaint),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String emoji, String text, {bool emphasize = false}) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: AppColors.ink,
                    height: 1.4,
                    fontSize: emphasize ? 15.5 : 14,
                    fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();
  @override
  Widget build(BuildContext context) {
    return const _BotBubbleShell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation(AppColors.primary)),
          ),
          SizedBox(width: 12),
          Text('Finding the words…',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 14)),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.tone,
    required this.sending,
    required this.onTone,
    required this.onSend,
  });

  final TextEditingController controller;
  final HugTone tone;
  final bool sending;
  final ValueChanged<HugTone> onTone;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton<HugTone>(
              onSelected: onTone,
              initialValue: tone,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              itemBuilder: (_) => [
                for (final t in HugTone.values)
                  PopupMenuItem(
                      value: t, child: Text('${t.emoji}  ${t.label}')),
              ],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tone: ${tone.label}',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5)),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => onSend(),
                  decoration: const InputDecoration(
                    hintText: 'Tell me what’s going on…',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _SendButton(sending: sending, onSend: onSend),
            ],
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.sending, required this.onSend});
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: sending ? null : onSend,
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: sending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white)),
                )
              : const Icon(Icons.arrow_upward_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
