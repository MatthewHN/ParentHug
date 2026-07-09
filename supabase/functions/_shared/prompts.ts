// ALL AI prompts + the no-credentials fallback content live here (server-side).
// Fallbacks are deliberately warm and useful so the product demos fully without
// any AI key configured.

export interface ChildContext {
  name?: string | null;
  ageYears?: number | null;
  temperament?: string | null;
  struggles?: string[] | null;
  goals?: string[] | null;
  notes?: string | null;
}

export interface BoardContext {
  headsUp?: string[];
  rules?: string[];
  triggers?: string[];
  wins?: string[];
  wants?: string[];
}

const AGE = (c: ChildContext) =>
  c.ageYears != null ? `${c.ageYears}-year-old` : "young child";
const NAME = (c: ChildContext) => (c.name && c.name.trim()) || "your child";

function childBlurb(c: ChildContext): string {
  const bits: string[] = [];
  bits.push(`Child: ${NAME(c)}${c.ageYears != null ? `, age ${c.ageYears}` : ""}.`);
  if (c.temperament) bits.push(`Temperament: ${c.temperament}.`);
  if (c.struggles?.length) bits.push(`Common struggles: ${c.struggles.join(", ")}.`);
  if (c.goals?.length) bits.push(`Parent goals: ${c.goals.join(", ")}.`);
  if (c.notes) bits.push(`Notes: ${c.notes}.`);
  return bits.join(" ");
}

function boardBlurb(b: BoardContext): string {
  const lines: string[] = [];
  if (b.headsUp?.length) lines.push(`Recent heads-up: ${b.headsUp.join("; ")}.`);
  if (b.rules?.length) lines.push(`Household rules: ${b.rules.join("; ")}.`);
  if (b.triggers?.length) lines.push(`Known triggers: ${b.triggers.join("; ")}.`);
  if (b.wins?.length) lines.push(`Recent wins: ${b.wins.join("; ")}.`);
  if (b.wants?.length) lines.push(`Wants/interests: ${b.wants.join("; ")}.`);
  return lines.length ? lines.join(" ") : "No recent family notes.";
}

// ---------------------------------------------------------------------------
// HUG RESPONSE
// ---------------------------------------------------------------------------
export const HUG_SYSTEM = `You are ParentHug, a warm, calm parenting companion for busy parents.
When a parent describes a hard moment, help them respond well RIGHT NOW.

Voice: warm, practical, concise, non-judgmental, evidence-informed. Never shame
the parent or the child. Avoid medical or psychiatric diagnosis. Do not give
emergency mental-health advice beyond gently recommending professional support
when appropriate. Always give exact words the parent can say out loud.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "regulate":     "one short grounding step for the parent (1 sentence)",
  "say_this":     "exact warm words to say to the child, in quotes",
  "do_next":      "one concrete physical next action",
  "avoid":        "one common mistake to avoid in this moment",
  "repair_later": "one short idea to reconnect afterwards"
}
Keep each value to 1–2 sentences. Match the requested tone.`;

export function buildHugUser(
  situation: string,
  tone: string,
  child: ChildContext,
  board: BoardContext,
): string {
  return [
    `Situation: ${situation}`,
    `Desired tone: ${tone}`,
    childBlurb(child),
    `Family context: ${boardBlurb(board)}`,
  ].join("\n");
}

export function placeholderHug(
  situation: string,
  tone: string,
  child: ChildContext,
): Record<string, string> {
  const name = NAME(child);
  const age = AGE(child);
  const gentle = tone === "firm"
    ? "calm and clear"
    : tone === "quick"
    ? "brief and kind"
    : "gentle";
  return {
    regulate:
      "Drop your shoulders and take one slow breath before you speak — your calm is what helps them borrow calm.",
    say_this:
      `“I can see this is really hard right now. I’m right here with you.” Then, softly: “You’re allowed to be upset. I won’t leave.”`,
    do_next:
      `Get down to ${name}'s eye level, offer a hand or a hug, and name what you see: “You really wanted that.” Give the feeling a moment before fixing anything.`,
    avoid:
      "Avoid lecturing, bargaining, or piling on consequences mid-meltdown — a flooded child can’t hear reasoning yet.",
    repair_later:
      `Later, when ${name} is calm, reconnect: “That was a big feeling. We got through it together.” Keep it ${gentle} and short for a ${age}.`,
  };
}

// ---------------------------------------------------------------------------
// REPAIR SCRIPT
// ---------------------------------------------------------------------------
export const REPAIR_SYSTEM = `You are ParentHug's Repair Mode. A parent lost their cool and wants to reconnect.

Help the parent apologize and reconnect WITHOUT overburdening the child with adult
guilt. Keep scripts short and age-appropriate (very short for young children).
Encourage reconnection. Reassure the parent warmly without excusing genuinely
harmful behavior. Never shame. Avoid diagnosis.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "repair_script":      "short, age-appropriate words to say to the child, in quotes",
  "follow_up":          "one concrete way to reconnect or follow through",
  "parent_reassurance": "kind, grounding reassurance for the parent (2-3 sentences)"
}`;

export function buildRepairUser(
  situation: string,
  parentReaction: string,
  tone: string,
  child: ChildContext,
): string {
  return [
    `What happened: ${situation}`,
    `What the parent did: ${parentReaction}`,
    `Desired tone: ${tone}`,
    childBlurb(child),
  ].join("\n");
}

export function placeholderRepair(
  parentReaction: string,
  child: ChildContext,
): Record<string, string> {
  const name = NAME(child);
  const reaction = parentReaction.replace(/_/g, " ");
  return {
    repair_script:
      `“Hey ${name}, I’m sorry I ${reaction === "other" ? "got upset" : reaction} earlier. That wasn’t about you. I love you, and I’m always going to come back to you.”`,
    follow_up:
      "Offer a hug or sit close for a few minutes with no agenda. Later, if a boundary still matters, restate it calmly and briefly once things feel safe again.",
    parent_reassurance:
      "Rupturing and repairing is how children learn that relationships survive hard moments — your repair matters more than the slip. One tough moment doesn’t undo the thousands of caring ones. You’re a good parent doing hard work.",
  };
}

// ---------------------------------------------------------------------------
// DAILY BRIEFING  (Today's ParentHug + Before You Walk In)
// ---------------------------------------------------------------------------
export const BRIEFING_SYSTEM = `You are ParentHug's daily briefing. Summarize a child's recent context for a
busy parent and give ONE practical move for today. Be gentle and useful. No shame,
no streak pressure. Always include exact "say this" words.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "tiny_parenting_move": "one small, doable action for today (1 sentence)",
  "recent_context":      "2-3 sentence summary of what's going on lately",
  "watch_for":           "one thing to gently watch for today",
  "say_this_today":      "one warm phrase to try today, in quotes",
  "memory_of_day":       "a short, warm nudge to notice or capture a small moment",
  "before_you_walk_in":  "for the parent arriving home: 2 sentences of emotional context + one connecting phrase to open with, in quotes"
}`;

export function buildBriefingUser(child: ChildContext, board: BoardContext): string {
  return [childBlurb(child), `Recent family board: ${boardBlurb(board)}`].join("\n");
}

export function placeholderBriefing(
  child: ChildContext,
  board: BoardContext,
): Record<string, string> {
  const name = NAME(child);
  const context = board.headsUp?.length
    ? board.headsUp.join(" ")
    : `${name} is moving through an ordinary day. Ordinary days are where connection quietly gets built.`;
  return {
    tiny_parenting_move:
      "Find 5 uninterrupted minutes today to follow their lead — let them pick the game, and just join in.",
    recent_context: context,
    watch_for:
      board.triggers?.length
        ? `Watch for a wobble around: ${board.triggers[0]}. A little extra warmth beforehand goes a long way.`
        : "Watch for tiredness or hunger tipping small frustrations into big ones — connection before correction.",
    say_this_today: `“I love being your parent. Even on hard days, I’m so glad you’re mine.”`,
    memory_of_day:
      `Notice one small thing ${name} did today that made you smile — snap a photo or jot it down for the HugBook.`,
    before_you_walk_in:
      board.headsUp?.length
        ? `${name} had some ups and downs today (${board.headsUp[0]}). Start with connection, not correction. Try opening with: “Hey, I heard today had some big feelings — want a hug or a little space?”`
        : `${name} is likely winding down and craving your attention after time apart. Lead with warmth first. Try: “I missed you today — come here, tell me one good thing and one tricky thing.”`,
  };
}
