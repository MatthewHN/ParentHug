import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'services/revenuecat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
