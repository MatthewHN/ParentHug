// ALL AI prompts + the no-credentials fallback content live here (server-side).
// Fallbacks are deliberately warm and useful so the product demos fully without
// any AI key configured.

export interface ChildContext {
  name?: string | null;
  birthday?: string | null;
  ageYears?: number | null;
  ageMonths?: number | null;
  developmentalStage?: string | null;
  temperament?: string[] | null;
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
export const needsParentFacingGuidance = (c: ChildContext) =>
  c.ageMonths != null && c.ageMonths < 24;

function developmentalRules(c: ChildContext): string {
  const months = c.ageMonths;
  if (months == null) {
    return "Birthday is missing. Avoid age-specific assumptions and keep guidance conservative.";
  }
  if (months < 24) {
    return "This child is under two and cannot be expected to reason, discuss feelings, follow multi-step language, or calm down on request. Address the parent in every words-to-say field and recommend only simple caregiving and co-regulation.";
  }
  if (months < 48) {
    return "Use one-step actions and very short concrete phrases. Do not ask for a feelings discussion, lengthy explanation, or mature self-control.";
  }
  if (months < 96) {
    return "Use simple child-friendly language, play, and concrete choices suitable for a young child.";
  }
  if (months < 144) {
    return "Use school-age language, collaborative problem-solving, and specific practical actions without talking down to the child.";
  }
  if (months < 216) {
    return "Use respectful teen-appropriate language, privacy, autonomy, and collaboration. Do not suggest preschool play, drawing feelings, sticker charts, or bedtime stories.";
  }
  return "Address this person as a young adult. Use respectful adult conversation and autonomy; never suggest child activities, bedtime stories, or parental control scripts.";
}

function childBlurb(c: ChildContext): string {
  const bits: string[] = [];
  bits.push(`Child: ${NAME(c)}.`);
  if (c.birthday) bits.push(`Birthday: ${c.birthday}.`);
  if (c.ageMonths != null) bits.push(`Age: ${c.ageMonths} months.`);
  if (c.ageYears != null) bits.push(`Age in completed years: ${c.ageYears}.`);
  if (c.developmentalStage) bits.push(`Developmental stage: ${c.developmentalStage}.`);
  if (c.temperament?.length) bits.push(`Temperament: ${c.temperament.join(", ")}.`);
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
Apply the supplied developmental requirement exactly. Never ask a child under
two to reason, discuss feelings, follow multi-step language, or calm down on
request. Never give preschool activities or bedtime-story advice to teens or
young adults. Respect notes about disability or neurodivergence without
diagnosing, stereotyping, or treating chronological age as ability.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "regulate":     "one short grounding step for the parent (1 sentence)",
  "say_this":     "exact words for the parent to say to themselves, or to the child only when developmentally appropriate",
  "do_next":      "one concrete physical next action",
  "avoid":        "one common mistake to avoid in this moment",
  "repair_later": "one short idea to reconnect afterwards"
}
Keep each value to 1-2 sentences. Match the requested tone.`;

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
    `Developmental requirement: ${developmentalRules(child)}`,
    `Family context: ${boardBlurb(board)}`,
  ].join("\n");
}

export function placeholderHug(
  situation: string,
  tone: string,
  child: ChildContext,
): Record<string, string> {
  if (needsParentFacingGuidance(child)) {
    return {
      regulate: "Take one slow breath and remind yourself: this is temporary, and you can meet this moment one small step at a time.",
      say_this: "Say to yourself: 'My baby is having a hard moment, not giving me a hard time. I can be the calm here.'",
      do_next: "Check the basics - feeding, sleep, comfort, temperature, or a diaper - then hold, rock, or sit close in the way that usually settles your baby.",
      avoid: "Avoid expecting a newborn or infant to understand instructions, explain feelings, or calm down on request.",
      repair_later: "Give yourself credit for returning to calm. Your steady presence, not perfect words, is what your baby needs.",
    };
  }
  const name = NAME(child);
  const age = AGE(child);
  const gentle = tone === "firm"
    ? "calm and clear"
    : tone === "quick"
    ? "brief and kind"
    : "gentle";
  return {
    regulate:
      "Drop your shoulders and take one slow breath before you speak - your calm is what helps them borrow calm.",
    say_this:
      `“I can see this is really hard right now. I’m right here with you.” Then, softly: “You’re allowed to be upset. I won’t leave.”`,
    do_next:
      `Get down to ${name}'s eye level, offer a hand or a hug, and name what you see: “You really wanted that.” Give the feeling a moment before fixing anything.`,
    avoid:
      "Avoid lecturing, bargaining, or piling on consequences mid-meltdown - a flooded child can’t hear reasoning yet.",
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
Apply the supplied developmental requirement exactly. A child under two must
not receive an apology script they are expected to understand; address the
parent instead. For teens and young adults, use respectful mature language and
never suggest preschool repair activities.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "repair_script":      "short words for parent self-talk, or an apology to the child only when developmentally appropriate",
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
    `Developmental requirement: ${developmentalRules(child)}`,
  ].join("\n");
}

export function placeholderRepair(
  parentReaction: string,
  child: ChildContext,
): Record<string, string> {
  if (needsParentFacingGuidance(child)) {
    return {
      repair_script: "Say to yourself: 'I had a hard moment. I can reset now and give my baby calm, safe care.'",
      follow_up: "Put your baby somewhere safe if you need a breath, then return for simple care: hold them, feed them, change them, or sit close and soothe.",
      parent_reassurance: "Newborns do not need a perfect explanation; they need a parent who keeps returning to safety and care. A pause and reset count.",
    };
  }
  const name = NAME(child);
  const reaction = parentReaction.replace(/_/g, " ");
  return {
    repair_script:
      `“Hey ${name}, I’m sorry I ${reaction === "other" ? "got upset" : reaction} earlier. That wasn’t about you. I love you, and I’m always going to come back to you.”`,
    follow_up:
      "Offer a hug or sit close for a few minutes with no agenda. Later, if a boundary still matters, restate it calmly and briefly once things feel safe again.",
    parent_reassurance:
      "Rupturing and repairing is how children learn that relationships survive hard moments - your repair matters more than the slip. One tough moment doesn’t undo the thousands of caring ones. You’re a good parent doing hard work.",
  };
}

// ---------------------------------------------------------------------------
// DAILY BRIEFING  (Today's ParentHug + Before You Walk In)
// ---------------------------------------------------------------------------
export const BRIEFING_SYSTEM = `You are ParentHug's daily briefing. Summarize a child's recent context for a
busy parent and give ONE practical move for today. Be gentle and useful. No shame,
no streak pressure. Always include exact "say this" words.
Apply the supplied developmental requirement exactly. Guidance for a child
under two must be parent-facing and cannot require language, feeling labels, or
discussion. Guidance for teens and young adults must respect autonomy and must
not suggest preschool play, drawing feelings, or bedtime stories.

Return ONLY a JSON object with EXACTLY these string keys:
{
  "tiny_parenting_move": "one small, doable action for today (1 sentence)",
  "recent_context":      "2-3 sentence summary of what's going on lately",
  "watch_for":           "one thing to gently watch for today",
  "say_this_today":      "one phrase for parent self-talk, or for the child only when developmentally appropriate",
  "memory_of_day":       "a short, warm nudge to notice or capture a small moment",
  "before_you_walk_in":  "for the parent arriving home: 2 sentences of emotional context + one connecting phrase to open with, in quotes"
}`;

export function buildBriefingUser(child: ChildContext, board: BoardContext): string {
  return [
    childBlurb(child),
    `Developmental requirement: ${developmentalRules(child)}`,
    `Recent family board: ${boardBlurb(board)}`,
  ].join("\n");
}

export function placeholderBriefing(
  child: ChildContext,
  board: BoardContext,
): Record<string, string> {
  if (needsParentFacingGuidance(child)) {
    return {
      tiny_parenting_move: "Choose one small reset today: pause, soften your shoulders, and meet one need at a time.",
      recent_context: "Your baby is still learning the world through comfort, rhythm, and your steady presence. There is no need to rush a hard moment into words.",
      watch_for: "Watch for hunger, tiredness, overstimulation, or discomfort, and trust simple soothing before trying to solve more.",
      say_this_today: "Say to yourself: 'This is temporary. I can slow down and be a safe place for my baby.'",
      memory_of_day: "Notice one tiny expression, stretch, or quiet moment today that you may want to remember.",
      before_you_walk_in: "Your baby may need comfort more than conversation after time apart. Start with a calm voice, gentle touch, and the rhythm that helps them settle.",
    };
  }
  const name = NAME(child);
  const context = board.headsUp?.length
    ? board.headsUp.join(" ")
    : `${name} is moving through an ordinary day. Ordinary days are where connection quietly gets built.`;
  return {
    tiny_parenting_move:
      "Find 5 uninterrupted minutes today to follow their lead - let them pick the game, and just join in.",
    recent_context: context,
    watch_for:
      board.triggers?.length
        ? `Watch for a wobble around: ${board.triggers[0]}. A little extra warmth beforehand goes a long way.`
        : "Watch for tiredness or hunger tipping small frustrations into big ones - connection before correction.",
    say_this_today: `“I love being your parent. Even on hard days, I’m so glad you’re mine.”`,
    memory_of_day:
      `Notice one small thing ${name} did today that made you smile - snap a photo or jot it down for the HugBook.`,
    before_you_walk_in:
      board.headsUp?.length
        ? `${name} had some ups and downs today (${board.headsUp[0]}). Start with connection, not correction. Try opening with: “Hey, I heard today had some big feelings - want a hug or a little space?”`
        : `${name} is likely winding down and craving your attention after time apart. Lead with warmth first. Try: “I missed you today - come here, tell me one good thing and one tricky thing.”`,
  };
}
