import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration, resolved in priority order:
///   1. `apps/mobile/.env`, loaded at runtime by flutter_dotenv — works no
///      matter how the app is launched (Android Studio ▶, `flutter run`, …),
///      so you don't have to remember `--dart-define-from-file=.env`.
///   2. `--dart-define` / `--dart-define-from-file` compile-time values.
///   3. Built-in local-dev defaults.
///
/// Nothing secret lives here. AI keys never touch the app - they live only in
/// Supabase Edge Function secrets.
class Env {
  Env._();

  /// Runtime `.env` value → compile-time `--dart-define` ([define]) → [fallback].
  static String _resolve(String key, String define, String fallback) {
    final fromEnv = dotenv.isInitialized ? dotenv.maybeGet(key) : null;
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    if (define.isNotEmpty) return define;
    return fallback;
  }

  static String get supabaseUrl => _resolve(
        'SUPABASE_URL',
        const String.fromEnvironment('SUPABASE_URL'),
        // Android emulator reaches the host machine at 10.0.2.2.
        // iOS simulator / web: http://127.0.0.1:54321. Real project: https URL.
        'http://10.0.2.2:54321',
      );

  /// Canonical Supabase *local dev* anon key (safe to commit - only works
  /// against a local `supabase start` instance). Overridden via `.env` in prod.
  static String get supabaseAnonKey => _resolve(
        'SUPABASE_ANON_KEY',
        const String.fromEnvironment('SUPABASE_ANON_KEY'),
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
      );

  static String get revenueCatIosKey => _resolve(
        'REVENUECAT_IOS_API_KEY',
        const String.fromEnvironment('REVENUECAT_IOS_API_KEY'),
        '',
      );

  static String get revenueCatAndroidKey => _resolve(
        'REVENUECAT_ANDROID_API_KEY',
        const String.fromEnvironment('REVENUECAT_ANDROID_API_KEY'),
        '',
      );

  // ---- Google Sign-In (native) ----
  // OAuth client IDs from Google Cloud Console (see docs/MANUAL_SETUP.md).
  // These are NOT secrets. iOS passes the iOS client id; both platforms pass the
  // Web client id as `serverClientId` so Supabase receives a verifiable ID token.
  static String get googleIosClientId => _resolve(
        'GOOGLE_IOS_CLIENT_ID',
        const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
        '',
      );

  static String get googleWebClientId => _resolve(
        'GOOGLE_WEB_CLIENT_ID',
        const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
        '',
      );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Google sign-in needs at least the Web (server) client id to mint an ID
  /// token Supabase can verify. When absent, the Google button stays inert.
  static bool get isGoogleSignInConfigured => googleWebClientId.isNotEmpty;

  /// When RevenueCat isn't configured the app unlocks premium features so the
  /// product can be demoed end-to-end before billing is wired up.
  static bool get isRevenueCatConfigured =>
      revenueCatIosKey.isNotEmpty || revenueCatAndroidKey.isNotEmpty;
}
