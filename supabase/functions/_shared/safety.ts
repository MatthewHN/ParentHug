// Lightweight safety guard. If a situation mentions violence, self-harm, or
// abuse, we bypass the normal flow and return a calm response that prioritizes
// safety and steers toward professional support. This is intentionally
// conservative and is NOT a substitute for real crisis tooling.

const RED_FLAGS: RegExp[] = [
  /suicid|kill myself|end my life|want to die|self.?harm|hurt myself/i,
  /\b(hit|hurt|shake|shaking|choke|strangl|punch|beat)\s+(the\s+)?(baby|infant|newborn)\b/i,
  /\bwant to hurt (the|my)\b/i,
  /\babuse|abusive|molest\b/i,
  /can'?t stop (crying|shaking) and .*(baby|child)/i,
];

export function needsSafety(text: string): boolean {
  const t = (text ?? "").toLowerCase();
  return RED_FLAGS.some((re) => re.test(t));
}

/** Safe response in the Hug shape. */
export function safetyHug(): Record<string, string> {
  return {
    regulate:
      "Take one slow breath. If anyone is in immediate danger, contact your local emergency number right now. You are not alone, and reaching out is a sign of strength.",
    say_this:
      "“I need a moment to keep us both safe.” It is okay to step away to a safe spot for a minute if your child is safe.",
    do_next:
      "Put the child somewhere safe (crib or floor), step back, and call someone you trust or a professional support line. In the US you can call or text 988 (Suicide & Crisis Lifeline).",
    avoid:
      "Avoid acting on any urge to harm yourself or your child, and avoid staying alone with these feelings.",
    repair_later:
      "When things are calmer, talk to a doctor, therapist, or a trusted person. Asking for help protects your family - this does not make you a bad parent.",
  };
}

/** Safe response in the Repair shape. */
export function safetyRepair(): Record<string, string> {
  return {
    repair_script:
      "“I love you, and I’m getting some help so I can be the parent you deserve.”",
    follow_up:
      "If anyone is in danger, contact your local emergency number. Reach out to a doctor, therapist, or a support line such as 988 (US) today.",
    parent_reassurance:
      "Noticing that you need support is exactly the right instinct. You deserve help, and getting it is one of the strongest things a parent can do.",
  };
}
