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
