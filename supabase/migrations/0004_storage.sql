-- =============================================================================
-- ParentHug - 0004_storage.sql
-- Storage buckets + policies.
--   * memories  (PRIVATE) : child photos & child avatars. Path convention:
--                           `<family_id>/<...>`  → access scoped by family_id.
--                           The app reads these via short-lived signed URLs.
--   * avatars   (PUBLIC)  : parent profile pictures. Path: `<user_id>/<file>`.
-- =============================================================================

insert into storage.buckets (id, name, public)
values ('memories', 'memories', false)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- ---- memories (private, family-scoped) --------------------------------------
-- The first path segment MUST be the family_id. Membership is verified against
-- the server-owned family_members table via is_family_member().
drop policy if exists memories_read on storage.objects;
create policy memories_read on storage.objects
  for select to authenticated
  using (
    bucket_id = 'memories'
    and public.is_family_member(((storage.foldername(name))[1])::uuid)
  );

drop policy if exists memories_insert on storage.objects;
create policy memories_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'memories'
    and owner = auth.uid()
    and public.is_family_member(((storage.foldername(name))[1])::uuid)
  );

drop policy if exists memories_update on storage.objects;
create policy memories_update on storage.objects
  for update to authenticated
  using (
    bucket_id = 'memories'
    and public.is_family_member(((storage.foldername(name))[1])::uuid)
  );

drop policy if exists memories_delete on storage.objects;
create policy memories_delete on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'memories'
    and (
      owner = auth.uid()
      or public.is_family_admin(((storage.foldername(name))[1])::uuid)
    )
  );

-- ---- avatars (public read, own-folder write) --------------------------------
drop policy if exists avatars_read on storage.objects;
create policy avatars_read on storage.objects
  for select using (bucket_id = 'avatars');

drop policy if exists avatars_insert on storage.objects;
create policy avatars_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists avatars_update on storage.objects;
create policy avatars_update on storage.objects
  for update to authenticated
  using (bucket_id = 'avatars' and owner = auth.uid());

drop policy if exists avatars_delete on storage.objects;
create policy avatars_delete on storage.objects
  for delete to authenticated
  using (bucket_id = 'avatars' and owner = auth.uid());
