-- =============================================================================
-- Subscription authority, trials, and operator-granted access.
--
-- Supabase is the only entitlement authority. RevenueCat records billing state
-- via its webhook, while an operator can grant/revoke a time-bound or permanent
-- Pro entitlement directly in this table without a later billing event erasing
-- it. `subscriptions` remains read-only to the app under existing RLS.
-- =============================================================================

alter table public.subscriptions
  add column if not exists trial_started_at timestamptz,
  add column if not exists trial_ends_at timestamptz,
  add column if not exists manual_plan plan_tier,
  add column if not exists manual_access_expires_at timestamptz;

-- Existing families receive the same seven-day trial from their original
-- onboarding date. New families are seeded by create_family below.
update public.subscriptions
set trial_started_at = coalesce(trial_started_at, created_at),
    trial_ends_at = coalesce(trial_ends_at, created_at + interval '7 days'),
    status = case when status = 'inactive' then 'trial' else status end
where trial_started_at is null or trial_ends_at is null or status = 'inactive';

-- A manual grant takes precedence over a trial and RevenueCat. Set
-- manual_plan = 'pro' and leave manual_access_expires_at NULL for permanent
-- access, or set an expiry for a temporary complimentary entitlement.
create or replace function public.family_plan(p_family_id uuid)
returns plan_tier
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (
      select s.manual_plan
      from public.subscriptions s
      where s.family_id = p_family_id
        and s.manual_plan is not null
        and (s.manual_access_expires_at is null or s.manual_access_expires_at > now())
      limit 1
    ),
    (
      select 'pro'::plan_tier
      from public.subscriptions s
      where s.family_id = p_family_id
        and s.trial_ends_at > now()
      limit 1
    ),
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

-- Start every newly created family with a full-access seven-day trial. Child
-- profiles are never plan-limited; only this backend entitlement decides any
-- gated service access.
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

  insert into public.subscriptions (
    family_id, user_id, plan, status, is_active, trial_started_at, trial_ends_at
  )
  values (
    v_family_id, v_uid, 'free', 'trial', false, now(), now() + interval '7 days'
  )
  on conflict (family_id) do nothing;

  insert into public.usage_limits (family_id, period_month)
  values (v_family_id, to_char(now(), 'YYYY-MM'))
  on conflict (family_id, period_month) do nothing;

  return v_family_id;
end;
$$;

-- Publish changes so manual grants in the Supabase dashboard reach running
-- clients immediately through the subscription stream.
do $$
begin
  alter publication supabase_realtime add table public.subscriptions;
exception
  when duplicate_object then null;
end $$;
