// generate_repair_script — "I lost my cool" Repair Mode.
// Input:  { user_id, family_id, child_id, situation, parent_reaction, tone }
// Output: { repair_script, follow_up, parent_reassurance, id }
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient, getUserId } from "../_shared/supabase.ts";
import { callAiJson, coerceShape } from "../_shared/ai.ts";
import { buildRepairUser, placeholderRepair, REPAIR_SYSTEM } from "../_shared/prompts.ts";
import { loadChildContext } from "../_shared/context.ts";
import { needsSafety, safetyRepair } from "../_shared/safety.ts";
import { trackUsage } from "../_shared/usage.ts";

const KEYS = ["repair_script", "follow_up", "parent_reassurance"];

// deno-lint-ignore no-explicit-any
async function save(db: any, r: Record<string, any>) {
  const { data } = await db
    .from("repair_responses")
    .insert({
      family_id: r.familyId,
      child_id: r.childId,
      created_by: r.uid,
      situation: r.situation,
      parent_reaction: r.parentReaction,
      tone: r.tone,
      repair_script: r.out.repair_script,
      follow_up: r.out.follow_up,
      parent_reassurance: r.out.parent_reassurance,
    })
    .select("id")
    .single();
  return data?.id ?? null;
}

Deno.serve(async (req) => {
  const pre = handleOptions(req);
  if (pre) return pre;
  if (req.method !== "POST") return jsonResponse({ error: "method_not_allowed" }, 405);

  try {
    const uid = await getUserId(req.headers.get("Authorization"));
    if (!uid) return jsonResponse({ error: "unauthorized" }, 401);

    const body = await req.json().catch(() => ({}));
    const familyId = body.family_id as string;
    const childId = (body.child_id as string) ?? null;
    const situation = String(body.situation ?? "").trim();
    const parentReaction = (body.parent_reaction as string) ?? "other";
    const tone = (body.tone as string) ?? "gentle";
    if (!familyId || !situation) return jsonResponse({ error: "missing_fields" }, 400);

    const db = adminClient();

    const { data: isMember } = await db.rpc("is_family_member", {
      p_family_id: familyId,
      p_user_id: uid,
    });
    if (!isMember) return jsonResponse({ error: "forbidden" }, 403);

    if (needsSafety(situation)) {
      const safe = safetyRepair();
      const id = await save(db, { familyId, childId, uid, situation, parentReaction, tone, out: safe });
      return jsonResponse({ ...safe, id, safety: true });
    }

    const usage = await trackUsage(db, familyId, "repair");
    if (!usage.allowed) {
      return jsonResponse(
        { error: "usage_limit", code: "upgrade_required", ...usage },
        402,
      );
    }

    const child = await loadChildContext(db, childId);
    const ai = await callAiJson({
      system: REPAIR_SYSTEM,
      user: buildRepairUser(situation, parentReaction, tone, child),
    });
    const out = coerceShape(ai, KEYS) ?? placeholderRepair(parentReaction, child);

    const id = await save(db, { familyId, childId, uid, situation, parentReaction, tone, out });
    return jsonResponse({ ...out, id, plan: usage.plan });
  } catch (err) {
    console.error("generate_repair_script error:", err);
    return jsonResponse({ error: "internal_error" }, 500);
  }
});
