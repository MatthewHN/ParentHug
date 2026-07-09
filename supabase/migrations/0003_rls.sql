-- =============================================================================
-- ParentHug — 0003_rls.sql
-- Enable Row Level Security on EVERY table and define family-scoped policies.
--
-- Rules of thumb:
--   * You can only touch data for families you belong to (is_family_member).
--   * Any member can create/edit shared content; only the creator or a family
--     admin can delete sensitive records.
--   * Only admins can add/remove members.
--   * subscriptions & usage_limits are read-only to members and written only by
--     Edge Functions using the service role (which bypasses RLS).
--   * Authorization derives from the server-owned family_members table, never
--     from user-editable metadata.
-- =============================================================================

-- Helper: do two users share at least one family? (definer avoids RLS recursion)
create or replace function public.shares_family(p_other uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members a
    join public.family_members b on a.family_id = b.family_id
    where a.user_id = auth.uid()
      and b.user_id = p_other
  );
$$;
grant execute on function public.shares_family(uuid) to authenticated;

-- Base grants (RLS still gates every row; these are the table-level privileges).
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public
  to authenticated;
grant all on all tables in schema public to service_role;

-- Enable RLS everywhere ------------------------------------------------------
alter table public.profiles        enable row level security;
alter table public.families        enable row level security;
alter table public.family_members  enable row level security;
alter table public.family_invites  enable row level security;
alter table public.children        enable row level security;
alter table public.board_items     enable row level security;
alter table public.hug_responses   enable row level security;
alter table public.repair_responses enable row level security;
alter table public.saved_scripts   enable row level security;
alter table public.daily_briefings enable row level security;
alter table public.memories        enable row level security;
alter table public.subscriptions   enable row level security;
alter table public.usage_limits    enable row level security;

-- ---- profiles ---------------------------------------------------------------
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select using (id = auth.uid() or public.shares_family(id));

drop policy if exists profiles_insert on public.profiles;
create policy profiles_insert on public.profiles
  for insert with check (id = auth.uid());

drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

-- ---- families ---------------------------------------------------------------
drop policy if exists families_select on public.families;
create policy families_select on public.families
  for select using (public.is_family_member(id));

drop policy if exists families_insert on public.families;
create policy families_insert on public.families
  for insert with check (created_by = auth.uid());

drop policy if exists families_update on public.families;
create policy families_update on public.families
  for update using (public.is_family_admin(id)) with check (public.is_family_admin(id));

drop policy if exists families_delete on public.families;
create policy families_delete on public.families
  for delete using (public.is_family_admin(id));

-- ---- family_members ---------------------------------------------------------
drop policy if exists family_members_select on public.family_members;
create policy family_members_select on public.family_members
  for select using (public.is_family_member(family_id));

drop policy if exists family_members_insert on public.family_members;
create policy family_members_insert on public.family_members
  for insert with check (public.is_family_admin(family_id));

drop policy if exists family_members_update on public.family_members;
create policy family_members_update on public.family_members
  for update using (public.is_family_admin(family_id));

-- Admins may remove anyone; a member may remove (leave) themselves.
drop policy if exists family_members_delete on public.family_members;
create policy family_members_delete on public.family_members
  for delete using (public.is_family_admin(family_id) or user_id = auth.uid());

-- ---- family_invites ---------------------------------------------------------
drop policy if exists family_invites_select on public.family_invites;
create policy family_invites_select on public.family_invites
  for select using (public.is_family_member(family_id));

drop policy if exists family_invites_insert on public.family_invites;
create policy family_invites_insert on public.family_invites
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists family_invites_delete on public.family_invites;
create policy family_invites_delete on public.family_invites
  for delete using (public.is_family_admin(family_id) or created_by = auth.uid());

-- ---- children ---------------------------------------------------------------
drop policy if exists children_select on public.children;
create policy children_select on public.children
  for select using (public.is_family_member(family_id));

drop policy if exists children_insert on public.children;
create policy children_insert on public.children
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists children_update on public.children;
create policy children_update on public.children
  for update using (public.is_family_member(family_id)) with check (public.is_family_member(family_id));

drop policy if exists children_delete on public.children;
create policy children_delete on public.children
  for delete using (public.is_family_admin(family_id) or created_by = auth.uid());

-- ---- board_items ------------------------------------------------------------
drop policy if exists board_items_select on public.board_items;
create policy board_items_select on public.board_items
  for select using (public.is_family_member(family_id));

drop policy if exists board_items_insert on public.board_items;
create policy board_items_insert on public.board_items
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists board_items_update on public.board_items;
create policy board_items_update on public.board_items
  for update using (public.is_family_member(family_id)) with check (public.is_family_member(family_id));

drop policy if exists board_items_delete on public.board_items;
create policy board_items_delete on public.board_items
  for delete using (created_by = auth.uid() or public.is_family_admin(family_id));

-- ---- hug_responses ----------------------------------------------------------
drop policy if exists hug_responses_select on public.hug_responses;
create policy hug_responses_select on public.hug_responses
  for select using (public.is_family_member(family_id));

drop policy if exists hug_responses_insert on public.hug_responses;
create policy hug_responses_insert on public.hug_responses
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists hug_responses_delete on public.hug_responses;
create policy hug_responses_delete on public.hug_responses
  for delete using (created_by = auth.uid() or public.is_family_admin(family_id));

-- ---- repair_responses -------------------------------------------------------
drop policy if exists repair_responses_select on public.repair_responses;
create policy repair_responses_select on public.repair_responses
  for select using (public.is_family_member(family_id));

drop policy if exists repair_responses_insert on public.repair_responses;
create policy repair_responses_insert on public.repair_responses
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists repair_responses_delete on public.repair_responses;
create policy repair_responses_delete on public.repair_responses
  for delete using (created_by = auth.uid() or public.is_family_admin(family_id));

-- ---- saved_scripts ----------------------------------------------------------
drop policy if exists saved_scripts_select on public.saved_scripts;
create policy saved_scripts_select on public.saved_scripts
  for select using (public.is_family_member(family_id));

drop policy if exists saved_scripts_insert on public.saved_scripts;
create policy saved_scripts_insert on public.saved_scripts
  for insert with check (public.is_family_member(family_id) and created_by = auth.uid());

drop policy if exists saved_scripts_update on public.saved_scripts;
create policy saved_scripts_update on public.saved_scripts
  for update using (public.is_family_member(family_id)) with check (public.is_family_member(family_id));

drop policy if exists saved_scripts_delete on public.saved_scripts;
create policy saved_scripts_delete on public.saved_scripts
  for delete using (created_by = auth.uid() or public.is_family_admin(family_id));

-- ---- daily_briefings --------------------------------------------------------
drop policy if exists daily_briefings_select on public.daily_briefings;
create policy daily_briefings_select on public.daily_briefings
  for select using (public.is_family_member(family_id));

drop policy if exists daily_briefings_insert on public.daily_briefings;
create policy daily_briefings_insert on public.daily_briefings
  for insert with check (public.is_family_member(family_id));

drop policy if exists daily_briefings_update on public.daily_briefings;
create policy daily_briefings_update on public.daily_briefings
  for update using (public.is_family_member(family_id)) with check (public.is_family_member(family_id));

drop policy if exists daily_briefings_delete on public.daily_briefings;
create policy daily_briefings_delete on public.daily_briefings
  for delete using (public.is_family_admin(family_id));

-- ---- memories ---------------------------------------------------------------
drop policy if exists memories_select on public.memories;
create policy memories_select on public.memories
  for select using (public.is_family_member(family_id));

drop policy if exists memories_insert on public.memories;
create policy memories_insert on public.memories
  for insert with check (public.is_family_member(family_id) and uploaded_by = auth.uid());

drop policy if exists memories_update on public.memories;
create policy memories_update on public.memories
  for update using (public.is_family_member(family_id)) with check (public.is_family_member(family_id));

drop policy if exists memories_delete on public.memories;
create policy memories_delete on public.memories
  for delete using (uploaded_by = auth.uid() or public.is_family_admin(family_id));

-- ---- subscriptions (read-only to members; written by service role) ----------
drop policy if exists subscriptions_select on public.subscriptions;
create policy subscriptions_select on public.subscriptions
  for select using (public.is_family_member(family_id));

-- ---- usage_limits (read-only to members; written by service role) -----------
drop policy if exists usage_limits_select on public.usage_limits;
create policy usage_limits_select on public.usage_limits
  for select using (public.is_family_member(family_id));
