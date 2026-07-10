export type BlogPost = {
  slug: string;
  title: string;
  description: string;
  date: string;
  readTime: string;
  keywords: string[];
  // Slugs of related posts, rendered as a "Keep reading" internal-link block.
  related?: string[];
  // Body + answers support inline markdown links: [text](/blog/slug) or
  // [text](/download). Internal (/) links render as Next <Link>.
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
    related: [
      "turn-off-screen-time-without-a-meltdown",
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-talks-back",
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
    related: [
      "what-to-say-when-your-child-is-melting-down",
      "morning-routine-without-yelling",
      "what-to-say-when-siblings-fight",
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
    related: [
      "what-to-say-when-your-child-talks-back",
      "turn-off-screen-time-without-a-meltdown",
      "what-to-say-when-siblings-fight",
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
    related: [
      "morning-routine-without-yelling",
      "what-to-say-when-your-child-is-melting-down",
      "gentle-parenting-boundaries-that-work",
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
  {
    slug: "what-to-say-when-siblings-fight",
    title: "What to Say When Your Kids Won't Stop Fighting",
    description:
      "Calm scripts for sibling fights and rivalry: how to step in without taking sides and coach kids to solve conflict.",
    date: "July 10, 2026",
    readTime: "7 min read",
    keywords: [
      "what to say when siblings fight",
      "how to stop sibling fighting",
      "sibling rivalry scripts",
      "sibling conflict resolution for kids",
      "gentle parenting sibling fights",
    ],
    related: [
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-is-melting-down",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Referee less, coach more",
        body: [
          "When siblings fight, the instinct is to find the culprit and hand down a verdict. But playing judge teaches kids to compete for your ruling instead of learning to work it out. Your job is safety first, then coaching.",
          "Step in calmly and narrate what you see before you fix anything. Try: I see two kids who both want the same truck. Nobody is in trouble. Let's slow this down.",
        ],
      },
      {
        heading: "Name both sides before you solve",
        body: [
          "Each child needs to feel heard before anyone can compromise. Reflect both positions out loud so neither feels like the automatic villain.",
          "Try: You had the truck first and you weren't done. And you were waiting a long time and it felt unfair. Both of those are true.",
        ],
      },
      {
        heading: "Give the conflict back to them",
        body: [
          "Once everyone is calm, hand the problem back with a simple structure. Coaching sounds different from solving: you guide, they decide. This is the same kind-and-firm balance we cover in [gentle parenting boundaries](/blog/gentle-parenting-boundaries-that-work).",
          "Try: The truck is on pause. When you two have a plan you both agree on, it comes off pause. I'll be right here if you need help finding words.",
        ],
      },
      {
        heading: "Protect the relationship, not just the toy",
        body: [
          "After a big fight, resist the urge to lecture. Reconnect both children so the takeaway is repair, not resentment. If it ended with someone hurt or a parent losing patience, a short [repair afterward](/blog/repair-after-yelling-at-your-child) resets everyone.",
          "Try: That got big and loud. You two figured it out in the end. In this family we get mad and we still take care of each other.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I punish the child who started the fight?",
        answer:
          "Usually no. Punishing the 'starter' teaches kids to argue about who is at fault instead of how to solve it. Keep everyone safe, name both sides, and coach a shared solution.",
      },
      {
        question: "How do I handle sibling fights over sharing?",
        answer:
          "Put the disputed item on a short pause instead of forcing a trade. Let the children propose a plan they both accept, which builds negotiation skills over time.",
      },
      {
        question: "Can ParentHug help with sibling fights?",
        answer:
          "Yes. Describe the fight and your kids' ages in [ParentHug](/download) and it gives you a short, fair script for the moment so you don't have to referee on the spot.",
      },
    ],
  },
  {
    slug: "what-to-say-when-your-child-talks-back",
    title: "What to Say When Your Child Talks Back (Without Yelling)",
    description:
      "Scripts for back talk, defiance, and 'you're not the boss of me': hold the limit and keep the connection.",
    date: "July 10, 2026",
    readTime: "6 min read",
    keywords: [
      "what to say when your child talks back",
      "how to respond to back talk",
      "child won't listen script",
      "defiant child what to say",
      "gentle parenting back talk",
    ],
    related: [
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-is-melting-down",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Hear the need under the rudeness",
        body: [
          "Back talk is almost always a clumsy bid for control, connection, or a feeling that isn't landing. The words sting, but reacting to the tone alone usually escalates it.",
          "Take one breath and answer the need, not the attitude. Try: You really don't want to stop right now. I get it. I'm still going to help you stop.",
        ],
      },
      {
        heading: "Separate the message from the delivery",
        body: [
          "You can accept a feeling and still coach the delivery. Kids need to know their voice matters and that how they use it matters too.",
          "Try: You're allowed to be mad at me. You're not allowed to call me names. Tell me the mad part again in a way I can hear.",
        ],
      },
      {
        heading: "Hold the limit without a power struggle",
        body: [
          "Defiance grows when it becomes a tug-of-war. State the limit once, then stop debating it. A calm, repeated line beats a louder one, the same way it does during a full [meltdown](/blog/what-to-say-when-your-child-is-melting-down).",
          "Try: The answer is still no. I'm not going to argue about it, and I'm not mad at you. We can talk more when the shoes are on.",
        ],
      },
      {
        heading: "Circle back to teach the words",
        body: [
          "The lesson lands after the heat, not during it. Once everyone is calm, give your child better language for next time so respect becomes a skill, not just a rule.",
          "Try: Earlier you yelled that I'm the worst. Next time you can say, I'm really frustrated. Want to practice it with me?",
        ],
      },
    ],
    faqs: [
      {
        question: "Is back talk a sign of disrespect?",
        answer:
          "Not usually. In young children it signals big feelings and an underdeveloped brain, not a character flaw. Address safety and tone while still honoring the feeling underneath.",
      },
      {
        question: "What should I not do when my child talks back?",
        answer:
          "Avoid matching their volume, threatening, or debating the limit. Those responses reward the argument. Stay calm, hold the boundary once, and reconnect afterward.",
      },
      {
        question: "How can ParentHug help with a defiant child?",
        answer:
          "Type what your child said and how you want to sound, and [ParentHug](/download) returns a calm, firm script so you're not scrambling for words mid-standoff.",
      },
    ],
  },
  {
    slug: "turn-off-screen-time-without-a-meltdown",
    title: "How to Turn Off Screen Time Without a Meltdown",
    description:
      "A calm script for ending screen time: warnings, transitions, and exactly what to say when the tablet goes off.",
    date: "July 10, 2026",
    readTime: "6 min read",
    keywords: [
      "how to turn off screen time without a meltdown",
      "screen time transition script",
      "what to say when turning off the tv",
      "ending screen time tantrum",
      "gentle parenting screen time",
    ],
    related: [
      "what-to-say-when-your-child-is-melting-down",
      "gentle-parenting-boundaries-that-work",
      "bedtime-battles-calm-parenting-script",
    ],
    sections: [
      {
        heading: "The meltdown is about the transition, not the screen",
        body: [
          "Screens are engineered to feel good, so stopping is a real loss for a child's brain. The tears when the tablet goes off are usually about the hard transition, not defiance.",
          "Naming that upfront lowers the temperature. Try: Stopping something fun is really hard. I'm going to help you do the hard part.",
        ],
      },
      {
        heading: "Warn the brain before you touch the button",
        body: [
          "Abrupt endings trigger the biggest reactions. Give a concrete, visible heads-up so the transition doesn't feel like an ambush.",
          "Try: Two more minutes, then we turn it off together. I'll set the timer so it's the timer's job, not mine.",
        ],
      },
      {
        heading: "Name the feeling, keep the limit",
        body: [
          "When the screen goes off and the storm hits, you can hold the boundary and the child at the same time. It's the same kind-and-firm move that works for any [meltdown](/blog/what-to-say-when-your-child-is-melting-down).",
          "Try: The show is done for today. You're allowed to be really upset about it. I'm right here while you feel it.",
        ],
      },
      {
        heading: "Build a landing pad after the screen",
        body: [
          "Transitions get easier when there's something to move toward, not just away from. A predictable next step gives the brain somewhere to go. Limits like these are easier to hold when caregivers agree on them, which is where clear [family boundaries](/blog/gentle-parenting-boundaries-that-work) help.",
          "Try: Screen is off. Now it's snack and backyard time. Do you want to hop like a frog or walk like a bear to the kitchen?",
        ],
      },
    ],
    faqs: [
      {
        question: "How do I stop the tablet tantrum before it starts?",
        answer:
          "Give a short, concrete warning and use a timer so the device, not you, signals the end. Then narrate the transition to what comes next instead of leaving a void.",
      },
      {
        question: "Should screen time have the same rules every day?",
        answer:
          "Predictable limits reduce negotiation. When kids know the pattern, ending screen time becomes routine rather than a daily surprise to fight about.",
      },
      {
        question: "Can ParentHug help with screen time battles?",
        answer:
          "Yes. Tell [ParentHug](/download) your child's age and the exact standoff, and it gives you a short transition script to use in the moment.",
      },
    ],
  },
  {
    slug: "morning-routine-without-yelling",
    title: "How to Get Through the Morning Routine Without Yelling",
    description:
      "Scripts and a calm system for school mornings: getting dressed, out the door, and drop-off without the fight.",
    date: "July 10, 2026",
    readTime: "7 min read",
    keywords: [
      "morning routine without yelling",
      "how to get kids ready for school without yelling",
      "school morning meltdown",
      "getting out the door with kids script",
      "school drop off separation anxiety",
    ],
    related: [
      "bedtime-battles-calm-parenting-script",
      "what-to-say-when-your-child-is-melting-down",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Front-load the morning the night before",
        body: [
          "Most morning battles are decisions that could have happened the night before. Clothes, shoes, and bags chosen at night remove the exact friction points that spark yelling. It's the same predictability that calms [bedtime](/blog/bedtime-battles-calm-parenting-script).",
          "Try, the night before: Let's pick tomorrow's outfit now so morning-you has less to do. Shoes by the door or in your room?",
        ],
      },
      {
        heading: "Use a visual, not a nag",
        body: [
          "Repeating instructions turns you into the alarm clock everyone tunes out. A simple picture chart or checklist lets the routine do the reminding.",
          "Try: What's next on your morning list? You check it, not me. I'll be making breakfast.",
        ],
      },
      {
        heading: "Scripts for the three hardest moments",
        body: [
          "Getting dressed, shoes on, and out the door are where mornings usually break. Keep each line short and connected. If it still boils over, a quick [in-the-moment reset](/blog/what-to-say-when-your-child-is-melting-down) beats pushing harder.",
          "Try, for the door: The car leaves in five minutes. You can walk to the car or hop to it. Either way, we're leaving on time.",
        ],
      },
      {
        heading: "A calm drop-off line",
        body: [
          "Separation anxiety at drop-off is a sign of attachment, not weakness. A short, confident goodbye ritual reassures a child more than a long, anxious one. If mornings have been rough lately, a quick [repair](/blog/repair-after-yelling-at-your-child) later resets the day.",
          "Try: Two hugs and a wave at the window. I always come back. See you at pickup.",
        ],
      },
    ],
    faqs: [
      {
        question: "How do I get my kids ready for school without yelling?",
        answer:
          "Move decisions to the night before, replace verbal nagging with a visual checklist, and use short scripted lines for the hardest moments so you are not improvising under time pressure.",
      },
      {
        question: "What do I say at a hard school drop-off?",
        answer:
          "Use a brief, predictable goodbye ritual and a confident reassurance like 'I always come back.' A short, calm goodbye lowers separation anxiety more than lingering does.",
      },
      {
        question: "Can ParentHug help with school mornings?",
        answer:
          "Yes. Tell [ParentHug](/download) which part of the morning falls apart and it builds a short routine and script tailored to your child's age and temperament.",
      },
    ],
  },
];

export function getBlogPost(slug: string) {
  return blogPosts.find((post) => post.slug === slug);
}
