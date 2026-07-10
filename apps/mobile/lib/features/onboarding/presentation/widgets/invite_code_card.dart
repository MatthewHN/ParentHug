import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/buttons.dart';

/// Displays a family invite code with copy-to-clipboard actions.
class InviteCodeCard extends StatelessWidget {
  const InviteCodeCard({super.key, required this.code});
  final String code;

  void _copy(BuildContext context, String text, String toast) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackbar.success(context, toast);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = code.replaceAll('·', '').isNotEmpty;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 26),
          decoration: BoxDecoration(
            gradient: AppColors.skyGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            children: [
              Text(
                'INVITE CODE',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Copy code',
                icon: Icons.copy_rounded,
                onPressed: enabled
                    ? () => _copy(context, code, 'Invite code copied')
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                label: 'Share',
                icon: Icons.ios_share_rounded,
                gradient: AppColors.warmGradient,
                onPressed: enabled
                    ? () async {
                        try {
                          await Share.share(
                            'Join our family on ParentHug! Use invite code $code in the app.',
                          );
                        } on MissingPluginException {
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              'Sharing is available after the next app update.',
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            AppSnackbar.error(
                                context, 'Couldn’t open sharing right now.');
                          }
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
