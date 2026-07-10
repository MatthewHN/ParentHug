import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_logo.dart';
import 'widgets/social_auth_buttons.dart';

/// Social-first entry screen: app mark, Google/Apple sign-in, and a small
/// email fallback. Email is intentionally de-emphasized to steer most users
/// toward one-tap Google/Apple.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // App icon, centered — the hero of the screen.
              const HugMark(size: 92),
              const SizedBox(height: 22),
              const Text(
                'ParentHug',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'The next right words when parenting gets hard.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 15.5,
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 4),
              // Primary sign-in options (Apple only shows on iOS).
              const SocialAuthButtons(),
              const SizedBox(height: 18),
              const _LegalNotice(),
              const SizedBox(height: 10),
              // De-emphasized email fallback → dedicated email screen.
              TextButton(
                onPressed: () => context.push(AppRoutes.emailLogin),
                child: const Text(
                  'Or use email',
                  style: TextStyle(
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

/// "By continuing, you agree to our Terms & Conditions and Privacy Policy."
/// with tappable links. Stateful so the tap recognizers are disposed cleanly.
class _LegalNotice extends StatefulWidget {
  const _LegalNotice();

  @override
  State<_LegalNotice> createState() => _LegalNoticeState();
}

class _LegalNoticeState extends State<_LegalNotice> {
  late final TapGestureRecognizer _terms;
  late final TapGestureRecognizer _privacy;

  @override
  void initState() {
    super.initState();
    _terms = TapGestureRecognizer()
      ..onTap = () => _open('https://parenthug.app/terms');
    _privacy = TapGestureRecognizer()
      ..onTap = () => _open('https://parenthug.app/privacy');
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const base =
        TextStyle(color: AppColors.inkFaint, fontSize: 12, height: 1.45);
    final link = base.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(text: 'Terms & Conditions', style: link, recognizer: _terms),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: link, recognizer: _privacy),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
