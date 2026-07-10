import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'services/revenuecat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load runtime config from the bundled .env so the app works regardless of
  // how it's launched. Non-fatal: if .env is absent we fall back to
  // --dart-define values / built-in defaults (see Env).
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  await Supabase.initialize(
    url: Env.supabaseUrl,
    // `anonKey` remains the standard key shown in the Supabase dashboard and is
    // compatible with all projects; the newer `publishableKey` is optional.
    // ignore: deprecated_member_use
    anonKey: Env.supabaseAnonKey,
  );

  // Best-effort: never block startup on billing configuration.
  await RevenueCatService.instance.init();

  runApp(const ProviderScope(child: ParentHugApp()));
}
