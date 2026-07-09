export type BlogPost = {
  slug: string;
  title: string;
  description: string;
  date: string;
  readTime: string;
  keywords: string[];
  sections: Array<{
    heading: string;
    body: string[];
  }>;
  faqs: Array<{
    question: string;
    answer: string;
  }>;
};

export const blogPosts: BlogPost[] = [
  {
    slug: "what-to-say-when-your-child-is-melting-down",
    title: "What to Say When Your Child Is Melting Down",
    description:
      "A practical guide for parents who need calm, simple words during a toddler or child meltdown.",
    date: "July 9, 2026",
    readTime: "6 min read",
    keywords: [
      "what to say during a child meltdown",
      "toddler tantrum script",
      "gentle parenting phrases",
      "calm parenting app",
      "parenting scripts",
    ],
    sections: [
      {
        heading: "Start with safety, not a speech",
        body: [
          "When a child is melting down, the brain is flooded. Long explanations rarely land. The first job is to make the moment physically safe, lower your own voice, and reduce the number of words.",
          "A good first line is: I am here. You are safe. I will not let you hurt yourself or anyone else.",
        ],
      },
      {
        heading: "Name the limit and the feeling",
        body: [
          "Children need both warmth and structure. If the iPad is off, the answer can stay no while your tone stays kind.",
          "Try: You really wanted more screen time. I hear that. The screen is done, and I can help you be mad about it.",
        ],
      },
      {
        heading: "Use fewer choices",
        body: [
          "Too many options can make a meltdown louder. Offer two simple choices that you can accept.",
          "Try: You can sit by me or on the cushion. You can cry either place. I will stay close.",
        ],
      },
      {
        heading: "Repair after the storm",
        body: [
          "After a child calms down, keep the repair short and clear. This is when teaching can happen, but only after connection returns.",
          "Try: That was hard. I love you. Next time, I will help you stop before it gets that big.",
        ],
      },
    ],
    faqs: [
      {
        question: "What should I not say during a tantrum?",
        answer:
          "Avoid shaming, threatening, lecturing, or asking too many questions. A dysregulated child needs safety, simple words, and a calm adult.",
      },
      {
        question: "Does gentle parenting mean no limits?",
        answer:
          "No. Gentle parenting works best when warmth and boundaries happen together. The limit stays firm while your tone stays steady.",
      },
      {
        question: "Can an app help in the moment?",
        answer:
          "Yes. ParentHug gives short scripts for the exact situation so you do not have to invent calm words while you are stressed.",
      },
    ],
  },
  {
    slug: "repair-after-yelling-at-your-child",
    title: "How to Repair After Yelling at Your Child",
    description:
      "A shame-free parent repair script for reconnecting after yelling, snapping, or losing patience.",
    date: "July 9, 2026",
    readTime: "7 min read",
    keywords: [
      "repair after yelling at child",
      "parent apology script",
      "how to reconnect after yelling",
      "parenting repair script",
      "positive parenting repair",
    ],
    sections: [
      {
        heading: "Repair is not weakness",
        body: [
          "Every parent loses patience sometimes. Repair teaches a child that love can survive conflict and that adults take responsibility for their behavior.",
          "The goal is not a perfect apology. The goal is a clear return to safety and connection.",
        ],
      },
      {
        heading: "Use a simple three-part repair",
        body: [
          "Start by naming what happened, taking responsibility, and telling the child what you will try next time.",
          "Try: I yelled earlier. That was scary and not okay. I am sorry. Next time I will step back and lower my voice.",
        ],
      },
      {
        heading: "Do not ask your child to comfort you",
        body: [
          "A repair can include regret without making the child manage your feelings. Avoid long explanations about how stressed you were.",
          "Try: My big feelings were mine to handle. You did not cause my yelling.",
        ],
      },
      {
        heading: "Make the next moment small",
        body: [
          "A small reconnection often works better than a dramatic one. Sit nearby, offer water, read a book, or invite a short hug if your child wants one.",
          "Try: Do you want space, a hug, or should I sit next to you for a minute?",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I apologize to my child after yelling?",
        answer:
          "Yes. A calm, age-appropriate apology builds trust and models responsibility. Keep it short and do not blame the child for your reaction.",
      },
      {
        question: "What if my child will not accept the repair?",
        answer:
          "Give them time. Repair is an offer, not a demand. Stay kind, respect their space, and show the change through your next actions.",
      },
      {
        question: "How can I stop yelling next time?",
        answer:
          "Plan one pause before you speak. ParentHug can give you a short script for the moment so your stressed brain has words ready.",
      },
    ],
  },
  {
    slug: "gentle-parenting-boundaries-that-work",
    title: "Gentle Parenting Boundaries That Actually Work",
    description:
      "Clear examples of gentle parenting boundaries that stay kind without becoming permissive.",
    date: "July 9, 2026",
    readTime: "7 min read",
    keywords: [
      "gentle parenting boundaries",
      "kind and firm parenting",
      "parenting boundaries examples",
      "positive discipline scripts",
      "how to set limits with children",
    ],
    sections: [
      {
        heading: "Kindness needs a limit to hold",
        body: [
          "Gentle parenting is not the absence of limits. It is the practice of holding a limit without adding shame, fear, or disconnection.",
          "A useful boundary has three parts: name the limit, validate the feeling, and say what happens next.",
        ],
      },
      {
        heading: "Use scripts that are short enough to remember",
        body: [
          "When a child pushes back, parents often talk more because they want to be understood. In the moment, shorter is usually calmer.",
          "Try: I hear you. The answer is still no. I can help you choose what to do next.",
        ],
      },
      {
        heading: "Hold the line with your body, not your volume",
        body: [
          "A boundary becomes easier for a child to trust when your body language matches your words. Move closer, block unsafe behavior, lower your voice, and repeat the same line.",
          "Try: I will not let you hit. I am moving this toy. You can stomp your feet here.",
        ],
      },
      {
        heading: "Offer connection after the limit",
        body: [
          "Connection after a boundary does not cancel the boundary. It helps a child learn that limits and love can exist in the same moment.",
          "Try: You were really mad. I stayed with you. The rule is the same, and I love you.",
        ],
      },
    ],
    faqs: [
      {
        question: "Is gentle parenting too permissive?",
        answer:
          "It can become permissive if limits disappear. Healthy gentle parenting combines warm connection with clear, consistent boundaries.",
      },
      {
        question: "What is an example of a kind boundary?",
        answer:
          "I will not let you throw the cup. You can hand it to me or put it on the table. This gives a clear limit and a safe next step.",
      },
      {
        question: "How can ParentHug help with boundaries?",
        answer:
          "ParentHug gives situation-specific scripts so parents can stay kind and firm without having to invent the wording under pressure.",
      },
    ],
  },
  {
    slug: "bedtime-battles-calm-parenting-script",
    title: "A Calm Parenting Script for Bedtime Battles",
    description:
      "What to say when bedtime turns into stalling, tears, negotiation, or another trip out of bed.",
    date: "July 9, 2026",
    readTime: "6 min read",
    keywords: [
      "bedtime battles script",
      "child will not go to bed",
      "calm bedtime routine",
      "parenting scripts for bedtime",
      "toddler bedtime resistance",
    ],
    sections: [
      {
        heading: "Bedtime resistance is often separation resistance",
        body: [
          "Many children fight bedtime because the day is ending and connection is about to change. Treat the behavior as a signal before you treat it as defiance.",
          "Start with one sentence that names the real feeling: You want more time with me. I get that. It is hard to stop the day.",
        ],
      },
      {
        heading: "Make the routine boring and predictable",
        body: [
          "A bedtime script works best when it repeats. Predictability lowers the negotiation energy because the child knows what comes next.",
          "Try: Bathroom, pajamas, two books, one song, lights out. I will say it the same way every night.",
        ],
      },
      {
        heading: "Use one return-to-bed line",
        body: [
          "When a child gets out of bed repeatedly, adding new arguments can accidentally restart the interaction. Keep the return calm and brief.",
          "Try: It is sleep time. I am walking you back. I will check on you in five minutes.",
        ],
      },
      {
        heading: "Repair the next morning if bedtime got messy",
        body: [
          "If bedtime ended with yelling or tears, repair in daylight when everyone has more capacity. Keep it simple and practical.",
          "Try: Bedtime got hard last night. I am sorry I got loud. Tonight I will use my calm voice and we will follow the same steps.",
        ],
      },
    ],
    faqs: [
      {
        question: "What should I say when my child keeps getting out of bed?",
        answer:
          "Use one repeated line: It is sleep time. I am walking you back. I will check on you soon. Keep your voice low and avoid restarting negotiation.",
      },
      {
        question: "How do I stop bedtime negotiation?",
        answer:
          "Decide the routine before bedtime, repeat it visually or verbally, and avoid adding new choices once lights-out begins.",
      },
      {
        question: "Can ParentHug help with bedtime?",
        answer:
          "Yes. ParentHug can generate a bedtime script based on your child's age, the exact behavior, and the tone you want to use.",
      },
    ],
  },
];

export function getBlogPost(slug: string) {
  return blogPosts.find((post) => post.slug === slug);
}
