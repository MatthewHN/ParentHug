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
];

export function getBlogPost(slug: string) {
  return blogPosts.find((post) => post.slug === slug);
}
