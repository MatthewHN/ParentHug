# ParentHug — Mobile app (`apps/mobile`)

Flutter app (iOS + Android). State: **Riverpod**. Routing: **go_router**.
Backend: **Supabase**. Payments: **RevenueCat**.

## Run it

```bash
cd apps/mobile
cp .env.example .env          # fill SUPABASE_URL + SUPABASE_ANON_KEY
flutter pub get
flutter run --dart-define-from-file=.env
```

Open the `apps/mobile` folder directly in **Android Studio** to run/debug. Add
`--dart-define-from-file=.env` under *Run → Edit Configurations → Additional run
args* so your env is applied.

> **Zero-config demo:** with a local `supabase start` running and an Android
> emulator, the app works out of the box (defaults point at the local stack and
> unlock all features until RevenueCat is configured).

## Project layout

```
lib/
├── core/        # config, theme, router, shared widgets, utils, providers
├── models/      # typed models + enums (mirror the DB)
├── services/    # Supabase, Edge Functions, RevenueCat wrappers
└── features/    # auth, onboarding, family, children, today, hug, repair,
                 # board, memories, profile, subscription, shell
                 #   each: data/ (repositories) · application/ (providers) ·
                 #         presentation/ (screens + widgets)
```

## Tests

```bash
flutter test        # unit tests (validators, dates, plan logic) + widget tests
flutter analyze     # static analysis (0 issues expected)
```

## Configuration

All config comes from `--dart-define-from-file=.env` (see `.env.example`). No
secrets are committed. AI keys never live in the app — they're server-side in
Supabase Edge Functions.

## Build for release

```bash
flutter build appbundle --dart-define-from-file=.env   # Android → Play Console
flutter build ipa       --dart-define-from-file=.env   # iOS → App Store Connect
```

Bundle id / package name defaults to `app.parenthug` (matches the RevenueCat and
store setup in `docs/MANUAL_SETUP.md`).
