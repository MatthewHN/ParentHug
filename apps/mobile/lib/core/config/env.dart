/// Compile-time configuration, supplied via `--dart-define-from-file=.env`.
///
/// Nothing secret lives here. AI keys never touch the app - they live only in
/// Supabase Edge Function secrets. The defaults below point at a LOCAL Supabase
/// stack from an Android emulator so `supabase start` + Run works with zero
/// config; override everything via `.env` for real devices / hosted projects.
class Env {
  Env._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    // Android emulator reaches the host machine at 10.0.2.2.
    // iOS simulator / web: use http://127.0.0.1:54321. Real project: https URL.
    defaultValue: 'http://10.0.2.2:54321',
  );

  /// Canonical Supabase *local dev* anon key (safe to commit - only works
  /// against a local `supabase start` instance). Replace via `.env` in prod.
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
  );

  static const revenueCatIosKey =
      String.fromEnvironment('REVENUECAT_IOS_API_KEY', defaultValue: '');
  static const revenueCatAndroidKey =
      String.fromEnvironment('REVENUECAT_ANDROID_API_KEY', defaultValue: '');

  // ---- Google Sign-In (native) ----
  // OAuth client IDs from Google Cloud Console (see docs/MANUAL_SETUP.md).
  // These are NOT secrets. iOS passes the iOS client id; both platforms pass the
  // Web client id as `serverClientId` so Supabase receives a verifiable ID token.
  static const googleIosClientId =
      String.fromEnvironment('GOOGLE_IOS_CLIENT_ID', defaultValue: '');
  static const googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '');

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
