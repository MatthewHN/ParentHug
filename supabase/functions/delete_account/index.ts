// delete_account - permanently removes the caller and data that belongs only
// to them. The service-role client stays inside this authenticated endpoint;
// no service key is ever exposed to the Flutter app.
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient, getUserId } from "../_shared/supabase.ts";

async function removeInChunks(
  db: ReturnType<typeof adminClient>,
  bucket: string,
  paths: string[],
) {
  for (let index = 0; index < paths.length; index += 100) {
    const { error } = await db.storage.from(bucket).remove(paths.slice(index, index + 100));
    if (error) throw error;
  }
}

Deno.serve(async (req) => {
  const preflight = handleOptions(req);
  if (preflight) return preflight;
  if (req.method !== "POST") return jsonResponse({ error: "method_not_allowed" }, 405);

  const userId = await getUserId(req.headers.get("Authorization"));
  if (!userId) return jsonResponse({ error: "unauthorized" }, 401);

  try {
    const db = adminClient();

    // Remove every photo uploaded by this user first, including photos in a
    // shared family. A family owned by the user is deleted below as a whole.
    const { data: uploadedMemories, error: memoriesError } = await db
      .from("memories")
      .select("id, storage_path")
      .eq("uploaded_by", userId);
    if (memoriesError) throw memoriesError;
    const memoryPaths = (uploadedMemories ?? []).map((memory) => memory.storage_path);
    await removeInChunks(db, "memories", memoryPaths);
    if ((uploadedMemories?.length ?? 0) > 0) {
      const { error } = await db
        .from("memories")
        .delete()
        .in("id", uploadedMemories.map((memory) => memory.id));
      if (error) throw error;
    }

    // Remove content that belongs to the caller from a family they joined.
    // Owned families are deleted in full below, so running these deletes first
    // is safe and makes the privacy promise explicit for shared families too.
    for (const table of [
      "board_items",
      "hug_responses",
      "repair_responses",
      "saved_scripts",
      "daily_briefings",
      "children",
    ]) {
      const { error } = await db.from(table).delete().eq("created_by", userId);
      if (error) throw error;
    }

    // Deleting a family cascades all of its relational data. Storage is not a
    // relational cascade, so remove the family folder contents explicitly.
    const { data: ownedFamilies, error: familiesError } = await db
      .from("families")
      .select("id")
      .eq("created_by", userId);
    if (familiesError) throw familiesError;
    const familyIds = (ownedFamilies ?? []).map((family) => family.id as string);
    for (const familyId of familyIds) {
      const { data: objects, error } = await db
        .schema("storage")
        .from("objects")
        .select("name")
        .eq("bucket_id", "memories")
        .like("name", `${familyId}/%`);
      if (error) throw error;
      await removeInChunks(db, "memories", (objects ?? []).map((object) => object.name));
    }
    if (familyIds.length > 0) {
      const { error } = await db.from("families").delete().in("id", familyIds);
      if (error) throw error;
    }

    const { data: avatarObjects, error: avatarsError } = await db
      .schema("storage")
      .from("objects")
      .select("name")
      .eq("bucket_id", "avatars")
      .like("name", `${userId}/%`);
    if (avatarsError) throw avatarsError;
    await removeInChunks(db, "avatars", (avatarObjects ?? []).map((object) => object.name));

    const { error: deleteError } = await db.auth.admin.deleteUser(userId);
    if (deleteError) throw deleteError;
    return jsonResponse({ ok: true });
  } catch (error) {
    console.error("delete_account error", error);
    return jsonResponse({ error: "account_deletion_failed" }, 500);
  }
});
