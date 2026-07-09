// generate_hug_response — the core Hug Button.
// Input:  { user_id, family_id, child_id, situation, tone }
// Output: { regulate, say_this, do_next, avoid, repair_later, id }
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient, getUserId } from "../_shared/supabase.ts";
import { callAiJson, coerceShape } from "../_shared/ai.ts";
import { buildHugUser, HUG_SYSTEM, placeholderHug } from "../_shared/prompts.ts";
import { loadBoardContext, loadChildContext } from "../_shared/context.ts";
import { needsSafety, safetyHug } from "../_shared/safety.ts";
import { trackUsage } from "../_shared/usage.ts";

const KEYS = ["regulate", "say_this", "do_next", "avoid", "repair_later"];

// deno-lint-ignore no-explicit-any
async function save(db: any, r: Record<string, any>) {
  const { data } = await db
    .from("hug_responses")
    .insert({
      family_id: r.familyId,
      child_id: r.childId,
      created_by: r.uid,
      situation: r.situation,
      tone: r.tone,
      regulate: r.out.regulate,
      say_this: r.out.say_this,
      do_next: r.out.do_next,
      avoid: r.out.avoid,
      repair_later: r.out.repair_later,
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
    const tone = (body.tone as string) ?? "gentle";
    if (!familyId || !situation) return jsonResponse({ error: "missing_fields" }, 400);

    const db = adminClient();

    const { data: isMember } = await db.rpc("is_family_member", {
      p_family_id: familyId,
      p_user_id: uid,
    });
    if (!isMember) return jsonResponse({ error: "forbidden" }, 403);

    // Safety first — bypass AI + usage limits for concerning input.
    if (needsSafety(situation)) {
      const safe = safetyHug();
      const id = await save(db, { familyId, childId, uid, situation, tone, out: safe });
      return jsonResponse({ ...safe, id, safety: true });
    }

    const usage = await trackUsage(db, familyId, "hug");
    if (!usage.allowed) {
      return jsonResponse(
        { error: "usage_limit", code: "upgrade_required", ...usage },
        402,
      );
    }

    const child = await loadChildContext(db, childId);
    const board = await loadBoardContext(db, familyId, childId);
    const ai = await callAiJson({
      system: HUG_SYSTEM,
      user: buildHugUser(situation, tone, child, board),
    });
    const out = coerceShape(ai, KEYS) ?? placeholderHug(situation, tone, child);

    const id = await save(db, { familyId, childId, uid, situation, tone, out });
    return jsonResponse({ ...out, id, plan: usage.plan });
  } catch (err) {
    console.error("generate_hug_response error:", err);
    return jsonResponse({ error: "internal_error" }, 500);
  }
});
