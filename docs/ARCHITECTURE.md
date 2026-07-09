# ParentHug - Architecture

## 1. System overview

ParentHug is a Flutter mobile app backed by Supabase, with a Next.js marketing
site. All AI and billing logic runs on the server; the app holds no secrets.

```
┌───────────────┐         ┌──────────────────────────────────────────┐
│  Flutter app  │         │                Supabase                   │
│  (iOS/Android)│         │                                           │
│               │  HTTPS  │  ┌─────────┐  ┌───────────┐  ┌─────────┐  │
│  Riverpod     │────────▶│  │  Auth   │  │ Postgres  │  │ Storage │  │
│  go_router    │         │  │         │  │  + RLS    │  │ (photos)│  │
│  Supabase SDK │◀────────│  └─────────┘  └───────────┘  └─────────┘  │
│  RevenueCat   │         │  ┌─────────────────────────────────────┐  │
└──────┬────────┘         │  │        Edge Functions (Deno)        │  │
       │                  │  │  hug · repair · briefing · webhook  │  │
       │                  │  └───────────────┬─────────────────────┘  │
       │                  └──────────────────┼────────────────────────┘
       │                                     │  (server-side key)
       │                                     ▼
       │                            ┌─────────────────┐
       │  purchases                 │   AI provider   │
       └───────────────┐           └─────────────────┘
                       ▼
              ┌─────────────────┐   webhook   ┌────────────────────┐
              │   RevenueCat    │────────────▶│ revenuecat_webhook │
              └─────────────────┘             └────────────────────┘

┌──────────────────┐   deploy    ┌──────────┐
│ Next.js (apps/web)│───────────▶│  Vercel  │  parenthug.app
└──────────────────┘             └──────────┘
```

**Key principles**
- **Secrets never reach the client.** AI keys live only in Edge Function secrets.
- **Every table is protected by Row Level Security**, scoped to family membership.
- **One subscription covers a whole family**.
- **Runs with placeholders** - no AI key, no RevenueCat, no problem for a demo.

---

## 2. Mobile app architecture (`apps/mobile`)

Clean, feature-first architecture with Riverpod for state and go_router for
navigation.

```
lib/
├── main.dart                 # bootstraps Supabase + RevenueCat, runs the app
├── app.dart                  # MaterialApp.router + theme
├── core/
│   ├── config/env.dart       # compile-time config (--dart-define-from-file)
│   ├── theme/                # colors, spacing, Material theme
│   ├── router/               # go_router + auth/onboarding redirect gate
│   ├── providers/            # Supabase client + auth-state providers
│   ├── widgets/              # reusable UI (buttons, cards, states, chips…)
│   └── utils/                # validators, date helpers, snackbars
├── models/                   # typed models mirroring the DB (+ enums)
├── services/                 # Supabase, Edge Functions, RevenueCat wrappers
└── features/<feature>/
    ├── data/                 # repositories (all Supabase queries)
    ├── application/          # Riverpod providers / controllers
    └── presentation/         # screens + widgets
```

**Layering rule:** `presentation → application → data → services/models`. Screens
never call Supabase directly; they go through a repository provider.

**State management.** Riverpod providers expose async data (`FutureProvider`) and
actions (`AsyncNotifier`). The router listens to a derived `appStatusProvider`
(`loading / unauthenticated / onboarding / ready`) and redirects accordingly.

**Navigation.** A `StatefulShellRoute` hosts the five tabs (Today, Hug, Board,
Memories, Profile). Repair Mode and the Paywall are pushed on top.

**Feature gating.** `entitlementProvider` resolves the family plan. When
RevenueCat isn't configured it returns `family` (demo-unlock); otherwise it reads
the DB subscription kept in sync by the webhook.

---

## 3. Backend architecture (`supabase`)

### Data model (relationships)

```
auth.users 1───1 profiles
profiles 1───* family_members *───1 families
families 1───* children
families 1───* board_items        (child_id nullable → “whole family”)
families 1───* hug_responses
families 1───* repair_responses
families 1───* saved_scripts
families 1───* daily_briefings
families 1───* memories            (storage_path → Storage: memories bucket)
families 1───1 subscriptions       (one per family; covers all members)
families 1───* usage_limits        (one row per family per month)
families 1───* family_invites      (code → redeem_invite RPC)
```

A **user** has a **profile**; profiles join **families** through
**family_members** (roles: `admin`, `parent`, `caregiver`). Almost everything
else hangs off `family_id`, which is the unit of sharing and of security.

### Row Level Security (RLS)

RLS is enabled on **every** table. Policies are expressed with two
`SECURITY DEFINER` helpers:

- `is_family_member(family_id, user_id)` - is this user in this family?
- `is_family_admin(family_id, user_id)` - …and are they an admin?

They run as the function owner so they can read `family_members` without
triggering that table's own policies (which would recurse), and pin
`search_path = public` to prevent hijacking. **Authorization is derived only from
the server-owned `family_members` table - never from user-editable JWT metadata.**

Typical policy shape:
- **SELECT / INSERT / UPDATE** - `is_family_member(family_id)`.
- **DELETE** of sensitive rows - `created_by = auth.uid() OR is_family_admin(...)`.
- **Member management** - admins only.
- **subscriptions / usage_limits** - read-only to members; written only by Edge
  Functions using the service role (which bypasses RLS).

Two safe RPCs solve the “new family has no members yet” bootstrap:
- `create_family(name)` - creates the family, makes the caller admin, seeds a
  free subscription + usage row, atomically.
- `redeem_invite(code)` - lets a signed-in user join via a valid code.

### Storage

- `memories` (**private**) - child photos. Path convention `‹family_id›/…`; RLS
  scopes access by the first path segment via `is_family_member`. The app reads
  images through short-lived **signed URLs**.
- `avatars` (**public**) - parent profile pictures under `‹user_id›/…`.

### Migrations (ordered, idempotent)

```
0001_init.sql       extensions, enums, tables, indexes
0002_functions.sql  membership helpers, updated_at triggers, new-user trigger, RPCs
0003_rls.sql        enable RLS + all policies
0004_storage.sql    buckets + storage policies
```

---

## 4. Edge Functions

Deno functions in `supabase/functions/`. Shared code lives in `_shared/`
(CORS, Supabase clients, AI abstraction, prompts, safety, context, usage).

| Function | Input | Output | Notes |
| --- | --- | --- | --- |
| `generate_hug_response` | situation, tone, child | regulate / say_this / do_next / avoid / repair_later | Core feature; safety-checked; usage-tracked |
| `generate_repair_script` | situation, parent_reaction, tone | repair_script / follow_up / parent_reassurance | Plus feature |
| `generate_daily_briefing` | family, child | tiny_move / recent_context / watch_for / say_this / memory / before_you_walk_in | Today tab |
| `revenuecat_webhook` | RevenueCat event | updates `subscriptions` | Verifies secret; `verify_jwt = false` |
| `generate_birthday_collage` | family, child | source images + status | Clean stub for future rendering |

**Flow of an AI function:**
1. Authenticate the caller (JWT → `auth.uid()`), verify family membership.
2. Run a **safety check** - concerning input short-circuits to a calm,
   support-oriented response.
3. **Usage gating** (free-plan limits; enforced only when `ENFORCE_USAGE_LIMITS`).
4. Load **child + Family Board context** (service role).
5. Call the **AI provider** with a server-side prompt. If no key is configured,
   fall back to warm, hand-authored content so the app always works.
6. **Persist** the result and return it.

**AI provider abstraction.** `_shared/ai.ts` supports `openai` and `anthropic`
(OpenAI-compatible endpoints via `AI_BASE_URL`). Missing key → `null` → static
fallback. Prompts live entirely server-side in `_shared/prompts.ts`.

---

## 5. RevenueCat / payments flow

```
1. On login, app calls Purchases.logIn(supabaseUserId)   ← links RC ↔ user
2. Paywall loads Offerings; user buys a package
3. Apple/Google confirm the purchase to RevenueCat
4. RevenueCat POSTs an event → revenuecat_webhook (Authorization = secret)
5. Webhook maps app_user_id → the user's families, and upserts `subscriptions`
   (plan, status, is_active, expires_at) for each family
6. App reads `subscriptions` (RLS: members can read) → entitlementProvider
   unlocks features for BOTH parents
```

Plans map to entitlements: `plus` → ParentHug Plus, `family` → ParentHug Family.
The DB is the source of truth after the webhook; `family_plan(family_id)` returns
the highest active plan for a family.

---

## 6. Deployment flow

| Piece | Where | How |
| --- | --- | --- |
| Database + RLS | Supabase | `supabase db push` (migrations) |
| Edge Functions | Supabase | `supabase functions deploy <name>` |
| Server secrets | Supabase | `supabase secrets set …` |
| Mobile app | App Store / Google Play | `flutter build ipa` / `appbundle`, then upload |
| Landing page | Vercel | Import repo, **root = `apps/web`**, add env, deploy |

See [`MANUAL_SETUP.md`](MANUAL_SETUP.md) for the click-by-click version.

---

## 7. Environment variables

| Scope | Variables |
| --- | --- |
| 📱 Mobile (`apps/mobile/.env`) | `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `REVENUECAT_IOS_API_KEY`, `REVENUECAT_ANDROID_API_KEY` |
| 🔒 Functions (Supabase secrets) | `AI_PROVIDER`, `AI_API_KEY`, `REVENUECAT_WEBHOOK_SECRET`, `ENFORCE_USAGE_LIMITS`, (`AI_MODEL`, `AI_BASE_URL`) |
| 🌐 Web (Vercel) | `NEXT_PUBLIC_APP_STORE_URL`, `NEXT_PUBLIC_GOOGLE_PLAY_URL`, `NEXT_PUBLIC_SITE_URL`, `NEXT_PUBLIC_SUPPORT_EMAIL` |

`SUPABASE_SERVICE_ROLE_KEY` is injected into the Edge runtime automatically and is
never placed in the app.
