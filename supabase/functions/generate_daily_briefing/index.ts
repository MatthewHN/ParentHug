// generate_daily_briefing - Today's ParentHug + Before You Walk In.
// Input:  { user_id, family_id, child_id }
// Output: { tiny_parenting_move, recent_context, watch_for, say_this_today,
//           memory_of_day, before_you_walk_in, id }
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient, getUserId } from "../_shared/supabase.ts";
import { callAiJson, coerceShape } from "../_shared/ai.ts";
import { BRIEFING_SYSTEM, buildBriefingUser, placeholderBriefing } from "../_shared/prompts.ts";
import { loadBoardContext, loadChildContext } from "../_shared/context.ts";

const KEYS = [
  "tiny_parenting_move",
  "recent_context",
  "watch_for",
  "say_this_today",
  "memory_of_day",
  "before_you_walk_in",
];

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
    if (!familyId) return jsonResponse({ error: "missing_fields" }, 400);

    const db = adminClient();
    const { data: isMember } = await db.rpc("is_family_member", {
      p_family_id: familyId,
      p_user_id: uid,
    });
    if (!isMember) return jsonResponse({ error: "forbidden" }, 403);

    const child = await loadChildContext(db, childId);
    const board = await loadBoardContext(db, familyId, childId);

    const ai = await callAiJson({
      system: BRIEFING_SYSTEM,
      user: buildBriefingUser(child, board),
    });
    const out = coerceShape(ai, KEYS) ?? placeholderBriefing(child, board);

    // One briefing per family+child+day: replace any existing row for today.
    const today = new Date().toISOString().slice(0, 10);
    let del = db.from("daily_briefings").delete()
      .eq("family_id", familyId).eq("briefing_date", today);
    del = childId ? del.eq("child_id", childId) : del.is("child_id", null);
    await del;

    const { data } = await db
      .from("daily_briefings")
      .insert({
        family_id: familyId,
        child_id: childId,
        created_by: uid,
        briefing_date: today,
        tiny_parenting_move: out.tiny_parenting_move,
        recent_context: out.recent_context,
        watch_for: out.watch_for,
        say_this_today: out.say_this_today,
        memory_of_day: out.memory_of_day,
        before_you_walk_in: out.before_you_walk_in,
      })
      .select("id")
      .single();

    return jsonResponse({ ...out, id: data?.id ?? null });
  } catch (err) {
    console.error("generate_daily_briefing error:", err);
    return jsonResponse({ error: "internal_error" }, 500);
  }
});
