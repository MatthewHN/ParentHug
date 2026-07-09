import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final ok =
        await ref.read(authControllerProvider.notifier).sendReset(_email.text);
    if (!mounted) return;
    if (ok) {
      setState(() => _sent = true);
    } else {
      final err = ref.read(authControllerProvider).error;
      AppSnackbar.error(context, authErrorMessage(err ?? 'error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔑', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 16),
                Text('Reset your password',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text(
                  'Enter your email and we’ll send you a link to set a new password.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 15),
                ),
                const SizedBox(height: 26),
                if (_sent)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.mintSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Text('✅', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'If an account exists for ${_email.text.trim()}, a reset link is on its way.',
                            style: const TextStyle(
                                color: AppColors.ink, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  AppTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: Validators.email,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Send reset link',
                    loading: loading,
                    onPressed: _submit,
                  ),
                ],
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back to log in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
