# ParentHug app context

> Living product context. Update this file whenever a prompt changes the app,
> backend, product behavior, or customer-facing copy.

## What ParentHug is

ParentHug is a calm, practical parenting companion for caregivers navigating
hard moments. It provides in-the-moment language and repair scripts, a shared
family board, child profiles, daily briefs, and a private memory space. The
product is aimed at parents; it can feel warm and playful because it relates to
children, but it must never feel childlike.

## Product and visual direction

- The mobile app is Flutter for iOS and Android, backed by Supabase.
- The visual language should feel professionally iOS-native: flat, bold color,
  clean typography, generous spacing, crisp borders, and restrained 3D layers.
  Avoid glass effects, busy gradients, and juvenile decoration.
- The account/profile experience is intentionally simple: email only, no
  editable display name and no indication of the Google sign-in provider.
- Child profiles are never limited by a subscription tier.
- The Hug panic card is cleanly rounded without a red outer tint, and clearing
  a Hug conversation uses a trash icon.
- Repair Mode uses a heart-led `Repair` action and keeps generated scripts
  private to the session (no save or share actions).
- Today features the most recently uploaded memory immediately. When no memory
  exists it shows the bundled `kid.jpg` placeholder; memory titles are visible
  as captions and can be searched from HugBook.
- Child temperament choices include both strengths and harder traits. Child
  ages are already complete labels (for example, `newborn`), without appending
  `old`.
- Memory-of-the-day images preserve their complete source aspect ratio, and
  deleted memories disappear optimistically before the backend request ends.
- The Library has two categories: `Bring to life` exposes future Photo to
  video, Drawing to video, and Dream to video integrations; `Games` contains
  Charades and Impostor. Both games share a 1,000-entry deck made only from
  simple, curated animals, actions, people, foods, objects, and places.
- Active Charades rounds take over the full screen in landscape with no bottom
  navigation, use an overflow-safe layout, and always show `Done` and
  `Go again`. Impostor uses clue-and-vote rules: each player gives one related
  word or short hint, then the group votes for the player bluffing.
- Child birthdays are required for new and edited profiles. Every AI-generated
  Hug, Repair, and daily briefing receives the child's birthday, developmental
  stage, temperament, struggles, goals, notes, and relevant moment context.
  Guidance for newborns and infants is parent-facing rather than asking them to
  understand spoken instructions or discuss feelings.
- OpenAI-backed functions default to `gpt-5-mini`.

## Website content (July 2026)

- The ParentHug website includes an SEO-focused parenting blog with practical,
  non-shaming, age-aware scripts for hard everyday moments.
- Published topics cover meltdowns, repair, boundaries, bedtime, sibling
  conflict, back talk, screen time, routines, hitting, picky eating,
  separation, toilet learning, public tantrums, homework, transitions, honesty,
  new siblings, and childhood worries.
- Ten product-specific, long-tail articles explain how ParentHug supports
  in-the-moment scripts, Repair Mode, the Shared Family Board, daily briefings,
  Before You Walk In, HugBook Memories, calm boundaries, and age-aware family
  context. They use accurate feature descriptions and do not promise ranking
  outcomes or replace professional care.
- Blog guidance is supportive and practical, with a clear note to seek a
  pediatric clinician or mental-health professional when a health or persistent
  distress concern needs professional support.

## Profile screen (July 2026)

- Shows the signed-in email on a single ellipsized line.
- Includes an in-app review request between the email and access card.
- Access card wording reflects the real state: free trial with days remaining,
  active subscription with a thank-you message, complimentary access, or an
  ended-trial conversion message. It never says “free plan.”
- Family invitations use the native system share sheet through a simple
  `Share` action. Review and share actions gracefully explain when a native
  plugin is unavailable (for example, after a hot reload that predates a full
  native rebuild).
- The old Tools section is removed. The Account section now offers Sign out and
  Delete account. Deletion requires confirmation and removes the account and
  associated data server-side.
- Signing out also disconnects the cached native Google session, so the next
  Google sign-in can choose an account.

## Access, trials, and billing

- Supabase is the entitlement authority. The app reads the `subscriptions`
  table in realtime; RevenueCat does not grant access directly on-device.
- New families receive a seven-day full-access trial. Expired trials may be
  subject to the existing backend usage rules; trial users are never child
  profile-limited.
- RevenueCat webhooks update billing fields (`plan`, `status`, `is_active`,
  expiration and product details) for every family that the purchaser belongs
  to.
- Operators can grant access directly in the Supabase SQL editor. A permanent
  complimentary Pro grant is:

  ```sql
  update public.subscriptions
  set manual_plan = 'pro', manual_access_expires_at = null
  where family_id = '<family UUID>';
  ```

  A temporary grant sets `manual_access_expires_at` to the desired timestamp.
  To revoke an operator grant, set both manual fields to `null`. Manual grants
  take precedence over RevenueCat and are delivered to active apps in realtime.

## Privacy and account deletion

- Account deletion is an authenticated Supabase Edge Function. It removes the
  caller’s uploaded photos and avatar, deletes families they own (including
  their family-scoped data and files), then deletes the Supabase Auth user.
- The app must not expose a Supabase service-role key or make direct
  administrative database changes from the client.
