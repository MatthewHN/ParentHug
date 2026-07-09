import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The ParentHug gradient "hug" mark (two arms curving into a heart-ish shape).
class HugMark extends StatelessWidget {
  const HugMark({super.key, this.size = 44});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.hugGradient,
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.volunteer_activism_rounded,
          color: Colors.white, size: size * 0.56),
    );
  }
}

/// Full wordmark: mark + "ParentHug".
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 44, this.showText = true});
  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugMark(size: size),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'ParentHug',
            style: TextStyle(
              fontSize: size * 0.56,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
