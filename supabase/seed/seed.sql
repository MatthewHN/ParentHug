-- =============================================================================
-- ParentHug - seed data (LOCAL DEVELOPMENT ONLY)
-- Loaded automatically by `supabase db reset`.
--
-- ⚠️  DO NOT run this against production. It creates demo auth users with a known
--     password so you can log in immediately and see the app populated.
--
-- Demo logins (password for both):  parenthug123
--   parent.a@parenthug.dev   (Alex - family admin)
--   parent.b@parenthug.dev   (Sam  - second parent)
-- =============================================================================

-- ---- Demo auth users --------------------------------------------------------
-- Inserting into auth.users fires handle_new_user(), which creates the profiles.
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at,
  raw_app_meta_data, raw_user_meta_data, is_super_admin,
  confirmation_token, recovery_token, email_change_token_new, email_change
) values
  ('00000000-0000-0000-0000-000000000000',
   '11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated',
   'parent.a@parenthug.dev', crypt('parenthug123', gen_salt('bf')),
   now(), now(), now(),
   '{"provider":"email","providers":["email"]}',
   '{"full_name":"Alex (Demo Parent)"}', false, '', '', '', ''),
  ('00000000-0000-0000-0000-000000000000',
   '22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated',
   'parent.b@parenthug.dev', crypt('parenthug123', gen_salt('bf')),
   now(), now(), now(),
   '{"provider":"email","providers":["email"]}',
   '{"full_name":"Sam (Demo Parent)"}', false, '', '', '', '')
on conflict (id) do nothing;

insert into auth.identities (
  id, provider_id, user_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
) values
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111',
   '11111111-1111-1111-1111-111111111111',
   '{"sub":"11111111-1111-1111-1111-111111111111","email":"parent.a@parenthug.dev"}',
   'email', now(), now(), now()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222',
   '22222222-2222-2222-2222-222222222222',
   '{"sub":"22222222-2222-2222-2222-222222222222","email":"parent.b@parenthug.dev"}',
   'email', now(), now(), now())
on conflict do nothing;

-- ---- Family + members -------------------------------------------------------
insert into public.families (id, name, created_by) values
  ('33333333-3333-3333-3333-333333333333', 'The Rivera Family',
   '11111111-1111-1111-1111-111111111111')
on conflict (id) do nothing;

insert into public.family_members (family_id, user_id, role) values
  ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'admin'),
  ('33333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222', 'parent')
on conflict (family_id, user_id) do nothing;

-- ---- Children ---------------------------------------------------------------
insert into public.children (
  id, family_id, name, birthday, temperament, common_struggles, parent_goals, notes, created_by
) values
  ('44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333',
   'Leo', (current_date - interval '4 years')::date, 'Spirited & sensitive',
   array['tantrums','screen time','not listening'],
   array['Stay calm under pressure','Build emotional vocabulary'],
   'Loves dinosaurs and building blocks. Needs a heads-up before transitions.',
   '11111111-1111-1111-1111-111111111111'),
  ('55555555-5555-5555-5555-555555555555', '33333333-3333-3333-3333-333333333333',
   'Mia', (current_date - interval '6 years' + interval '20 days')::date, 'Easygoing & shy',
   array['separation anxiety','picky eating'],
   array['Encourage independence','More connection time'],
   'Turning 6 soon. Loves drawing and blue everything.',
   '11111111-1111-1111-1111-111111111111')
on conflict (id) do nothing;

-- ---- Family Board -----------------------------------------------------------
insert into public.board_items (family_id, child_id, category, title, body, created_by, pinned) values
  ('33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444',
   'heads_up', 'Rough afternoon', 'Leo was upset today because he couldn''t have ice cream. Start with connection.',
   '22222222-2222-2222-2222-222222222222', false),
  ('33333333-3333-3333-3333-333333333333', null,
   'rules', 'Screen time limit', 'Max 2 hours of screen time per day.',
   '11111111-1111-1111-1111-111111111111', true),
  ('33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444',
   'triggers', 'Sudden transitions', 'Gets upset when screen time ends suddenly. Give a 5-minute warning.',
   '11111111-1111-1111-1111-111111111111', false),
  ('33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444',
   'saved_scripts', 'When hitting happens', 'Say: "I won''t let you hit. I''m moving your hands."',
   '11111111-1111-1111-1111-111111111111', true),
  ('33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555',
   'wants', 'Blue sneakers', 'Mia said she wants blue sneakers.',
   '22222222-2222-2222-2222-222222222222', false),
  ('33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555',
   'wins', 'Shared her toys', 'Had a great moment sharing toys with a friend today.',
   '22222222-2222-2222-2222-222222222222', false)
on conflict do nothing;

-- ---- Saved scripts ----------------------------------------------------------
insert into public.saved_scripts (family_id, child_id, title, body, source, created_by) values
  ('33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444',
   'Calm-down script', '"I can see this is really hard. I''m right here with you."', 'hug',
   '11111111-1111-1111-1111-111111111111')
on conflict do nothing;

-- ---- Subscription (free) + usage --------------------------------------------
insert into public.subscriptions (family_id, user_id, plan, status, is_active) values
  ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111',
   'free', 'active', false)
on conflict (family_id) do nothing;

insert into public.usage_limits (family_id, period_month, hug_count, repair_count) values
  ('33333333-3333-3333-3333-333333333333', to_char(now(),'YYYY-MM'), 1, 0)
on conflict (family_id, period_month) do nothing;

-- ---- A sample daily briefing ------------------------------------------------
insert into public.daily_briefings (
  family_id, child_id, briefing_date, tiny_parenting_move, recent_context,
  watch_for, say_this_today, memory_of_day, before_you_walk_in
) values (
  '33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', current_date,
  'Find 5 uninterrupted minutes to follow Leo''s lead - let him pick the game.',
  'Leo had a hard afternoon after no ice cream, but bounced back at bedtime. He''s craving a bit more connection this week.',
  'Watch for a wobble around sudden transitions - give a 5-minute warning before screens go off.',
  '"I love being your dad. Even on hard days, I''m so glad you''re mine."',
  'Notice one small thing Leo did today that made you smile - snap a photo for the HugBook.',
  'Leo had some big feelings this afternoon. Start with connection, not correction. Try: "Hey buddy, I heard today was tough. Want a hug or some space?"'
)
on conflict (family_id, child_id, briefing_date) do nothing;
