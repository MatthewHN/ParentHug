-- =============================================================================
-- ParentHug - 0005_harden_functions.sql
-- Security-advisor hardening (Supabase linter 0011/0028/0029).
--   * Pin a stable search_path on the two functions that still lacked one.
--   * Drop the trigger-only handle_new_user() from the public REST/RPC surface.
--
-- NOTE: the membership helpers (is_family_member / is_family_admin /
-- shares_family / family_plan) and the onboarding RPCs (create_family /
-- redeem_invite) INTENTIONALLY remain executable by `authenticated`: RLS
-- policies and onboarding call them, so revoking would break access. Their
-- advisor warnings are expected and safe.
-- =============================================================================

-- Both functions use only pg_catalog builtins (gen_random_uuid, now, string
-- funcs), which resolve regardless of search_path, so '' is the safest pin.
create or replace function public.gen_invite_code()
returns text
language sql
volatile
set search_path = ''
as $$
  select upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- handle_new_user() is only ever invoked by the on_auth_user_created trigger
-- (triggers fire regardless of EXECUTE grants). Remove it from the RPC surface.
revoke all on function public.handle_new_user() from public, anon, authenticated;
