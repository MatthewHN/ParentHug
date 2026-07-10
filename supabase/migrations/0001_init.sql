-- =============================================================================
-- ParentHug - 0001_init.sql
-- Extensions, enums, tables, and indexes.
-- Row Level Security is enabled and policies are defined in 0003_rls.sql.
-- Helper functions/triggers live in 0002_functions.sql.
-- =============================================================================

-- ---- Extensions -------------------------------------------------------------
create extension if not exists "pgcrypto";      -- gen_random_uuid()

-- ---- Invite-code generator (used as a column default below) -----------------
-- Short, human-shareable, upper-case code. Collisions are avoided by the
-- UNIQUE constraint on family_invites.code (caller retries on the rare clash).
create or replace function public.gen_invite_code()
returns text
language sql
volatile
as $$
  select upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
$$;

-- ---- Enums ------------------------------------------------------------------
do $$ begin
  create type member_role as enum ('admin', 'parent', 'caregiver');
exception when duplicate_object then null; end $$;

do $$ begin
  create type board_category as enum (
    'heads_up', 'rules', 'wins', 'wants', 'triggers', 'saved_scripts'
  );
exception when duplicate_object then null; end $$;

-- Single paid tier: 'pro'. ('free' just means no active entitlement.)
do $$ begin
  create type plan_tier as enum ('free', 'pro');
exception when duplicate_object then null; end $$;

do $$ begin
  create type milestone_type as enum (
    'first', 'birthday', 'holiday', 'achievement', 'everyday', 'other'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type hug_tone as enum ('gentle', 'firm', 'calm', 'quick');
exception when duplicate_object then null; end $$;

do $$ begin
  create type parent_reaction as enum (
    'yelled', 'threatened', 'gave_in', 'shamed', 'ignored', 'overwhelmed', 'other'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type repair_tone as enum ('short', 'gentle', 'honest', 'age_appropriate');
exception when duplicate_object then null; end $$;

-- ---- profiles ---------------------------------------------------------------
-- Mirrors auth.users (populated by the handle_new_user trigger).
create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  email       text,
  full_name   text default '',
  avatar_url  text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ---- families ---------------------------------------------------------------
create table if not exists public.families (
  id          uuid primary key default gen_random_uuid(),
  name        text not null default 'My Family',
  created_by  uuid not null references public.profiles (id) on delete restrict,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists families_created_by_idx on public.families (created_by);

-- ---- family_members ---------------------------------------------------------
create table if not exists public.family_members (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid not null references public.families (id) on delete cascade,
  user_id     uuid not null references public.profiles (id) on delete cascade,
  role        member_role not null default 'parent',
  created_at  timestamptz not null default now(),
  unique (family_id, user_id)
);
create index if not exists family_members_family_id_idx on public.family_members (family_id);
create index if not exists family_members_user_id_idx   on public.family_members (user_id);

-- ---- family_invites ---------------------------------------------------------
create table if not exists public.family_invites (
  id            uuid primary key default gen_random_uuid(),
  family_id     uuid not null references public.families (id) on delete cascade,
  code          text not null unique default public.gen_invite_code(),
  invited_email text,
  role          member_role not null default 'parent',
  created_by    uuid not null references public.profiles (id) on delete cascade,
  accepted_by   uuid references public.profiles (id) on delete set null,
  accepted_at   timestamptz,
  expires_at    timestamptz not null default (now() + interval '14 days'),
  created_at    timestamptz not null default now()
);
create index if not exists family_invites_family_id_idx on public.family_invites (family_id);
create index if not exists family_invites_code_idx      on public.family_invites (code);

-- ---- children ---------------------------------------------------------------
create table if not exists public.children (
  id                uuid primary key default gen_random_uuid(),
  family_id         uuid not null references public.families (id) on delete cascade,
  name              text not null,
  birthday          date,
  temperament       text,
  common_struggles  text[] not null default '{}',
  parent_goals      text[] not null default '{}',
  notes             text,
  avatar_url        text,
  created_by        uuid not null references public.profiles (id) on delete set null,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
create index if not exists children_family_id_idx  on public.children (family_id);
create index if not exists children_created_by_idx on public.children (created_by);

-- ---- board_items ------------------------------------------------------------
create table if not exists public.board_items (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid not null references public.families (id) on delete cascade,
  child_id    uuid references public.children (id) on delete set null,
  category    board_category not null,
  title       text not null,
  body        text,
  created_by  uuid not null references public.profiles (id) on delete set null,
  pinned      boolean not null default false,
  archived    boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists board_items_family_id_idx  on public.board_items (family_id);
create index if not exists board_items_child_id_idx   on public.board_items (child_id);
create index if not exists board_items_created_by_idx on public.board_items (created_by);
create index if not exists board_items_category_idx   on public.board_items (family_id, category);

-- ---- hug_responses ----------------------------------------------------------
create table if not exists public.hug_responses (
  id            uuid primary key default gen_random_uuid(),
  family_id     uuid not null references public.families (id) on delete cascade,
  child_id      uuid references public.children (id) on delete set null,
  created_by    uuid not null references public.profiles (id) on delete set null,
  situation     text not null,
  tone          hug_tone not null default 'gentle',
  regulate      text,
  say_this      text,
  do_next       text,
  avoid         text,
  repair_later  text,
  created_at    timestamptz not null default now()
);
create index if not exists hug_responses_family_id_idx  on public.hug_responses (family_id);
create index if not exists hug_responses_child_id_idx   on public.hug_responses (child_id);
create index if not exists hug_responses_created_by_idx on public.hug_responses (created_by);

-- ---- repair_responses -------------------------------------------------------
create table if not exists public.repair_responses (
  id                  uuid primary key default gen_random_uuid(),
  family_id           uuid not null references public.families (id) on delete cascade,
  child_id            uuid references public.children (id) on delete set null,
  created_by          uuid not null references public.profiles (id) on delete set null,
  situation           text not null,
  parent_reaction     parent_reaction not null default 'other',
  tone                repair_tone not null default 'gentle',
  repair_script       text,
  follow_up           text,
  parent_reassurance  text,
  created_at          timestamptz not null default now()
);
create index if not exists repair_responses_family_id_idx  on public.repair_responses (family_id);
create index if not exists repair_responses_child_id_idx   on public.repair_responses (child_id);
create index if not exists repair_responses_created_by_idx on public.repair_responses (created_by);

-- ---- saved_scripts ----------------------------------------------------------
create table if not exists public.saved_scripts (
  id          uuid primary key default gen_random_uuid(),
  family_id   uuid not null references public.families (id) on delete cascade,
  child_id    uuid references public.children (id) on delete set null,
  created_by  uuid not null references public.profiles (id) on delete set null,
  title       text not null,
  body        text not null,
  source      text not null default 'manual', -- 'hug' | 'repair' | 'manual'
  source_id   uuid,
  created_at  timestamptz not null default now()
);
create index if not exists saved_scripts_family_id_idx  on public.saved_scripts (family_id);
create index if not exists saved_scripts_child_id_idx   on public.saved_scripts (child_id);
create index if not exists saved_scripts_created_by_idx on public.saved_scripts (created_by);

-- ---- daily_briefings --------------------------------------------------------
create table if not exists public.daily_briefings (
  id                   uuid primary key default gen_random_uuid(),
  family_id            uuid not null references public.families (id) on delete cascade,
  child_id             uuid references public.children (id) on delete set null,
  created_by           uuid references public.profiles (id) on delete set null,
  briefing_date        date not null default current_date,
  tiny_parenting_move  text,
  recent_context       text,
  watch_for            text,
  say_this_today       text,
  memory_of_day        text,
  before_you_walk_in   text,
  created_at           timestamptz not null default now(),
  unique (family_id, child_id, briefing_date)
);
create index if not exists daily_briefings_family_id_idx on public.daily_briefings (family_id);
create index if not exists daily_briefings_child_id_idx  on public.daily_briefings (child_id);
create index if not exists daily_briefings_date_idx      on public.daily_briefings (family_id, briefing_date desc);

-- ---- memories (HugBook) -----------------------------------------------------
create table if not exists public.memories (
  id              uuid primary key default gen_random_uuid(),
  family_id       uuid not null references public.families (id) on delete cascade,
  child_id        uuid references public.children (id) on delete set null,
  uploaded_by     uuid not null references public.profiles (id) on delete set null,
  storage_path    text not null,
  title           text,
  description     text,
  memory_date     date not null default current_date,
  milestone_type  milestone_type not null default 'everyday',
  created_at      timestamptz not null default now()
);
create index if not exists memories_family_id_idx   on public.memories (family_id);
create index if not exists memories_child_id_idx    on public.memories (child_id);
create index if not exists memories_uploaded_by_idx on public.memories (uploaded_by);
create index if not exists memories_date_idx        on public.memories (family_id, memory_date desc);

-- ---- subscriptions ----------------------------------------------------------
-- One active subscription grants access to every member of the family.
create table if not exists public.subscriptions (
  id              uuid primary key default gen_random_uuid(),
  family_id       uuid not null references public.families (id) on delete cascade,
  user_id         uuid references public.profiles (id) on delete set null,
  plan            plan_tier not null default 'free',
  status          text not null default 'inactive', -- active | inactive | expired
  is_active       boolean not null default false,
  rc_app_user_id  text,
  rc_entitlement  text,
  product_id      text,
  expires_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  -- One subscription per family: an active plan covers every family member
  -- (e.g. trusted caregivers). The RevenueCat webhook upserts on family_id.
  unique (family_id)
);
create index if not exists subscriptions_user_id_idx        on public.subscriptions (user_id);
create index if not exists subscriptions_rc_app_user_id_idx on public.subscriptions (rc_app_user_id);

-- ---- usage_limits -----------------------------------------------------------
-- Tracks per-family monthly usage of gated AI features (for free-plan limits).
create table if not exists public.usage_limits (
  id            uuid primary key default gen_random_uuid(),
  family_id     uuid not null references public.families (id) on delete cascade,
  period_month  text not null,             -- 'YYYY-MM'
  hug_count     integer not null default 0,
  repair_count  integer not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (family_id, period_month)
);
create index if not exists usage_limits_family_id_idx on public.usage_limits (family_id);
