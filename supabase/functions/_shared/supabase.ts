// Supabase client factories for Edge Functions.
//
// SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY are injected
// automatically into the Edge runtime — you do not set them yourself.
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

/** Service-role client — bypasses RLS. Use only for trusted server writes. */
export function adminClient(): SupabaseClient {
  return createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );
}

/**
 * Client that acts AS the calling user (RLS enforced). Pass the incoming
 * Authorization header so row policies apply to the request.
 */
export function userClient(authHeader: string | null): SupabaseClient {
  return createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    {
      global: { headers: { Authorization: authHeader ?? "" } },
      auth: { persistSession: false, autoRefreshToken: false },
    },
  );
}

/** Resolve the authenticated user id from the request, or null. */
export async function getUserId(authHeader: string | null): Promise<string | null> {
  if (!authHeader) return null;
  const { data, error } = await userClient(authHeader).auth.getUser();
  if (error || !data.user) return null;
  return data.user.id;
}
