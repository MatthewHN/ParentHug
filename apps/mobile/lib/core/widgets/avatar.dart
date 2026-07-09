import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Circular avatar showing a photo, or colorful initials as a fallback.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = 44,
    this.color,
  });

  final String? name;
  final String? imageUrl;
  final double size;
  final Color? color;

  String get _initials {
    final n = (name ?? '').trim();
    if (n.isEmpty) return '🙂';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  Color get _bg {
    if (color != null) return color!;
    final palette = [
      AppColors.primary,
      AppColors.coral,
      AppColors.mint,
      AppColors.yellow,
      const Color(0xFFB07CF6),
    ];
    final key = (name ?? '?').codeUnits.fold<int>(0, (a, b) => a + b);
    return palette[key % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _fallback(),
          errorWidget: (_, __, ___) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _bg.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style: TextStyle(
          color: _bg,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
