import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_x.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../models/child.dart';
import '../../../models/family_invite.dart';
import '../../children/application/children_providers.dart';
import '../../children/child_options.dart';
import '../../children/data/children_repository.dart';
import '../../family/application/family_providers.dart';
import '../../family/data/family_repository.dart';
import '../application/onboarding_providers.dart';
import 'widgets/invite_code_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _index = 0;
  String? _mode; // 'create' | 'join'
  final _familyName = TextEditingController();
  final _inviteCode = TextEditingController();
  final _childName = TextEditingController();
  DateTime? _birthday;
  String? _temperament;
  final Set<String> _goals = {};
  final Set<String> _struggles = {};

  String? _familyId;
  FamilyInvite? _invite;
  bool _busy = false;

  List<String> get _flow => switch (_mode) {
        'join' => const ['choose', 'join'],
        'create' => const ['choose', 'family', 'child', 'goals', 'invite', 'finish'],
        _ => const ['choose'],
      };

  String get _key => _flow[_index];

  @override
  void dispose() {
    _familyName.dispose();
    _inviteCode.dispose();
    _childName.dispose();
    super.dispose();
  }

  void _pickMode(String mode) => setState(() {
        _mode = mode;
        _index = 1;
      });

  Future<void> _back() async {
    if (_index == 0) return;
    setState(() {
      _index--;
      if (_index == 0) _mode = null;
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) AppSnackbar.error(context, _friendly(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendly(Object e) {
    final s = e.toString();
    if (s.contains('Invalid or expired')) return 'That invite code isn’t valid.';
    return 'Something went wrong. Please try again.';
  }

  FamilyRepository get _familyRepo => ref.read(familyRepositoryProvider);
  ChildrenRepository get _childRepo => ref.read(childrenRepositoryProvider);

  Future<void> _continue() async {
    switch (_key) {
      case 'family':
        if (_familyName.text.trim().isEmpty) {
          AppSnackbar.error(context, 'Give your family a name.');
          return;
        }
        await _run(() async {
          ref.read(onboardingInProgressProvider.notifier).state = true;
          _familyId = await _familyRepo.createFamily(_familyName.text.trim());
          ref.invalidate(myFamiliesProvider);
          _advance();
        });
      case 'child':
        if (_childName.text.trim().isEmpty) {
          AppSnackbar.error(context, 'Add your child’s name.');
          return;
        }
        _advance();
      case 'goals':
        await _run(() async {
          await _childRepo.create(
            _familyId!,
            Child(
              id: '',
              familyId: _familyId!,
              name: _childName.text.trim(),
              birthday: _birthday,
              temperament: _temperament,
              commonStruggles: _struggles.toList(),
              parentGoals: _goals.toList(),
              createdBy: '',
              createdAt: DateTime.now(),
            ),
          );
          ref.invalidate(childrenProvider);
          _invite = await _familyRepo.createInvite(_familyId!);
          _advance();
        });
      case 'invite':
        _advance();
      case 'finish':
        _finish();
      case 'join':
        if (_inviteCode.text.trim().length < 6) {
          AppSnackbar.error(context, 'Enter your invite code.');
          return;
        }
        await _run(() async {
          _familyId = await _familyRepo.redeemInvite(_inviteCode.text.trim());
          ref.invalidate(myFamiliesProvider);
          _finish();
        });
    }
  }

  void _advance() => setState(() => _index++);

  void _finish() {
    ref.read(onboardingInProgressProvider.notifier).state = false;
    ref
      ..invalidate(myFamiliesProvider)
      ..invalidate(childrenProvider)
      ..invalidate(familyMembersProvider);
    // The router redirect moves us to the Today tab once status becomes ready.
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_index + 1) / (_flow.length);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              progress: progress,
              showBack: _index > 0,
              onBack: _busy ? null : _back,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _buildStep(),
              ),
            ),
            if (_key != 'choose')
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  children: [
                    PrimaryButton(
                      label: _key == 'finish'
                          ? 'Start using ParentHug'
                          : _key == 'join'
                              ? 'Join family'
                              : 'Continue',
                      loading: _busy,
                      onPressed: _continue,
                    ),
                    if (_key == 'invite' || _key == 'child' || _key == 'goals')
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => _key == 'invite' ? _advance() : _continue(),
                        child: Text(_key == 'invite'
                            ? 'Skip for now'
                            : 'Skip this step'),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_key) {
      case 'choose':
        return _ChooseStep(onPick: _pickMode);
      case 'family':
        return _StepShell(
          emoji: '🏡',
          title: 'Create your family',
          subtitle: 'This is the shared space you and your co-parent will use.',
          child: AppTextField(
            label: 'Family name',
            hint: 'e.g. The Rivera Family',
            controller: _familyName,
            prefixIcon: Icons.home_outlined,
          ),
        );
      case 'child':
        return _StepShell(
          emoji: '🧒',
          title: 'Add your first child',
          subtitle: 'A little context helps ParentHug tailor every suggestion.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Child’s name',
                hint: 'e.g. Leo',
                controller: _childName,
                prefixIcon: Icons.child_care_outlined,
              ),
              const SizedBox(height: 18),
              _BirthdayPicker(
                birthday: _birthday,
                onPick: (d) => setState(() => _birthday = d),
              ),
              const SizedBox(height: 18),
              const _Label('Temperament (optional)'),
              const SizedBox(height: 10),
              ChipWrap(
                children: [
                  for (final t in ChildOptions.temperaments)
                    SelectableChip(
                      label: t,
                      selected: _temperament == t,
                      color: AppColors.mint,
                      onTap: () => setState(
                          () => _temperament = _temperament == t ? null : t),
                    ),
                ],
              ),
            ],
          ),
        );
      case 'goals':
        return _StepShell(
          emoji: '🌟',
          title: 'What matters most right now?',
          subtitle: 'Pick a few goals and the struggles you’re facing.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label('Your parenting goals'),
              const SizedBox(height: 10),
              ChipWrap(
                children: [
                  for (final g in ChildOptions.goals)
                    SelectableChip(
                      label: g,
                      selected: _goals.contains(g),
                      onTap: () => setState(() =>
                          _goals.contains(g) ? _goals.remove(g) : _goals.add(g)),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              const _Label('Common struggles'),
              const SizedBox(height: 10),
              ChipWrap(
                children: [
                  for (final s in ChildOptions.struggles)
                    SelectableChip(
                      label: s,
                      selected: _struggles.contains(s),
                      color: AppColors.coral,
                      onTap: () => setState(() => _struggles.contains(s)
                          ? _struggles.remove(s)
                          : _struggles.add(s)),
                    ),
                ],
              ),
            ],
          ),
        );
      case 'invite':
        return _StepShell(
          emoji: '💌',
          title: 'Invite your co-parent',
          subtitle:
              'One subscription covers both parents. Share this code so you stay in sync.',
          child: InviteCodeCard(code: _invite?.code ?? '········'),
        );
      case 'finish':
        return _StepShell(
          emoji: '🎉',
          title: 'You’re all set!',
          subtitle:
              'ParentHug is ready. You can start free — upgrade any time for unlimited support.',
          child: Column(
            children: [
              AppCard(
                color: AppColors.primarySoft,
                child: Row(
                  children: const [
                    Text('🫶', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Try the Hug Button whenever a hard moment hits — it’s on the bottom bar.',
                        style: TextStyle(color: AppColors.ink, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'See ParentHug Plus',
                icon: Icons.workspace_premium_outlined,
                onPressed: () => context.push(AppRoutes.paywall),
              ),
            ],
          ),
        );
      case 'join':
        return _StepShell(
          emoji: '🔗',
          title: 'Join your family',
          subtitle: 'Enter the invite code your co-parent shared with you.',
          child: AppTextField(
            label: 'Invite code',
            hint: 'e.g. 4F9A2B7C',
            controller: _inviteCode,
            textCapitalization: TextCapitalization.characters,
            prefixIcon: Icons.vpn_key_outlined,
          ),
        );
    }
    return const SizedBox.shrink();
  }
}

// ---------------------------------------------------------------------------
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.progress,
    required this.showBack,
    required this.onBack,
  });

  final double progress;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: showBack
                ? IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.hairline,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _StepShell extends StatelessWidget {
  const _StepShell({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(emoji, style: const TextStyle(fontSize: 44)),
        const SizedBox(height: 14),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                color: AppColors.inkMuted, fontSize: 15, height: 1.4)),
        const SizedBox(height: 26),
        child,
      ],
    );
  }
}

class _ChooseStep extends StatelessWidget {
  const _ChooseStep({required this.onPick});
  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Welcome to ParentHug',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
          'Let’s set up your shared family space.',
          style: TextStyle(color: AppColors.inkMuted, fontSize: 15),
        ),
        const SizedBox(height: 26),
        _ChoiceCard(
          emoji: '🏡',
          title: 'Create a new family',
          subtitle: 'Start fresh and invite your co-parent.',
          gradient: AppColors.skyGradient,
          onTap: () => onPick('create'),
        ),
        const SizedBox(height: 16),
        _ChoiceCard(
          emoji: '🔗',
          title: 'Join with an invite code',
          subtitle: 'Your partner already started a family.',
          gradient: AppColors.warmGradient,
          onTap: () => onPick('join'),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradient: gradient,
      onTap: onTap,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.3)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class _BirthdayPicker extends StatelessWidget {
  const _BirthdayPicker({required this.birthday, required this.onPick});
  final DateTime? birthday;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Birthday (optional)'),
        const SizedBox(height: 8),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: birthday ?? DateTime(now.year - 3),
              firstDate: DateTime(now.year - 19),
              lastDate: now,
            );
            if (picked != null) onPick(picked);
          },
          child: Row(
            children: [
              const Icon(Icons.cake_outlined, color: AppColors.inkFaint),
              const SizedBox(width: 12),
              Text(
                birthday == null
                    ? 'Select birthday'
                    : '${DateX.fullDate(birthday!)}  ·  ${DateX.ageLabel(birthday!)}',
                style: TextStyle(
                  color: birthday == null ? AppColors.inkFaint : AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: AppColors.ink, fontSize: 14.5),
      );
}
