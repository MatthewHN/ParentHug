import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/hug_response.dart';

/// Composes a Hug response into shareable/savable text.
String hugToText(HugResponse r) => [
      '🫂 First, regulate\n${r.regulate}',
      '💬 Say this\n${r.sayThis}',
      '✅ Do this next\n${r.doNext}',
      '🚫 Avoid this\n${r.avoid}',
      '💛 Repair later\n${r.repairLater}',
    ].join('\n\n');

/// Renders a Hug response as structured cards + refine/action controls.
class HugResultView extends StatelessWidget {
  const HugResultView({
    super.key,
    required this.response,
    required this.onGentler,
    required this.onFirmer,
    required this.onAdaptAge,
    required this.onSave,
    required this.onShare,
    required this.onAddToBoard,
    required this.onNew,
    this.busy = false,
  });

  final HugResponse response;
  final VoidCallback onGentler;
  final VoidCallback onFirmer;
  final VoidCallback onAdaptAge;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onAddToBoard;
  final VoidCallback onNew;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (response.isSafety) const _SafetyBanner(),
        _ResultCard(
          emoji: '🫂',
          label: 'First, regulate',
          text: response.regulate,
          color: AppColors.mint,
        ),
        _ResultCard(
          emoji: '💬',
          label: 'Say this',
          text: response.sayThis,
          color: AppColors.primary,
          emphasized: true,
        ),
        _ResultCard(
          emoji: '✅',
          label: 'Do this next',
          text: response.doNext,
          color: const Color(0xFF2FB8C6),
        ),
        _ResultCard(
          emoji: '🚫',
          label: 'Avoid this',
          text: response.avoid,
          color: AppColors.coral,
        ),
        _ResultCard(
          emoji: '💛',
          label: 'Repair later',
          text: response.repairLater,
          color: const Color(0xFFB07CF6),
        ),
        const SizedBox(height: 8),
        _RefineRow(
          busy: busy,
          onGentler: onGentler,
          onFirmer: onFirmer,
          onAdaptAge: onAdaptAge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.bookmark_add_outlined,
                label: 'Save',
                onTap: onSave,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.ios_share_rounded,
                label: 'Share',
                onTap: onShare,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionButton(
                icon: Icons.push_pin_outlined,
                label: 'To Board',
                onTap: onAddToBoard,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: onNew,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('New situation'),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.emoji,
    required this.label,
    required this.text,
    required this.color,
    this.emphasized = false,
  });

  final String emoji;
  final String label;
  final String text;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        color: emphasized ? color.withValues(alpha: 0.10) : AppColors.surface,
        border: emphasized ? Border.all(color: color, width: 1.5) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: AppColors.ink,
                height: 1.5,
                fontSize: emphasized ? 16 : 15,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RefineRow extends StatelessWidget {
  const _RefineRow({
    required this.busy,
    required this.onGentler,
    required this.onFirmer,
    required this.onAdaptAge,
  });

  final bool busy;
  final VoidCallback onGentler;
  final VoidCallback onFirmer;
  final VoidCallback onAdaptAge;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _RefineChip(
            label: 'Make gentler',
            icon: Icons.spa_outlined,
            onTap: busy ? null : onGentler),
        _RefineChip(
            label: 'Make firmer',
            icon: Icons.shield_outlined,
            onTap: busy ? null : onFirmer),
        _RefineChip(
            label: 'Adapt for age',
            icon: Icons.child_care_outlined,
            onTap: busy ? null : onAdaptAge),
      ],
    );
  }
}

class _RefineChip extends StatelessWidget {
  const _RefineChip({required this.label, required this.icon, this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(color: AppColors.hairline, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primarySoft,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        onTap: onTap,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.coralSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.coral, width: 1.5),
      ),
      child: Row(
        children: const [
          Text('🤍', style: TextStyle(fontSize: 22)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'It sounds really heavy right now. If anyone may be in danger, contact your local emergency number. You deserve support.',
              style:
                  TextStyle(color: AppColors.ink, height: 1.4, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}
