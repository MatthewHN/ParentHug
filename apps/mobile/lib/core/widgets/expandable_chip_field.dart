import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'selectable_chip.dart';

/// A compact, expandable single/multi select field — a "dropdown" that replaces
/// a long row of always-visible chips. Collapsed, it shows the current
/// selection as colored pills (or a hint). Tapping expands it to reveal every
/// option as a toggleable [SelectableChip], keeping the brand [color] on
/// selected values.
class ExpandableChipField extends StatefulWidget {
  const ExpandableChipField({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.color = AppColors.primary,
    this.multiSelect = true,
    this.hint = 'Select',
  });

  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final Color color;
  final bool multiSelect;
  final String hint;

  @override
  State<ExpandableChipField> createState() => _ExpandableChipFieldState();
}

class _ExpandableChipFieldState extends State<ExpandableChipField> {
  bool _open = false;

  void _toggle(String option) {
    final next = {...widget.selected};
    if (widget.multiSelect) {
      next.contains(option) ? next.remove(option) : next.add(option);
    } else if (next.contains(option)) {
      next.clear();
    } else {
      next
        ..clear()
        ..add(option);
    }
    widget.onChanged(next);
    // Single-select behaves like a real dropdown: collapse after a pick.
    if (!widget.multiSelect) setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final chosen = widget.options.where(selected.contains).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                fontSize: 14.5)),
        const SizedBox(height: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            onTap: () => setState(() => _open = !_open),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.hairline, width: 1.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: chosen.isEmpty
                        ? Text(widget.hint,
                            style: const TextStyle(
                                color: AppColors.inkFaint, fontSize: 15))
                        : Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final s in chosen)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: widget.color,
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusPill),
                                  ),
                                  child: Text(s,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.inkFaint),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final o in widget.options)
                  SelectableChip(
                    label: o,
                    color: widget.color,
                    selected: selected.contains(o),
                    onTap: () => _toggle(o),
                  ),
              ],
            ),
          ),
          crossFadeState:
              _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 150),
        ),
      ],
    );
  }
}
