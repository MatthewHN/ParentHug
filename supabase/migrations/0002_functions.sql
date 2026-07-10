-- =============================================================================
-- ParentHug - 0002_functions.sql
-- Membership helpers, updated_at triggers, new-user handler, and safe RPCs.
--
-- SECURITY DEFINER note: the membership helpers deliberately run as the function
-- owner so they can read family_members WITHOUT triggering that table's own RLS
-- policies (which would otherwise recurse). `set search_path = public` prevents
-- search-path hijacking. Authorization is derived ONLY from the server-owned
-- family_members table - never from user-editable JWT metadata.
-- =============================================================================

-- ---- Membership helpers -----------------------------------------------------
create or replace function public.is_family_member(
  p_family_id uuid,
  p_user_id   uuid default auth.uid()
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members
    where family_id = p_family_id
      and user_id = p_user_id
  );
$$;

create or replace function public.is_family_admin(
  p_family_id uuid,
  p_user_id   uuid default auth.uid()
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.family_members
    where family_id = p_family_id
      and user_id = p_user_id
      and role = 'admin'
  );
$$;

-- Highest active plan for a family (pro > free).
create or replace function public.family_plan(p_family_id uuid)
returns plan_tier
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (
      select s.plan
      from public.subscriptions s
      where s.family_id = p_family_id
        and s.is_active = true
        and (s.expires_at is null or s.expires_at > now())
      order by array_position(array['pro','free']::plan_tier[], s.plan) asc
      limit 1
    ),
    'free'::plan_tier
  );
$$;

-- ---- updated_at trigger -----------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles','families','children','board_items','subscriptions','usage_limits'
  ]
  loop
    execute format('drop trigger if exists set_updated_at on public.%I;', t);
    execute format(
      'create trigger set_updated_at before update on public.%I
         for each row execute function public.set_updated_at();', t);
  end loop;
end $$;

-- ---- New auth user -> profile row ------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---- create_family RPC ------------------------------------------------------
-- Atomically creates a family, makes the caller its admin, and seeds a free
-- subscription + current usage row. Avoids the RLS bootstrap problem (a brand
-- new family has no members yet, so a plain INSERT could not pass member checks).
create or replace function public.create_family(p_name text default 'My Family')
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_family_id uuid;
  v_uid       uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'Not authenticated';
  end if;

  insert into public.families (name, created_by)
  values (coalesce(nullif(trim(p_name), ''), 'My Family'), v_uid)
  returning id into v_family_id;

  insert into public.family_members (family_id, user_id, role)
  values (v_family_id, v_uid, 'admin');

  insert into public.subscriptions (family_id, user_id, plan, status, is_active)
  values (v_family_id, v_uid, 'free', 'active', false)
  on conflict (family_id) do nothing;

  insert into public.usage_limits (family_id, period_month)
  values (v_family_id, to_char(now(), 'YYYY-MM'))
  on conflict (family_id, period_month) do nothing;

  return v_family_id;
end;
$$;

-- ---- redeem_invite RPC ------------------------------------------------------
-- Lets a signed-in user join a family with a valid, unexpired code. Runs as
-- definer so the (not-yet-member) user can insert their own membership row.
create or replace function public.redeem_invite(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_invite public.family_invites;
  v_uid    uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'Not authenticated';
  end if;

  select *
  into v_invite
  from public.family_invites
  where code = upper(trim(p_code))
    and accepted_at is null
    and (expires_at is null or expires_at > now())
  limit 1;

  if v_invite.id is null then
    raise exception 'Invalid or expired invite code';
  end if;

  insert into public.family_members (family_id, user_id, role)
  values (v_invite.family_id, v_uid, v_invite.role)
  on conflict (family_id, user_id) do nothing;

  update public.family_invites
  set accepted_by = v_uid,
      accepted_at = now()
  where id = v_invite.id;

  return v_invite.family_id;
end;
$$;

-- Allow signed-in users to call the RPCs.
grant execute on function public.create_family(text)        to authenticated;
grant execute on function public.redeem_invite(text)        to authenticated;
grant execute on function public.is_family_member(uuid,uuid) to authenticated;
grant execute on function public.is_family_admin(uuid,uuid)  to authenticated;
grant execute on function public.family_plan(uuid)           to authenticated;
