import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/board/presentation/board_screen.dart';
import '../../features/hug/presentation/hug_screen.dart';
import '../../features/memories/presentation/memories_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/repair/presentation/repair_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/shell/splash_screen.dart';
import '../../features/subscription/presentation/paywall_screen.dart';
import '../../features/today/presentation/today_screen.dart';
import 'app_routes.dart';
import 'app_status.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  // Bump a ValueNotifier whenever routing-relevant state changes so GoRouter
  // re-evaluates its redirect.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(appStatusProvider, (_, __) => refresh.value++);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(appStatusProvider);
      final loc = state.matchedLocation;
      final isAuthRoute = AppRoutes.authRoutes.contains(loc);
      final isOnboarding = loc.startsWith(AppRoutes.onboarding);
      final isSplash = loc == AppRoutes.splash;

      switch (status) {
        case AppStatus.loading:
          return isSplash ? null : AppRoutes.splash;
        case AppStatus.unauthenticated:
          return isAuthRoute ? null : AppRoutes.login;
        case AppStatus.onboarding:
          return isOnboarding ? null : AppRoutes.onboarding;
        case AppStatus.ready:
          if (isAuthRoute || isSplash || isOnboarding) return AppRoutes.today;
          return null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.repair,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const RepairScreen(),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, __) => const MaterialPage(
          fullscreenDialog: true,
          child: PaywallScreen(),
        ),
      ),
      // Bottom-nav shell with a persistent tab bar.
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(
                path: AppRoutes.today,
                builder: (_, __) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.hug, builder: (_, __) => const HugScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.board, builder: (_, __) => const BoardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.memories,
                builder: (_, __) => const MemoriesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});
