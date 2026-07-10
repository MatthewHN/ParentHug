/// Centralized route paths.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';

  // Auth
  static const login = '/login'; // social-first Welcome screen
  static const emailLogin = '/login/email';
  static const signup = '/signup';
  static const forgotPassword = '/forgot';

  // Onboarding
  static const onboarding = '/onboarding';

  // Main tabs
  static const today = '/today';
  static const hug = '/hug';
  static const board = '/board';
  static const memories = '/memories';
  static const profile = '/profile';

  // Pushed flows
  static const repair = '/repair';
  static const paywall = '/paywall';

  static const authRoutes = {login, emailLogin, signup, forgotPassword};
}
