# ParentHug — Manual Setup Checklist 🚀

This is your **launch checklist**. It's written for a non-technical founder. Work
through it top to bottom. Anything a developer must do in code is already done —
these steps are the accounts, credentials, and buttons only *you* can click.

> 💡 **How to use this doc:** Check off each `[ ]` as you go. Whenever you see a
> value in `THIS_STYLE`, it's something you copy from a dashboard and paste
> somewhere. Keep a private note (password manager) of every key you create.

**Legend of where things live**
- 📱 Mobile app config → `apps/mobile/.env`
- 🌐 Website config → Vercel dashboard (or `apps/web/.env.local`)
- 🔒 Server secrets → Supabase (never in the app)

---

## 0. Before you start

- [ ] Create a shared password manager entry called “ParentHug Secrets”.
- [ ] Decide your production domain (default: **parenthug.app**).
- [ ] Have a developer (or Claude Code) available for the two commands that need a
      terminal (applying the database and deploying functions). Everything else is
      point-and-click.

---

## 1. Supabase (database, login, storage, server functions)

Supabase is your backend: user accounts, the database, photo storage, and the
secure server functions that talk to the AI.

### 1a. Create the project
- [ ] Go to <https://supabase.com> → **New project**.
- [ ] Name it `parenthug`, choose a region close to your users, set a strong
      database password (save it).
- [ ] Wait for it to finish provisioning (~2 min).

### 1b. Get your keys
- [ ] Open **Project Settings → API**.
- [ ] Copy the **Project URL** → save as `SUPABASE_URL`.
- [ ] Copy the **anon public** key → save as `SUPABASE_ANON_KEY`.
- [ ] Copy the **service_role** key → save as `SUPABASE_SERVICE_ROLE_KEY`
      (⚠️ secret — server only, never in the app).

### 1c. Put the keys in the mobile app 📱
- [ ] In `apps/mobile`, copy `.env.example` to `.env`.
- [ ] Paste `SUPABASE_URL` and `SUPABASE_ANON_KEY` into it.

### 1d. Apply the database (schema + security)
This creates every table and turns on Row Level Security. Two options:

**Option A — Supabase CLI (recommended)**
- [ ] Install the CLI: <https://supabase.com/docs/guides/cli>
- [ ] In a terminal at the project root:
  ```bash
  supabase login
  supabase link --project-ref YOUR_PROJECT_REF
  supabase db push
  ```

**Option B — SQL editor (no CLI)**
- [ ] Open **SQL Editor** in Supabase.
- [ ] Open each file in `supabase/migrations/` **in order** (0001 → 0004), paste,
      and click **Run**:
  - [ ] `0001_init.sql`
  - [ ] `0002_functions.sql`
  - [ ] `0003_rls.sql`
  - [ ] `0004_storage.sql`

### 1e. Storage buckets
The migrations create two buckets automatically. Confirm under **Storage**:
- [ ] `memories` exists and is **Private**.
- [ ] `avatars` exists and is **Public**.

### 1f. Auth providers
- [ ] Under **Authentication → Providers**, confirm **Email** is enabled.
- [ ] For launch you can keep “Confirm email” **on** (users verify by email) or
      **off** for faster testing. (Local dev has it off.)
- [ ] *(Optional, later)* Apple & Google sign-in: the app is already wired with
      placeholders. When ready, enable them here and in
      `supabase/config.toml`, then flip the buttons on in the app.

### 1g. Deploy the server (Edge) functions
- [ ] With the CLI linked (step 1d), run:
  ```bash
  supabase functions deploy generate_hug_response
  supabase functions deploy generate_repair_script
  supabase functions deploy generate_daily_briefing
  supabase functions deploy revenuecat_webhook
  supabase functions deploy generate_birthday_collage
  ```

### 1h. RLS verification checklist
Row Level Security keeps each family's data private. Verify:
- [ ] **Database → Tables** — every table shows an **RLS enabled** badge.
- [ ] Create two test accounts in different families → confirm neither can see the
      other's children, board notes, or memories.
- [ ] In **Storage**, confirm you cannot open a `memories` file via a public URL
      (it should require a signed link).

✅ **You can now run the app against real Supabase — even with no AI key yet**
(it returns warm, built-in fallback guidance).

---

## 2. AI provider (the “magic” behind the Hug Button)

The app never holds an AI key — only your Supabase server does.

- [ ] Choose a provider: **OpenAI** or **Anthropic** (either works).
- [ ] Create an API key in their dashboard → save as `AI_API_KEY`.
- [ ] Set the server secrets (CLI):
  ```bash
  # OpenAI example:
  supabase secrets set AI_PROVIDER=openai AI_API_KEY=sk-xxxxx
  # Anthropic example:
  supabase secrets set AI_PROVIDER=anthropic AI_API_KEY=sk-ant-xxxxx
  ```
  *(Optional)* choose a model: `supabase secrets set AI_MODEL=gpt-4o-mini`
- [ ] Confirm AI calls only happen server-side — they do; the app calls your
      functions, never the AI directly. (Nothing to change.)
- [ ] Test each function from the app:
  - [ ] Hug Button returns a 5-part response.
  - [ ] Repair Mode returns a script.
  - [ ] Today tab shows a briefing.
- [ ] *(Production)* turn on free-plan limits:
  ```bash
  supabase secrets set ENFORCE_USAGE_LIMITS=true
  ```

---

## 3. RevenueCat (subscriptions)

RevenueCat handles Plus/Family subscriptions across iOS and Android.

### 3a. Project & apps
- [ ] Create a project at <https://revenuecat.com>.
- [ ] Add an **iOS app** (bundle id, e.g. `app.parenthug`).
- [ ] Add an **Android app** (package name, e.g. `app.parenthug`).

### 3b. Entitlements
- [ ] Create entitlements exactly named:
  - [ ] `plus`
  - [ ] `family`
  - (There is no paid `free` entitlement — “free” just means no active entitlement.)

### 3c. Products (create in App Store Connect / Google Play, then import)
- [ ] `parenthug_plus_monthly` — $9.99/month
- [ ] `parenthug_plus_yearly` — $59.99/year
- [ ] `parenthug_family_monthly` — $14.99/month
- [ ] `parenthug_family_yearly` — $89.99/year
- [ ] In RevenueCat, attach the `plus_*` products to the **plus** entitlement and
      the `family_*` products to the **family** entitlement.
- [ ] Create an **Offering** (e.g. “default”) containing all four packages.

### 3d. Connect the stores
- [ ] Connect **App Store Connect** (App-Specific Shared Secret).
- [ ] Connect **Google Play Billing** (service account JSON).

### 3e. Put the SDK keys in the app 📱
- [ ] Copy the **Apple** public SDK key → `REVENUECAT_IOS_API_KEY`.
- [ ] Copy the **Google** public SDK key → `REVENUECAT_ANDROID_API_KEY`.
- [ ] Paste both into `apps/mobile/.env`.

### 3f. Webhook → Supabase
- [ ] In RevenueCat → **Project settings → Integrations → Webhooks**.
- [ ] Set the URL to your deployed function:
      `https://YOUR_PROJECT_REF.supabase.co/functions/v1/revenuecat_webhook`
- [ ] Set an **Authorization header value** (make up a strong secret) and save it
      to Supabase:
  ```bash
  supabase secrets set REVENUECAT_WEBHOOK_SECRET=your-strong-secret
  ```

### 3g. Test
- [ ] Do a **sandbox purchase** on a test device → confirm the app unlocks Plus.
- [ ] Confirm the `subscriptions` table in Supabase updated to `plus`/`family`.
- [ ] Test **Restore purchases** on a second device signed into the same account.

> Until RevenueCat keys are added, the app runs in **demo-unlock mode** (all
> premium features visible) so you can show it to investors/testers immediately.

---

## 4. App stores

### 4a. Accounts
- [ ] Create an **Apple Developer** account ($99/yr).
- [ ] Create a **Google Play Developer** account ($25 once).

### 4b. Identifiers
- [ ] Create the iOS **Bundle ID** `app.parenthug`.
- [ ] Create the Android **package name** `app.parenthug`.
  *(This is the app's default; a developer can change it in `apps/mobile` if you
  prefer a different id.)*

### 4c. Store listings
- [ ] Add the **app icon** (1024×1024).
- [ ] Add **screenshots** (use the app's real screens).
- [ ] Add the **app description** (see `docs/PRODUCT_SPEC.md` for copy).
- [ ] Complete **privacy labels / Data safety** (child photos are private; see
      Privacy Policy).
- [ ] Add **subscription metadata** (names, prices, descriptions).
- [ ] Once live, copy the **App Store** and **Google Play** URLs → you'll paste
      them into the website (step 5).

---

## 5. Vercel (the website) 🌐

- [ ] Create a project at <https://vercel.com> and import this repository.
- [ ] **Set the project Root Directory to `apps/web`** ← the key monorepo step.
- [ ] Framework preset should auto-detect **Next.js**.
- [ ] Add environment variables:
  - [ ] `NEXT_PUBLIC_APP_STORE_URL` = your App Store link (or `#` for now)
  - [ ] `NEXT_PUBLIC_GOOGLE_PLAY_URL` = your Google Play link (or `#` for now)
  - [ ] `NEXT_PUBLIC_SITE_URL` = `https://parenthug.app`
  - [ ] `NEXT_PUBLIC_SUPPORT_EMAIL` = your support email
- [ ] Deploy. Confirm the site loads.
- [ ] Add the domain **parenthug.app** (Project → Settings → Domains) and update
      DNS at your registrar as Vercel instructs.
- [ ] When the apps are live, replace the `#` store links with the real URLs and
      redeploy.
- [ ] *(Optional)* add a real screen-recording at `apps/web/public/demo.mp4` and
      wire it in (see `apps/web/public/README.md`).

---

## 6. Legal pages

Template versions ship at `/privacy`, `/terms`, `/contact`, `/manage-subscription`.

- [ ] Review the **Terms of Service** wording.
- [ ] Review the **Privacy Policy** wording.
- [ ] Set your real **contact email** and **support email** (env var in step 5).
- [ ] Confirm the **Manage Subscription** page instructions match your billing.
- [ ] ⚖️ **Have a qualified lawyer review Terms & Privacy before production.**
      The templates are a starting point, not legal advice.

---

## 7. Production launch checklist ✅

Test the whole thing end to end before you announce:

- [ ] **Auth** — sign up, log in, log out, forgot password.
- [ ] **Onboarding** — create a family, add a child, pick goals/struggles.
- [ ] **Partner invite** — second account joins with the invite code.
- [ ] **Hug Button** — returns a 5-part response; refine/save/share work.
- [ ] **Repair Mode** — returns a script; save/share work.
- [ ] **Family Board** — create, edit, pin, archive, delete; filters work; a
      non-creator/non-admin cannot delete someone else's note.
- [ ] **Photo upload** — add a memory; confirm it appears only for your family.
- [ ] **Today's ParentHug** — greeting, briefing, Before You Walk In all render.
- [ ] **Subscription gating** — free limits enforced (with `ENFORCE_USAGE_LIMITS`
      on); paywall appears; purchase unlocks features.
- [ ] **RevenueCat webhook** — a purchase updates the `subscriptions` table.
- [ ] **Landing page** — looks right on phone and desktop.
- [ ] **No secrets hardcoded** — `.env` files are filled in, not committed.
- [ ] **All placeholders replaced** — store links, support email, domain.
- [ ] **RLS active** — every table shows RLS enabled.
- [ ] **Storage policies active** — memory files require signed links.

🎉 When every box is checked, you're ready to launch ParentHug.

---

### Quick reference — where each secret goes

| Secret | Goes in | Public? |
| --- | --- | --- |
| `SUPABASE_URL` | app `.env` + web (implicit) | yes |
| `SUPABASE_ANON_KEY` | app `.env` | yes |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase (auto) | **no** |
| `AI_API_KEY` | Supabase secrets | **no** |
| `REVENUECAT_IOS_API_KEY` / `..._ANDROID_API_KEY` | app `.env` | yes |
| `REVENUECAT_WEBHOOK_SECRET` | Supabase secrets | **no** |
| `NEXT_PUBLIC_*` | Vercel | yes |
