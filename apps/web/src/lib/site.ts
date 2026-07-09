// Central site config, driven by NEXT_PUBLIC_* env (with safe placeholders).
export const site = {
  name: "ParentHug",
  domain: "parenthug.app",
  url: process.env.NEXT_PUBLIC_SITE_URL || "https://parenthug.app",
  supportEmail: process.env.NEXT_PUBLIC_SUPPORT_EMAIL || "support@parenthug.app",
  appStoreUrl: process.env.NEXT_PUBLIC_APP_STORE_URL || "#",
  googlePlayUrl: process.env.NEXT_PUBLIC_GOOGLE_PLAY_URL || "#",
  tagline: "The next right words when parenting gets hard.",
};

export const features = [
  {
    emoji: "🫂",
    title: "The Hug Button",
    body: "Type what's happening and get calm, practical words in seconds — regulate, say this, do next, avoid, repair.",
    color: "var(--coral)",
  },
  {
    emoji: "📋",
    title: "Shared Family Board",
    body: "Not a chat — a structured board so both parents stay aligned on rules, heads-ups, wins, and triggers.",
    color: "var(--primary)",
  },
  {
    emoji: "🌤️",
    title: "Today's ParentHug",
    body: "A gentle daily briefing: what's going on with your child, one tiny move, and a script to try today.",
    color: "var(--yellow)",
  },
  {
    emoji: "🌈",
    title: "Repair Mode",
    body: "Lost your cool? Get a short, warm script to reconnect — plus reassurance for you.",
    color: "var(--mint)",
  },
  {
    emoji: "🚪",
    title: "Before You Walk In",
    body: "Coming home? Get your child's emotional context and an opening line before you step through the door.",
    color: "var(--violet)",
  },
  {
    emoji: "📸",
    title: "HugBook Memories",
    body: "A private family album for the moments that matter — with milestones and 'this day last year'.",
    color: "var(--teal)",
  },
];
