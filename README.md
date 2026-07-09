# ParentHug 🤗

> **The next right words when parenting gets hard.**

ParentHug is a warm, calm, premium parenting companion for two-parent families.
It helps parents **know what to say** in hard moments, **stay aligned** on a shared
Family Board, and **preserve** meaningful family memories.

This repository is a **monorepo** containing everything needed to run the product:

```
parenthug/
├── apps/
│   ├── mobile/      # Flutter app (open in Android Studio)  → app.parenthug
│   └── web/         # Next.js landing page (deploy on Vercel) → parenthug.app
├── supabase/
│   ├── migrations/  # Ordered SQL schema + Row Level Security
│   ├── functions/   # Edge Functions (AI + RevenueCat webhook)
│   └── seed/        # Seed data for local development
└── docs/
    ├── MANUAL_SETUP.md   # Step-by-step launch checklist (for a non-technical founder)
    ├── ARCHITECTURE.md   # System, app, backend, RLS, payments, deploy
    └── PRODUCT_SPEC.md   # Positioning, ICP, features, pricing, roadmap
```

---

## The product in one screen

| Feature | What it does |
| --- | --- |
| **Hug Button** | Instant, practical scripts for hard moments — *regulate → say this → do next → avoid → repair later*. |
| **Repair Mode** | "I lost my cool" recovery scripts to reconnect after a hard moment. |
| **Family Board** | A structured coordination board (not a chat) so both parents stay aligned. |
| **Today's ParentHug** | A daily briefing: child context, one tiny move, a "say this today" script, a memory. |
| **Before You Walk In** | Instant emotional context for the parent coming home. |
| **HugBook (Memories)** | A private family photo album with milestones and "this day last year". |

---

## Quick start (developers)

### 1. Backend — Supabase

```bash
# Install the Supabase CLI: https://supabase.com/docs/guides/cli
supabase login
supabase link --project-ref <your-project-ref>

# Apply the schema + RLS
supabase db push

# (Optional) load seed data into a LOCAL dev database only
supabase db reset            # runs migrations + supabase/seed/seed.sql

# Deploy Edge Functions
supabase functions deploy generate_hug_response
supabase functions deploy generate_repair_script
supabase functions deploy generate_daily_briefing
supabase functions deploy revenuecat_webhook
supabase functions deploy generate_birthday_collage

# Set server-side secrets (never shipped to the app)
supabase secrets set AI_PROVIDER=openai AI_API_KEY=sk-... REVENUECAT_WEBHOOK_SECRET=whsec_...
```

### 2. Mobile — Flutter

```bash
cd apps/mobile
cp .env.example .env          # fill in SUPABASE_URL + SUPABASE_ANON_KEY
flutter pub get
flutter run --dart-define-from-file=.env
```

Open `apps/mobile` directly in **Android Studio** to run/debug.

### 3. Landing page — Next.js

```bash
cd apps/web
cp .env.example .env.local
npm install
npm run dev                    # http://localhost:3000
```

Deploy on **Vercel** with the project **Root Directory** set to `apps/web`.

---

## What still needs *you* (credentials & accounts)

Everything in this repo runs with safe placeholders. Before production you must supply
real credentials and complete external account setup. The full checklist lives in
[`docs/MANUAL_SETUP.md`](docs/MANUAL_SETUP.md). In short:

- [ ] Create a Supabase project → add URL + anon key to the app
- [ ] Choose an AI provider → add `AI_API_KEY` to Supabase secrets
- [ ] Create a RevenueCat project → add SDK keys + configure the webhook
- [ ] Create Apple + Google developer accounts → products & entitlements
- [ ] Create a Vercel project → set domain `parenthug.app`
- [ ] Review the legal templates with a lawyer

---

## Security posture

- **Row Level Security** is enabled on every table; access is scoped to family membership.
- **AI keys never touch the app** — all AI calls run inside Supabase Edge Functions.
- **No secrets are committed** — every secret is a placeholder in a `.env.example`.
- **Storage is private** — child photos are readable only by family members.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full model.

---

## License

Proprietary — © 2026 ParentHug. All rights reserved.
