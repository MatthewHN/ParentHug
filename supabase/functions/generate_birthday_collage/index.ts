// generate_birthday_collage — STUB with production-ready architecture.
//
// MVP behaviour: gathers a child's birthday memories and returns the ordered
// list of source images plus a "pending" status. Real collage/video rendering
// (an async render job writing a file to Storage) is future work — the shape
// below is what the client already renders against, so swapping in a real
// renderer requires no client change.
//
// Input:  { user_id, family_id, child_id }
// Output: { status, child_id, title, message, source_images:[{path,memory_date,title}], collage_url }
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient, getUserId } from "../_shared/supabase.ts";

Deno.serve(async (req) => {
  const pre = handleOptions(req);
  if (pre) return pre;
  if (req.method !== "POST") return jsonResponse({ error: "method_not_allowed" }, 405);

  try {
    const uid = await getUserId(req.headers.get("Authorization"));
    if (!uid) return jsonResponse({ error: "unauthorized" }, 401);

    const body = await req.json().catch(() => ({}));
    const familyId = body.family_id as string;
    const childId = body.child_id as string;
    if (!familyId || !childId) return jsonResponse({ error: "missing_fields" }, 400);

    const db = adminClient();
    const { data: isMember } = await db.rpc("is_family_member", {
      p_family_id: familyId,
      p_user_id: uid,
    });
    if (!isMember) return jsonResponse({ error: "forbidden" }, 403);

    const { data: child } = await db
      .from("children")
      .select("name")
      .eq("id", childId)
      .maybeSingle();

    const { data: memories } = await db
      .from("memories")
      .select("storage_path, memory_date, title")
      .eq("family_id", familyId)
      .eq("child_id", childId)
      .eq("milestone_type", "birthday")
      .order("memory_date", { ascending: true });

    const sources = (memories ?? []).map((m) => ({
      path: m.storage_path,
      memory_date: m.memory_date,
      title: m.title,
    }));

    const name = child?.name ?? "your child";
    return jsonResponse({
      status: "pending", // becomes "ready" once a real renderer is wired up
      child_id: childId,
      title: `${name}'s Birthday Collage`,
      message: sources.length
        ? `Found ${sources.length} birthday memories. Collage rendering is coming soon — you'll be notified when ${name}'s collage is ready.`
        : `Add a few of ${name}'s past birthday photos to the HugBook, then we can build a collage.`,
      source_images: sources,
      collage_url: null,
    });
  } catch (err) {
    console.error("generate_birthday_collage error:", err);
    return jsonResponse({ error: "internal_error" }, 500);
  }
});
