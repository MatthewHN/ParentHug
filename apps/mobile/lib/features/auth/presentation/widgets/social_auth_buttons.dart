import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/env.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../application/auth_controller.dart';

/// Native social sign-in buttons wired to Supabase (`signInWithIdToken`).
///
/// Apple sign-in is shown ONLY on iOS (Apple's native flow + App Store policy);
/// Google is offered everywhere. See docs/MANUAL_SETUP.md for provider setup.
class SocialAuthButtons extends ConsumerStatefulWidget {
  const SocialAuthButtons({super.key});

  @override
  ConsumerState<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends ConsumerState<SocialAuthButtons> {
  bool _busyGoogle = false;
  bool _busyApple = false;

  /// Apple sign-in is an iOS-only affordance.
  bool get _isIos => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _signInGoogle() async {
    if (!Env.isGoogleSignInConfigured) {
      AppSnackbar.show(context, 'Google sign-in will be available soon.');
      return;
    }
    setState(() => _busyGoogle = true);
    try {
      final ok =
          await ref.read(authControllerProvider.notifier).signInWithGoogle();
      _reportIfFailed(ok);
    } finally {
      if (mounted) setState(() => _busyGoogle = false);
    }
    // On success the router redirect handles navigation.
  }

  Future<void> _signInApple() async {
    setState(() => _busyApple = true);
    try {
      final ok =
          await ref.read(authControllerProvider.notifier).signInWithApple();
      _reportIfFailed(ok);
    } finally {
      if (mounted) setState(() => _busyApple = false);
    }
  }

  /// A `false` result is either a silent user-cancel (no error) or a real
  /// failure (error set on the controller) — only the latter gets a snackbar.
  void _reportIfFailed(bool ok) {
    if (ok || !mounted) return;
    final err = ref.read(authControllerProvider).error;
    if (err != null) AppSnackbar.error(context, authErrorMessage(err));
  }

  @override
  Widget build(BuildContext context) {
    final anyBusy = _busyGoogle || _busyApple;
    return Column(
      children: [
        if (_isIos) ...[
          _SocialButton(
            label: 'Continue with Apple',
            leading: const Icon(Icons.apple, size: 22, color: AppColors.ink),
            loading: _busyApple,
            onTap: anyBusy ? null : _signInApple,
          ),
          const SizedBox(height: 12),
        ],
        _SocialButton(
          label: 'Continue with Google',
          leading: Image.asset('assets/google-icon.png', width: 20, height: 20),
          loading: _busyGoogle,
          onTap: anyBusy ? null : _signInGoogle,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: loading ? null : onTap,
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(color: AppColors.hairline, width: 1.5),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    leading,
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

