// Loads child + Family Board context for the AI functions (service role).
import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";
import { BoardContext, ChildContext } from "./prompts.ts";

export function ageFromBirthday(birthday?: string | null): number | null {
  if (!birthday) return null;
  const bd = new Date(birthday);
  if (isNaN(bd.getTime())) return null;
  const now = new Date();
  let age = now.getFullYear() - bd.getFullYear();
  const m = now.getMonth() - bd.getMonth();
  if (m < 0 || (m === 0 && now.getDate() < bd.getDate())) age--;
  return age >= 0 ? age : null;
}

export async function loadChildContext(
  db: SupabaseClient,
  childId?: string | null,
): Promise<ChildContext> {
  if (!childId) return {};
  const { data } = await db.from("children").select("*").eq("id", childId).maybeSingle();
  if (!data) return {};
  return {
    name: data.name,
    ageYears: ageFromBirthday(data.birthday),
    temperament: data.temperament,
    struggles: data.common_struggles,
    goals: data.parent_goals,
    notes: data.notes,
  };
}

export async function loadBoardContext(
  db: SupabaseClient,
  familyId: string,
  childId?: string | null,
): Promise<BoardContext> {
  const { data } = await db
    .from("board_items")
    .select("category,title,body,child_id,created_at")
    .eq("family_id", familyId)
    .eq("archived", false)
    .order("created_at", { ascending: false })
    .limit(40);

  const rows = (data ?? []).filter(
    (r) => !childId || r.child_id === childId || r.child_id === null,
  );
  const pick = (cat: string) =>
    rows
      .filter((r) => r.category === cat)
      .slice(0, 5)
      .map((r) => (r.body ? `${r.title}: ${r.body}` : r.title));

  return {
    headsUp: pick("heads_up"),
    rules: pick("rules"),
    triggers: pick("triggers"),
    wins: pick("wins"),
    wants: pick("wants"),
  };
}
