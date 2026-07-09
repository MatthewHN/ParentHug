// Free-plan usage tracking + enforcement for gated AI features.
//
// Enforcement is OFF by default so the MVP works end-to-end before RevenueCat is
// wired up. Set ENFORCE_USAGE_LIMITS=true (Supabase secret) in production to
// actually cap free users. Usage is always counted regardless.
import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

export type UsageKind = "hug" | "repair";

// Free-plan monthly allowances.
const LIMITS: Record<UsageKind, number> = { hug: 3, repair: 1 };

export interface UsageResult {
  allowed: boolean;
  plan: string;
  used: number;
  limit: number;
  enforced: boolean;
}

export async function trackUsage(
  db: SupabaseClient,
  familyId: string,
  kind: UsageKind,
): Promise<UsageResult> {
  const month = new Date().toISOString().slice(0, 7); // YYYY-MM
  const enforced =
    (Deno.env.get("ENFORCE_USAGE_LIMITS") ?? "false").toLowerCase() === "true";
  const limit = LIMITS[kind];

  const { data: planData } = await db.rpc("family_plan", { p_family_id: familyId });
  const plan = (planData as string | null) ?? "free";

  // Ensure a usage row exists for this month.
  let { data: row } = await db
    .from("usage_limits")
    .select("*")
    .eq("family_id", familyId)
    .eq("period_month", month)
    .maybeSingle();

  if (!row) {
    const ins = await db
      .from("usage_limits")
      .insert({ family_id: familyId, period_month: month })
      .select()
      .single();
    row = ins.data;
  }

  const field = kind === "hug" ? "hug_count" : "repair_count";
  const used = (row?.[field] as number | undefined) ?? 0;
  const isFree = plan === "free";
  const allowed = !enforced || !isFree || used < limit;

  if (allowed && row) {
    await db
      .from("usage_limits")
      .update({ [field]: used + 1, updated_at: new Date().toISOString() })
      .eq("id", row.id);
  }

  return { allowed, plan, used, limit, enforced };
}
