import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_x.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../models/board_item.dart';

class BoardItemCard extends StatelessWidget {
  const BoardItemCard({
    super.key,
    required this.item,
    this.childName,
    required this.onPin,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  final BoardItem item;
  final String? childName;
  final VoidCallback onPin;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.category(item.category.value);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${item.category.emoji}  ${item.category.label}',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              const Spacer(),
              if (item.pinned)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.push_pin_rounded,
                      size: 16, color: AppColors.inkFaint),
                ),
              _Menu(
                pinned: item.pinned,
                onPin: onPin,
                onEdit: onEdit,
                onArchive: onArchive,
                onDelete: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.ink)),
          if ((item.body ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(item.body!,
                style: const TextStyle(
                    color: AppColors.inkMuted, height: 1.45, fontSize: 14.5)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (childName != null) ...[
                const Icon(Icons.child_care_outlined,
                    size: 15, color: AppColors.inkFaint),
                const SizedBox(width: 4),
                Text(childName!,
                    style: const TextStyle(
                        color: AppColors.inkFaint,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
              ],
              const Icon(Icons.schedule_rounded,
                  size: 14, color: AppColors.inkFaint),
              const SizedBox(width: 4),
              Text(DateX.relativeDay(item.createdAt),
                  style: const TextStyle(
                      color: AppColors.inkFaint, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    required this.pinned,
    required this.onPin,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  final bool pinned;
  final VoidCallback onPin;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded, color: AppColors.inkFaint),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (v) {
        switch (v) {
          case 'pin':
            onPin();
          case 'edit':
            onEdit();
          case 'archive':
            onArchive();
          case 'delete':
            onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'pin',
          child: _row(pinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
              pinned ? 'Unpin' : 'Pin'),
        ),
        PopupMenuItem(value: 'edit', child: _row(Icons.edit_outlined, 'Edit')),
        PopupMenuItem(
            value: 'archive',
            child: _row(Icons.archive_outlined, 'Archive')),
        PopupMenuItem(
          value: 'delete',
          child: _row(Icons.delete_outline_rounded, 'Delete', color: AppColors.coral),
        ),
      ],
    );
  }

  Widget _row(IconData icon, String label, {Color? color}) => Row(
        children: [
          Icon(icon, size: 19, color: color ?? AppColors.ink),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: color ?? AppColors.ink)),
        ],
      );
}
