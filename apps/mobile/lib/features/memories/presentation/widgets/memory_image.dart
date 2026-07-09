import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/memory.dart';
import '../../application/memories_providers.dart';

/// Displays a private memory image by resolving a short-lived signed URL.
class MemoryPhoto extends ConsumerWidget {
  const MemoryPhoto({
    super.key,
    required this.memory,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
  });

  final Memory memory;
  final BoxFit fit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlAsync = ref.watch(memorySignedUrlProvider(memory.storagePath));
    return urlAsync.when(
      loading: () => _placeholder(child: _spinner()),
      error: (_, __) => _placeholder(child: _brokenIcon()),
      data: (url) {
        if (url == null) return _placeholder(child: _brokenIcon());
        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          height: height,
          width: width,
          placeholder: (_, __) => _placeholder(child: _spinner()),
          errorWidget: (_, __, ___) => _placeholder(child: _brokenIcon()),
        );
      },
    );
  }

  Widget _placeholder({required Widget child}) => Container(
        height: height,
        width: width,
        color: AppColors.primarySoft,
        alignment: Alignment.center,
        child: child,
      );

  Widget _spinner() => const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation(AppColors.primary)),
      );

  Widget _brokenIcon() =>
      const Icon(Icons.image_not_supported_outlined, color: AppColors.inkFaint);
}
