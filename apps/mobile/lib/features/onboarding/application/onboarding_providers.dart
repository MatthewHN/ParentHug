import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while the user is mid-onboarding. Keeps the router on the onboarding
/// flow even after a family has been created (so we don't eject the user to the
/// Today tab before they finish setting up their first child / invite).
final onboardingInProgressProvider = StateProvider<bool>((ref) => false);
