# ParentHug — Supabase backend

## Layout

```
supabase/
├── config.toml                 # Local dev config (ports, auth, functions)
├── migrations/                 # Ordered, idempotent SQL (run in filename order)
│   ├── 0001_init.sql           # Extensions, enums, tables, indexes
│   ├── 0002_functions.sql      # Membership helpers, triggers, safe RPCs
│   ├── 0003_rls.sql            # Row Level Security on every table
│   └── 0004_storage.sql        # Storage buckets + policies
├── functions/                  # Edge Functions (Deno)
│   ├── _shared/                # cors, supabase clients, AI, prompts, safety…
│   ├── generate_hug_response/
│   ├── generate_repair_script/
│   ├── generate_daily_briefing/
│   ├── revenuecat_webhook/
│   └── generate_birthday_collage/
└── seed/seed.sql               # Demo data (LOCAL ONLY)
```

## Local development

```bash
supabase start                 # boots Postgres, Auth, Storage, Studio
supabase db reset              # applies migrations + seed
supabase functions serve       # run Edge Functions locally
```

Demo logins after `db reset` (password `parenthug123`):
`parent.a@parenthug.dev` (admin) and `parent.b@parenthug.dev`.

## Deploy to a hosted project

```bash
supabase link --project-ref <ref>
supabase db push                                   # migrations only (NOT seed)
supabase functions deploy generate_hug_response
supabase functions deploy generate_repair_script
supabase functions deploy generate_daily_briefing
supabase functions deploy revenuecat_webhook
supabase functions deploy generate_birthday_collage
supabase secrets set AI_PROVIDER=openai AI_API_KEY=sk-... \
  REVENUECAT_WEBHOOK_SECRET=whsec_... ENFORCE_USAGE_LIMITS=true
```

## Security model (summary)

- **RLS on every table.** Access is scoped to family membership via the
  `is_family_member` / `is_family_admin` SECURITY DEFINER helpers, which read the
  server-owned `family_members` table — never user-editable JWT metadata.
- **AI keys never leave the server.** Functions read `AI_API_KEY` from secrets.
- **Storage is private.** The `memories` bucket is family-scoped by the first
  path segment (`<family_id>/…`); the app reads via short-lived signed URLs.

See [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) for the full model.
