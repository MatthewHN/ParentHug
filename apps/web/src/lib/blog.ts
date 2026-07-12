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
  {
    slug: "what-to-say-when-your-child-hits",
    title: "What to Say When Your Child Hits",
    description:
      "Calm, firm scripts for hitting, kicking, and biting that protect everyone without shaming your child.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "what to say when child hits",
      "toddler hitting script",
      "how to stop a child from hitting",
      "gentle parenting aggression",
    ],
    related: [
      "what-to-say-when-your-child-is-melting-down",
      "gentle-parenting-boundaries-that-work",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Block the hit before you explain it",
        body: [
          "When a child hits, safety comes before teaching. Move close enough to gently block their hands or create space between children. A long explanation can wait until their body is calm.",
          "Try: I will not let you hit. I am moving your body back so everyone can be safe.",
        ],
      },
      {
        heading: "Keep the limit clear and the shame out",
        body: [
          "A child can be furious and still need a firm boundary. Avoid labels like mean or bad; they do not teach the skill your child needs next.",
          "Try: You are so mad. Hitting hurts people. You can stomp, squeeze this pillow, or come with me for a reset.",
        ],
      },
      {
        heading: "Practice a safer way after the storm",
        body: [
          "Once your child is regulated, briefly name what happened and rehearse the replacement. Repetition outside the crisis makes the words easier to find next time.",
          "Try: You wanted the truck. Next time say, My turn when you are done. Let us practice that together.",
        ],
      },
      {
        heading: "Make repair an invitation",
        body: [
          "Repair helps the hurt child feel seen and helps the child who hit reconnect without being forced into a performance. Offer a few concrete ways to make things better.",
          "Try: Your brother is hurt. You can bring ice, help rebuild his tower, or give him some space. Which feels right?",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I make my child say sorry after hitting?",
        answer:
          "An immediate forced apology is rarely meaningful. First regulate and protect everyone, then invite your child to repair the harm in a concrete way.",
      },
      {
        question: "Why does my child hit when they are upset?",
        answer:
          "Young children often lack the language, impulse control, or coping skills to handle a big feeling safely. The behavior needs a boundary, but it is also a skill gap to teach.",
      },
      {
        question: "Can ParentHug help with aggressive behavior?",
        answer:
          "Yes. Share the moment, your child's age, and what happened, and ParentHug can give you a short safety-first script to use right away.",
      },
    ],
  },
  {
    slug: "picky-eating-without-power-struggles",
    title: "Picky Eating Without Power Struggles",
    description:
      "A calmer approach to picky eating: what to say at the table and how to step out of the food battle.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "picky eating without power struggles",
      "what to say to picky eater",
      "toddler refuses dinner",
      "calm family meals",
    ],
    related: [
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-talks-back",
      "morning-routine-without-yelling",
    ],
    sections: [
      {
        heading: "Take pressure off the table",
        body: [
          "Food pressure can make an already cautious eater dig in harder. Your job is to offer regular meals and a calm setting; your child can listen to their own hunger and fullness.",
          "Try: This is what we are having. You do not have to eat it. Your body can decide whether it is hungry.",
        ],
      },
      {
        heading: "Keep one familiar food nearby",
        body: [
          "A familiar food gives a cautious child a safe place to begin without turning dinner into a custom order. Serve it alongside, not instead of, the rest of the meal.",
          "Try: I put rice on the table because you usually like it. The chicken and peas can stay on your plate or on the serving dish.",
        ],
      },
      {
        heading: "Use neutral language about food",
        body: [
          "Talking about food as good, bad, clean, or a reward can raise the stakes. Describe what is there and let curiosity do more work than convincing.",
          "Try: These carrots are crunchy. You can smell one, lick one, or leave it alone. All of those are okay.",
        ],
      },
      {
        heading: "End the meal without bargaining",
        body: [
          "When a child says they are done, it helps to trust the routine instead of negotiating another bite. A predictable next snack or meal takes away the panic on both sides.",
          "Try: Okay, dinner is finished. The kitchen is closed until bedtime snack, and you can eat then if your body is hungry.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I make my child take one bite?",
        answer:
          "Pressure can make new foods feel less safe. Offer exposure without demanding a bite, and let repeated low-pressure encounters build familiarity.",
      },
      {
        question: "What if my child only eats a few foods?",
        answer:
          "Keep serving accepted foods with small portions of family foods. If eating is extremely limited, painful, or affecting growth, speak with your child's pediatric clinician or a feeding specialist.",
      },
      {
        question: "How can ParentHug help at dinner?",
        answer:
          "ParentHug can give you a calm line for the exact dinner standoff, so you can hold the routine without turning the meal into a fight.",
      },
    ],
  },
  {
    slug: "separation-anxiety-drop-off-script",
    title: "A Simple Script for Separation Anxiety at Drop-Off",
    description:
      "What to say when preschool, school, or childcare drop-off brings tears, clinging, or a hard goodbye.",
    date: "July 11, 2026",
    readTime: "5 min read",
    keywords: [
      "separation anxiety drop off script",
      "child cries at school drop off",
      "preschool drop off tears",
      "what to say at daycare goodbye",
    ],
    related: [
      "morning-routine-without-yelling",
      "bedtime-battles-calm-parenting-script",
      "what-to-say-when-your-child-is-melting-down",
    ],
    sections: [
      {
        heading: "Treat the tears as connection, not defiance",
        body: [
          "A hard goodbye often means your child is attached to you and unsure about the transition. You can take that feeling seriously without making the goodbye endlessly long.",
          "Try: You wish I could stay. Saying goodbye is hard. Your teacher will help you, and I will come back after snack time.",
        ],
      },
      {
        heading: "Create one predictable goodbye ritual",
        body: [
          "A brief ritual gives your child something reliable to hold onto. Keep it the same each day so the ritual, rather than a new negotiation, carries the moment.",
          "Try: We do two hugs, a high-five, then a window wave. I love you and I will see you after school.",
        ],
      },
      {
        heading: "Leave with confidence once you say goodbye",
        body: [
          "Returning for another goodbye can accidentally teach a child that escalating keeps you there. When the caregiver is ready, follow the ritual and leave warmly and steadily.",
          "Try: I hear you. It is time for me to go now. Ms. Ana is with you. I will be back after lunch.",
        ],
      },
      {
        heading: "Reconnect before you ask for the report",
        body: [
          "At pickup, let your child land with you before asking how the day went. Connection first makes it easier for them to share when they are ready.",
          "Try: I am so glad to see you. Do you want a hug, a snack, or to tell me one thing from your day?",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I sneak out when my child is distracted?",
        answer:
          "Usually no. A predictable goodbye helps children learn that you leave and return. Work with the caregiver on a short ritual instead of disappearing.",
      },
      {
        question: "How long does separation anxiety last?",
        answer:
          "It varies by child and transition. Consistent routines and warm, confident goodbyes often help; discuss persistent distress with your child's clinician or school team.",
      },
      {
        question: "Can ParentHug help with school drop-off?",
        answer:
          "Yes. ParentHug can tailor a short goodbye script to your child's age, the setting, and the part of drop-off that feels hardest.",
      },
    ],
  },
  {
    slug: "potty-training-accidents-what-to-say",
    title: "What to Say After a Potty Training Accident",
    description:
      "A shame-free response to potty accidents that helps children feel safe, capable, and ready to try again.",
    date: "July 11, 2026",
    readTime: "5 min read",
    keywords: [
      "what to say after potty accident",
      "potty training accidents",
      "shame free potty training",
      "toddler toilet learning script",
    ],
    related: [
      "picky-eating-without-power-struggles",
      "what-to-say-when-your-child-is-melting-down",
      "gentle-parenting-boundaries-that-work",
    ],
    sections: [
      {
        heading: "Keep your face and voice neutral",
        body: [
          "Accidents are part of learning body signals and managing a new routine. A big reaction can add embarrassment to something your child is still figuring out.",
          "Try: Your clothes are wet. That happens while we are learning. Let us get cleaned up.",
        ],
      },
      {
        heading: "Focus on the next step, not the mistake",
        body: [
          "The useful lesson is what to do when the body sends a signal. Keep it practical and brief instead of asking why the accident happened.",
          "Try: Pee goes in the potty. Next time your body gives you that feeling, we can walk quickly to the bathroom together.",
        ],
      },
      {
        heading: "Let your child help without making it punishment",
        body: [
          "Involving a child in cleanup can build responsibility when it is framed as a simple family task, not a consequence meant to embarrass them.",
          "Try: I will wipe the floor. You can put these clothes in the basket and choose fresh pants.",
        ],
      },
      {
        heading: "Notice patterns with curiosity",
        body: [
          "A few calm observations can help you adjust timing or routines. Avoid turning every outing into a test; your child needs room to learn gradually.",
          "Try: We had an accident after a long game. Tomorrow I will remind you to try the potty before we start playing.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I punish potty training accidents?",
        answer:
          "No. Punishment or shame can make toilet learning more stressful. Keep cleanup calm and teach the next step instead.",
      },
      {
        question: "What if my child was doing well and starts having accidents?",
        answer:
          "Changes in routine, stress, illness, or simply development can affect toileting. Stay neutral and contact a pediatric clinician if you have concerns about pain, constipation, or a sudden ongoing change.",
      },
      {
        question: "Can ParentHug help during potty training?",
        answer:
          "Yes. Describe the accident or resistance and ParentHug can give you words that keep the moment calm and matter-of-fact.",
      },
    ],
  },
  {
    slug: "public-tantrum-calm-parenting-script",
    title: "A Calm Parenting Script for a Public Tantrum",
    description:
      "What to do and say when your child melts down in a shop, restaurant, airport, or other public place.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "public tantrum script",
      "toddler tantrum in store",
      "what to do during public meltdown",
      "calm parenting in public",
    ],
    related: [
      "what-to-say-when-your-child-is-melting-down",
      "turn-off-screen-time-without-a-meltdown",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Forget the audience and find safety",
        body: [
          "A public meltdown can make any parent feel watched. Bring your attention back to your child and the immediate safety question, not to strangers' opinions.",
          "Try: You are having a hard time. I am taking you somewhere quieter so we can be safe.",
        ],
      },
      {
        heading: "Use one low, steady sentence",
        body: [
          "Your child is unlikely to process a speech in the middle of a storm. A repeatable line steadies you too, especially when you feel embarrassed or rushed.",
          "Try: I will not buy the candy. I will stay with you while you are upset.",
        ],
      },
      {
        heading: "Change the environment when you can",
        body: [
          "A quieter corner, car, hallway, or step outside may lower the stimulation enough for both of you to regroup. Leaving is not giving in when the goal is regulation.",
          "Try: We are taking a reset outside. We can decide about the shopping list when our bodies are calmer.",
        ],
      },
      {
        heading: "Do the teaching later",
        body: [
          "Save reflection for after the child has recovered and you have too. One short repair is more useful than replaying the whole scene.",
          "Try: The store was hard today. Next time you can tell me, I need a break, and we can step outside before it gets so big.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I give in to stop a public tantrum?",
        answer:
          "You can leave or pause the errand to support regulation without changing the limit. Keep the boundary simple and decide later whether the situation needs a different plan next time.",
      },
      {
        question: "What if people are staring?",
        answer:
          "Focus on safety and your child. You do not owe bystanders an explanation. A calm exit or quiet reset is enough.",
      },
      {
        question: "How can ParentHug help in public?",
        answer:
          "ParentHug provides short, usable scripts for the moment, so you have words ready when your nervous system is under pressure too.",
      },
    ],
  },
  {
    slug: "homework-battles-without-yelling",
    title: "How to Handle Homework Battles Without Yelling",
    description:
      "Calm scripts for homework resistance, tears, and avoidance that protect both learning and your relationship.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "homework battles without yelling",
      "child refuses homework",
      "homework resistance script",
      "how to help child with homework",
    ],
    related: [
      "what-to-say-when-your-child-talks-back",
      "morning-routine-without-yelling",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Start by finding the hard part",
        body: [
          "Refusal can mean boredom, overwhelm, hunger, fear of getting it wrong, or a task that is genuinely too hard. Curiosity gets you farther than repeating the instruction.",
          "Try: Homework feels impossible right now. Is the hard part starting, knowing what to do, or worrying about a mistake?",
        ],
      },
      {
        heading: "Make starting smaller",
        body: [
          "A huge assignment can make a child freeze. Shrink the first action until it feels doable, then let momentum build one small step at a time.",
          "Try: We are not doing all of it yet. Let us put your name on the page and read the first question together.",
        ],
      },
      {
        heading: "Be a helper, not the second teacher",
        body: [
          "It is tempting to take over when time is short. Instead, offer support that lets your child do the thinking and lets the teacher see what still needs teaching.",
          "Try: I can read the question with you, help you make a plan, or sit nearby. Which kind of help do you want?",
        ],
      },
      {
        heading: "End with information, not shame",
        body: [
          "If homework repeatedly ends in distress, that is useful information for the school team. Preserve the relationship and communicate the pattern rather than forcing a nightly showdown.",
          "Try: We worked for twenty minutes and this part still feels too hard. I will let your teacher know so we can make a plan.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I make my child finish every homework problem?",
        answer:
          "Follow school expectations where possible, but persistent distress or inability to complete work is worth sharing with the teacher. Avoid turning support into a nightly power struggle.",
      },
      {
        question: "What if my child gets angry when I offer help?",
        answer:
          "Offer choices about the kind of support and take a brief reset if needed. Feeling watched or corrected can add pressure to an already difficult task.",
      },
      {
        question: "Can ParentHug help with homework fights?",
        answer:
          "Yes. ParentHug can help you choose a short, calm response for the specific point where homework gets stuck.",
      },
    ],
  },
  {
    slug: "transitions-without-tears",
    title: "How to Make Transitions Easier for Kids",
    description:
      "Simple scripts for leaving the playground, stopping play, getting in the car, and other everyday transitions.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "how to make transitions easier for kids",
      "leaving playground meltdown",
      "transition scripts for children",
      "toddler transition help",
    ],
    related: [
      "turn-off-screen-time-without-a-meltdown",
      "public-tantrum-calm-parenting-script",
      "bedtime-battles-calm-parenting-script",
    ],
    sections: [
      {
        heading: "Give a warning the child can understand",
        body: [
          "Transitions are easier when they are not surprises. A short, concrete warning gives your child's brain time to shift gears before the change arrives.",
          "Try: Five more pushes on the swing, then we walk to the car. I will count them with you.",
        ],
      },
      {
        heading: "Connect before you direct",
        body: [
          "A moment of eye contact, touch, or shared noticing can make the next instruction easier to hear. You are joining your child before asking them to leave something they enjoy.",
          "Try: You made that tower so tall. I see how proud you are. In two minutes it will be time to clean up.",
        ],
      },
      {
        heading: "Offer a small choice inside the non-negotiable",
        body: [
          "The transition may be fixed, but a small choice gives your child a little agency. Keep both options acceptable and avoid creating a new negotiation.",
          "Try: It is time to go. Do you want to hop to the car or hold my hand while we walk?",
        ],
      },
      {
        heading: "Carry the feeling through the change",
        body: [
          "A child can be upset and still move forward. Naming the loss while helping the transition teaches that big feelings do not have to stop the day.",
          "Try: You are sad to leave. I understand. We are leaving now, and we can put playground time on tomorrow's plan.",
        ],
      },
    ],
    faqs: [
      {
        question: "Why are transitions so hard for my child?",
        answer:
          "Children are developing flexible thinking and self-regulation. Ending something enjoyable or starting something unfamiliar can feel like a real loss or demand.",
      },
      {
        question: "Do transition warnings really help?",
        answer:
          "They often do when they are concrete and consistent. Use a timer, number of turns, or familiar ritual instead of a vague warning your child cannot picture.",
      },
      {
        question: "Can ParentHug help with daily transitions?",
        answer:
          "Yes. Tell ParentHug where the transition happens and what your child does, and it can create a short script and next-step plan.",
      },
    ],
  },
  {
    slug: "when-your-child-lies-what-to-say",
    title: "What to Say When Your Child Lies",
    description:
      "A calm way to respond to lying that builds honesty, responsibility, and enough safety for the truth to come out.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "what to say when child lies",
      "how to respond to child lying",
      "teach children honesty",
      "parenting script for lying",
    ],
    related: [
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-talks-back",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Pause before you accuse",
        body: [
          "Children may lie to avoid trouble, protect someone, test imagination, or because the truth feels overwhelming. An accusation can make honesty feel even less safe.",
          "Try: I found crayons on the wall. I want to understand what happened. You can tell me the truth, and we will handle it together.",
        ],
      },
      {
        heading: "Make truth-telling the easier path",
        body: [
          "Your child still needs accountability, but it helps to separate the mistake from the choice to be honest. Notice the courage it takes to tell the truth.",
          "Try: Thank you for telling me. Drawing on the wall is not okay, and now we can clean it up together.",
        ],
      },
      {
        heading: "Use consequences to repair, not humiliate",
        body: [
          "A related repair teaches more than a punishment meant to make a child feel bad. Keep it practical, proportionate, and focused on what can be made right.",
          "Try: The marker needs to be put away for today. First we will help clean the wall, then we can choose paper for drawing tomorrow.",
        ],
      },
      {
        heading: "Teach the words for next time",
        body: [
          "Once the problem is solved, give your child language for a hard truth. Practicing a simple sentence makes it more available when they need it.",
          "Try: Next time you can say, I did something I think you will be mad about, but I want to tell you.",
        ],
      },
    ],
    faqs: [
      {
        question: "Is lying normal in children?",
        answer:
          "It is common as children develop imagination, self-protection, and an understanding of rules. The response should teach honesty and responsibility rather than label the child.",
      },
      {
        question: "Should there be a consequence for lying?",
        answer:
          "Address the underlying behavior and use a related repair. You can also make clear that honesty helps adults solve problems and rebuild trust.",
      },
      {
        question: "Can ParentHug help me respond calmly?",
        answer:
          "Yes. ParentHug can give you a script that keeps the door open for honesty while still holding a clear boundary.",
      },
    ],
  },
  {
    slug: "preparing-for-a-new-baby-with-a-toddler",
    title: "How to Prepare Your Toddler for a New Baby",
    description:
      "Simple, honest ways to prepare an older child for a new sibling and make room for the big feelings that come with it.",
    date: "July 11, 2026",
    readTime: "7 min read",
    keywords: [
      "prepare toddler for new baby",
      "help child adjust to new sibling",
      "new baby sibling jealousy",
      "what to say about new baby",
    ],
    related: [
      "what-to-say-when-siblings-fight",
      "gentle-parenting-boundaries-that-work",
      "separation-anxiety-drop-off-script",
    ],
    sections: [
      {
        heading: "Use simple, true language",
        body: [
          "Young children do best with concrete explanations close enough to the change to make sense. Share what will affect them without promising that life will stay exactly the same.",
          "Try: A baby is growing in my belly. When the baby comes, they will cry and need a lot of help. You will still have your place in our family.",
        ],
      },
      {
        heading: "Let excitement and worry share the room",
        body: [
          "Your child can love the idea of a baby and dislike the disruptions at the same time. Making space for both feelings helps jealousy feel less forbidden.",
          "Try: You are excited to be a big sibling, and you also wish things would not change. Both feelings make sense.",
        ],
      },
      {
        heading: "Practice the practical changes early",
        body: [
          "If sleep, childcare, rooms, or routines will change, introduce them gradually when possible. That prevents every transition from becoming associated with the baby.",
          "Try: Grandma will do bedtime sometimes when the baby comes. Let us practice our Grandma bedtime routine this week.",
        ],
      },
      {
        heading: "Protect small moments of connection",
        body: [
          "A short predictable ritual with the older child can matter more than a large outing. The message is that connection remains available even when your hands are full.",
          "Try: After the baby's morning feed, you and I will have ten minutes for your book. That is our time.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I involve my toddler in baby preparation?",
        answer:
          "Offer small, optional roles such as choosing a book or bringing a diaper. Involvement can help, but your child does not need to be a helper all the time.",
      },
      {
        question: "What if my older child says they do not want the baby?",
        answer:
          "Stay calm and name the feeling rather than correcting it. You can say that they do not have to like every change and that adults will keep everyone safe and loved.",
      },
      {
        question: "Can ParentHug help with new sibling adjustment?",
        answer:
          "Yes. ParentHug can create gentle scripts for pregnancy questions, jealousy, introductions, and the first hard weeks with a new baby.",
      },
    ],
  },
  {
    slug: "helping-your-child-with-big-worries",
    title: "What to Say When Your Child Has Big Worries",
    description:
      "Supportive scripts for childhood worries, fears, and anxious questions without dismissing what your child feels.",
    date: "July 11, 2026",
    readTime: "6 min read",
    keywords: [
      "what to say when child is worried",
      "help child with anxiety",
      "childhood fears parenting script",
      "calm words for anxious child",
    ],
    related: [
      "bedtime-battles-calm-parenting-script",
      "separation-anxiety-drop-off-script",
      "what-to-say-when-your-child-is-melting-down",
    ],
    sections: [
      {
        heading: "Name the worry before you solve it",
        body: [
          "Reassurance lands better when a child first feels understood. You do not have to agree that danger is likely in order to take their fear seriously.",
          "Try: You are worried that I will not come back after school. That is a really scary thought to carry by yourself.",
        ],
      },
      {
        heading: "Offer a grounded, honest reassurance",
        body: [
          "Avoid promises you cannot make. Instead, name what is true now and the plan for handling the situation, which gives your child something dependable.",
          "Try: I cannot promise you will never feel scared. I can promise your teacher and I know how to help you, and I will be there at pickup.",
        ],
      },
      {
        heading: "Give the worry a small action",
        body: [
          "A simple coping step can help a child feel less alone with a big feeling. Practice it when things are calm so it is familiar when worry arrives.",
          "Try: When the worry comes, put your hand on your heart and take three slow breaths. Then you can tell an adult, I need help with a worry.",
        ],
      },
      {
        heading: "Know when to invite more support",
        body: [
          "Worries deserve extra attention when they are persistent, getting in the way of sleep, school, friendships, or daily life, or causing significant distress. A pediatric clinician or mental-health professional can help you make a plan.",
          "Try: I notice worry is making many parts of the day hard. We are going to talk to someone whose job is helping kids with big worries.",
        ],
      },
    ],
    faqs: [
      {
        question: "Should I tell my child there is nothing to worry about?",
        answer:
          "It is usually more helpful to acknowledge the feeling first. Then offer a calm, truthful reminder of what is safe and what the plan is.",
      },
      {
        question: "When should I seek help for my child's anxiety?",
        answer:
          "Consider professional support when worry is persistent, severe, or interfering with daily life. A pediatric clinician can help you decide on an appropriate next step.",
      },
      {
        question: "Can ParentHug help with anxious moments?",
        answer:
          "ParentHug can offer a short, warm script for the immediate conversation. It is supportive parenting guidance, not a replacement for professional care when a child needs it.",
      },
    ],
  },
  {
    slug: "parenting-app-for-toddler-tantrum-scripts",
    title: "Looking for a Parenting App for Toddler Tantrum Scripts?",
    description:
      "How ParentHug gives parents short, calm words for a toddler tantrum when it is hard to think clearly.",
    date: "July 12, 2026",
    readTime: "6 min read",
    keywords: [
      "parenting app for toddler tantrum scripts",
      "app that tells me what to say during toddler tantrum",
      "ParentHug toddler meltdown help",
      "calm words for tantrums app",
    ],
    related: [
      "what-to-say-when-your-child-is-melting-down",
      "public-tantrum-calm-parenting-script",
      "parenthug-app-for-screen-time-battles",
    ],
    sections: [
      {
        heading: "When you need words, not another parenting article",
        body: [
          "A toddler's meltdown can make even a prepared parent freeze or raise their voice. In that moment, broad advice is less useful than one calm sentence and one safe next step.",
          "ParentHug is built for that gap. You describe what is happening, and the Hug experience gives a short parent-facing response: how to regulate yourself, what to say, what to do next, what to avoid, and how to repair if needed.",
        ],
      },
      {
        heading: "Use the details that matter",
        body: [
          "A script for a tired two-year-old at the supermarket is not the same as one for a six-year-old who cannot leave the playground. ParentHug uses the child context you provide, including birthday, developmental stage, temperament, struggles, goals, notes, and the immediate moment.",
          "That lets the prompt stay specific: My three-year-old is screaming because we left the park, and I am getting overwhelmed. The result is meant to be brief enough to use while the situation is still happening.",
        ],
      },
      {
        heading: "Keep the boundary and the connection",
        body: [
          "The goal is not to make every feeling disappear or to give in. ParentHug is designed around calm, practical language that can validate a child's feeling while keeping a necessary limit in place.",
          "For more examples you can use right away, read [What to Say When Your Child Is Melting Down](/blog/what-to-say-when-your-child-is-melting-down) or [download ParentHug](/download) to have the in-the-moment tool available.",
        ],
      },
    ],
    faqs: [
      {
        question: "Does ParentHug give me a script during a toddler tantrum?",
        answer:
          "Yes. Describe the behavior and context in Hug, and ParentHug returns a concise, practical response with words and next steps for the moment.",
      },
      {
        question: "Can ParentHug help if I am the one getting overwhelmed?",
        answer:
          "Yes. The response starts with parent regulation and keeps the guidance short so it is useful when your own capacity is low.",
      },
      {
        question: "Is ParentHug a replacement for professional care?",
        answer:
          "No. It offers everyday parenting support and scripts. For safety, health, or persistent distress concerns, seek appropriate professional support.",
      },
    ],
  },
  {
    slug: "app-to-repair-after-yelling-at-your-child",
    title: "Is There an App to Help You Repair After Yelling at Your Child?",
    description:
      "How ParentHug Repair Mode gives parents a private, warm script for reconnecting after they lose their cool.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "app to repair after yelling at your child",
      "ParentHug repair mode",
      "parent apology script app",
      "how to reconnect after losing patience app",
    ],
    related: [
      "repair-after-yelling-at-your-child",
      "parenthug-app-for-calm-boundaries",
      "parenting-app-for-toddler-tantrum-scripts",
    ],
    sections: [
      {
        heading: "A hard moment does not have to be the whole story",
        body: [
          "Parents sometimes yell, snap, or say more than they meant to under pressure. The next useful move is not a perfect explanation; it is a clear, age-appropriate return to safety and connection.",
          "ParentHug's Repair Mode is for that next move. It provides a short, warm reconnection script plus reassurance for the parent, without asking you to turn the moment into a public record.",
        ],
      },
      {
        heading: "Use the script after you have enough calm to mean it",
        body: [
          "A repair lands best when your voice and body are steadier. Open Repair, name what happened, and use the response as a guide—not as a speech you have to perform word for word.",
          "A simple repair might name the yelling, take responsibility, say the child did not cause it, and explain what you will try next time. ParentHug keeps this kind of guidance parent-facing and practical.",
        ],
      },
      {
        heading: "Keep repair private and focused",
        body: [
          "Repair Mode keeps generated scripts private to the current session, with no save or share action. The point is to help you return to your child, not to create another task to manage.",
          "You can also read [How to Repair After Yelling at Your Child](/blog/repair-after-yelling-at-your-child) for a simple three-part repair you can practice before the next hard day.",
        ],
      },
    ],
    faqs: [
      {
        question: "What is ParentHug Repair Mode?",
        answer:
          "It is a private ParentHug experience that gives a short, warm script for reconnecting after you lose your cool, plus reassurance for you.",
      },
      {
        question: "Are Repair Mode scripts saved or shared?",
        answer:
          "No. Generated Repair Mode scripts stay private to the session and do not include save or share actions.",
      },
      {
        question: "Can a parenting app fix yelling?",
        answer:
          "An app cannot solve every cause of stress, but it can make a calm next step easier to find. Seek additional support if yelling feels frequent, unsafe, or hard to control.",
      },
    ],
  },
  {
    slug: "shared-parenting-app-for-rules-and-caregiver-updates",
    title: "Need a Shared Parenting App for Rules and Caregiver Updates?",
    description:
      "Why ParentHug's Shared Family Board helps caregivers stay aligned without turning family coordination into another group chat.",
    date: "July 12, 2026",
    readTime: "6 min read",
    keywords: [
      "shared parenting app for rules and caregiver updates",
      "app for coparents to share parenting rules",
      "family caregiver coordination app not chat",
      "ParentHug Shared Family Board",
    ],
    related: [
      "parenthug-daily-parenting-briefing-for-caregivers",
      "parenthug-app-for-screen-time-battles",
      "gentle-parenting-boundaries-that-work",
    ],
    sections: [
      {
        heading: "Keep the important information out of the scroll",
        body: [
          "When caregivers coordinate in a chat, the useful details disappear between logistics and replies. A rule, a trigger, or a hard-won insight should be easy to find when the next caregiver needs it.",
          "ParentHug's Shared Family Board is intentionally not a chat. It gives a family one structured place for rules, heads-up notes, wins, and triggers.",
        ],
      },
      {
        heading: "Create alignment without making every adult identical",
        body: [
          "Caregivers can have different styles while still agreeing on core boundaries and useful context. The board makes it easier to record what helps a child, rather than expecting every adult to remember it in the middle of a busy handoff.",
          "Use it for practical notes such as: screen time ends before dinner; a new babysitter is coming Friday; bedtime went smoothly after two books; loud handoffs are tough after school.",
        ],
      },
      {
        heading: "Pair context with the right words",
        body: [
          "The shared board supports planning, while Hug supports the live moment. Together, they help caregivers begin with the same information and still get specific words when a situation changes fast.",
          "For guidance on holding shared limits kindly, see [Gentle Parenting Boundaries That Actually Work](/blog/gentle-parenting-boundaries-that-work).",
        ],
      },
    ],
    faqs: [
      {
        question: "Is ParentHug a family group chat?",
        answer:
          "No. The Shared Family Board is a structured coordination space for rules, heads-up notes, wins, and triggers—not a chat thread.",
      },
      {
        question: "Can caregivers use ParentHug to stay aligned?",
        answer:
          "Yes. The Shared Family Board is designed to help every caregiver see important context and agreed family guidance.",
      },
      {
        question: "What kinds of notes belong on the board?",
        answer:
          "Useful examples include family rules, upcoming changes, successful routines, and known triggers or needs that help another caregiver respond well.",
      },
    ],
  },
  {
    slug: "parenthug-daily-parenting-briefing-for-caregivers",
    title: "Want a Daily Parenting Briefing Based on Your Child?",
    description:
      "How Today's ParentHug turns your child's context into one gentle daily move and a script to try.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "daily parenting briefing based on child temperament",
      "ParentHug daily briefing",
      "parenting app daily script for my child",
      "personalized daily parenting guidance app",
    ],
    related: [
      "parenting-app-for-toddler-tantrum-scripts",
      "parenthug-before-you-walk-in-parenting-help",
      "morning-routine-without-yelling",
    ],
    sections: [
      {
        heading: "Start the day with one useful idea",
        body: [
          "Parenting advice can feel like another giant list. Today's ParentHug is designed to be smaller: a gentle daily briefing about what may be going on with your child, one tiny move, and a script to try today.",
          "It is a way to prepare before a hard moment arrives instead of opening an app only after everyone is already upset.",
        ],
      },
      {
        heading: "Guidance is grounded in the child context you provide",
        body: [
          "ParentHug uses the child's birthday, developmental stage, temperament, struggles, goals, notes, and relevant context to make the daily response more useful. Child temperament choices include strengths as well as harder traits, so the context does not reduce a child to a problem.",
          "For newborns and infants, the guidance is parent-facing. It does not assume a baby can follow spoken instructions or talk through feelings.",
        ],
      },
      {
        heading: "Turn a briefing into a tiny experiment",
        body: [
          "The best daily move is often small enough to try once: offer a transition warning, set aside ten minutes of connection, or use one clearer bedtime line. Notice what happens and bring that learning into your family's next day.",
          "When you need support in a specific crisis, switch to Hug for an in-the-moment script.",
        ],
      },
    ],
    faqs: [
      {
        question: "What is Today's ParentHug?",
        answer:
          "It is a daily ParentHug briefing with context about your child, one small parenting move, and a script to try that day.",
      },
      {
        question: "Does the daily briefing work for babies?",
        answer:
          "Yes. Guidance for newborns and infants is written for the parent and does not ask a baby to understand spoken instructions or discuss feelings.",
      },
      {
        question: "Can I use the briefing with more than one child?",
        answer:
          "ParentHug supports child profiles and uses the relevant child context when creating guidance. Child profiles are not limited by subscription tier.",
      },
    ],
  },
  {
    slug: "parenthug-app-for-screen-time-battles",
    title: "Need an App for Screen Time Battles and Transition Scripts?",
    description:
      "How ParentHug helps parents find calm, firm words when it is time to turn off the tablet, TV, or game.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "ParentHug app for screen time battles",
      "app for turning off tablet without meltdown",
      "screen time transition script app",
      "what to say when screen time ends app",
    ],
    related: [
      "turn-off-screen-time-without-a-meltdown",
      "parenthug-app-for-calm-boundaries",
      "parenting-app-for-toddler-tantrum-scripts",
    ],
    sections: [
      {
        heading: "Screen time endings need a transition plan",
        body: [
          "The hard part is often not the screen itself but the sudden shift away from something engaging. A calm plan gives you words before the negotiation starts and a next step after the device is off.",
          "ParentHug can help you write a short script for your child's age and the exact conflict, such as refusing to stop a game before dinner or melting down when the TV ends.",
        ],
      },
      {
        heading: "Keep the limit simple enough to repeat",
        body: [
          "A useful screen-time response does not require a lecture. It may name the hard feeling, keep the ending firm, and point to the next part of the routine.",
          "For example: The game is over. Stopping is hard. I am here while you are mad, and next comes snack. The right wording depends on your family, but the structure stays calm and clear.",
        ],
      },
      {
        heading: "Use shared rules to reduce mixed messages",
        body: [
          "When multiple adults care for a child, recording the family screen-time rule on the Shared Family Board can reduce confusion and repeat arguments. The live Hug response can then help when the limit still brings big feelings.",
          "Read [How to Turn Off Screen Time Without a Meltdown](/blog/turn-off-screen-time-without-a-meltdown) for practical warnings and transition ideas.",
        ],
      },
    ],
    faqs: [
      {
        question: "Can ParentHug give me words for ending screen time?",
        answer:
          "Yes. Describe the screen-time standoff in Hug and ParentHug can provide a short, calm script and next step for the moment.",
      },
      {
        question: "Does ParentHug set screen-time controls on devices?",
        answer:
          "ParentHug provides parenting guidance and family coordination, not device-level parental controls.",
      },
      {
        question: "Can caregivers share screen-time rules in ParentHug?",
        answer:
          "Yes. The Shared Family Board can hold family rules and context so caregivers have one place to align on the plan.",
      },
    ],
  },
  {
    slug: "parenthug-before-you-walk-in-parenting-help",
    title: "Need Parenting Help Before You Walk in the Door?",
    description:
      "How ParentHug helps a returning caregiver understand their child's emotional context and choose an opening line before coming home.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "parenting help before walking in the door",
      "ParentHug Before You Walk In",
      "app for reconnecting with child after work",
      "what to say to child when coming home from work",
    ],
    related: [
      "shared-parenting-app-for-rules-and-caregiver-updates",
      "parenthug-daily-parenting-briefing-for-caregivers",
      "repair-after-yelling-at-your-child",
    ],
    sections: [
      {
        heading: "Come home with context, not a guess",
        body: [
          "A returning caregiver may not know that a child skipped a nap, had a rough handoff, or had a wonderful day and wants to show something immediately. Guessing can make the first few minutes harder than they need to be.",
          "ParentHug's Before You Walk In feature gives you the child's emotional context and an opening line before you step through the door.",
        ],
      },
      {
        heading: "Make the first connection intentional",
        body: [
          "The goal is not a perfect reunion. It is a small, informed opening that tells your child you are available. A calm line can make space for a child who is clingy, distant, excited, or already dysregulated.",
          "You might start with: I heard today was big. I am happy to see you. Do you want a hug, to show me something, or for me to sit with you?",
        ],
      },
      {
        heading: "Let the family board inform the handoff",
        body: [
          "Before You Walk In works especially well alongside the Shared Family Board. A caregiver can leave a heads-up note, and the returning parent has a more useful starting point than a rushed recap at the doorway.",
          "The feature is about reducing friction at a transition, not judging how either caregiver managed the day.",
        ],
      },
    ],
    faqs: [
      {
        question: "What is ParentHug Before You Walk In?",
        answer:
          "It gives a returning caregiver their child's emotional context and an opening line before they come home.",
      },
      {
        question: "Who is Before You Walk In for?",
        answer:
          "It is useful for any caregiver returning to a child after work, an errand, travel, or another separation during the day.",
      },
      {
        question: "Can ParentHug help with difficult after-work reunions?",
        answer:
          "Yes. The feature is designed to make the first reconnection more informed and calm, especially when a child's day has been emotionally full.",
      },
    ],
  },
  {
    slug: "private-family-memory-app-for-child-milestones",
    title: "Looking for a Private Family Memory App for Child Milestones?",
    description:
      "How HugBook Memories gives a family a private place for photos, milestones, captions, and moments worth revisiting.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "private family memory app for child milestones",
      "ParentHug HugBook Memories",
      "private app for baby photos and milestones",
      "family memory album with captions",
    ],
    related: [
      "parenthug-daily-parenting-briefing-for-caregivers",
      "preparing-for-a-new-baby-with-a-toddler",
      "shared-parenting-app-for-rules-and-caregiver-updates",
    ],
    sections: [
      {
        heading: "Keep the small moments close to the family",
        body: [
          "Not every memory needs to be posted publicly to matter. HugBook Memories is ParentHug's private family album for the moments that matter, including photos and milestones.",
          "It is designed as part of the same family space as parenting support, so memories can sit beside the everyday context rather than get lost in a camera roll.",
        ],
      },
      {
        heading: "Add the words you will want later",
        body: [
          "A photo may show the moment, but a title or caption can preserve why it mattered: first swimming lesson, a silly phrase, a hard-won bike ride, or an ordinary afternoon that felt like home.",
          "Memory titles are visible as captions and can be searched from HugBook, making it easier to find a specific moment when you want to revisit it.",
        ],
      },
      {
        heading: "Let memories show up in daily family life",
        body: [
          "Today's ParentHug can feature the most recently uploaded memory. When a family has not uploaded one yet, it shows the bundled placeholder instead, keeping the day view complete without pretending there is a family photo.",
          "ParentHug preserves each memory's complete source aspect ratio so the image remains true to the moment you saved.",
        ],
      },
    ],
    faqs: [
      {
        question: "What is HugBook Memories in ParentHug?",
        answer:
          "HugBook Memories is ParentHug's private family album for photos, milestones, and meaningful everyday moments.",
      },
      {
        question: "Can I search family memory captions?",
        answer:
          "Yes. Memory titles appear as captions and are searchable from HugBook.",
      },
      {
        question: "Does ParentHug crop memory images?",
        answer:
          "Memory-of-the-day images preserve their complete source aspect ratio.",
      },
    ],
  },
  {
    slug: "parenthug-app-for-calm-boundaries",
    title: "Can ParentHug Help Me Set Calm Boundaries Without Being Permissive?",
    description:
      "How ParentHug helps parents find kind, firm language for limits around hitting, screens, bedtime, and everyday conflict.",
    date: "July 12, 2026",
    readTime: "6 min read",
    keywords: [
      "ParentHug app for calm boundaries",
      "app for kind and firm parenting scripts",
      "parenting app for setting limits without yelling",
      "gentle parenting boundaries app",
    ],
    related: [
      "gentle-parenting-boundaries-that-work",
      "what-to-say-when-your-child-hits",
      "parenthug-app-for-screen-time-battles",
    ],
    sections: [
      {
        heading: "Warmth and limits can happen in the same sentence",
        body: [
          "A calm boundary does not mean a child gets what they want. It means the parent keeps the necessary limit without adding shame, threats, or a power struggle.",
          "ParentHug is designed to give you simple wording when you need to say no, stop unsafe behavior, end an activity, or hold a routine that your child dislikes.",
        ],
      },
      {
        heading: "Start with the exact moment you are in",
        body: [
          "Generic advice can be hard to translate while a child is yelling, hitting, or refusing to move. In Hug, you can describe the concrete situation and ask for words that match your child's context and the tone you want to use.",
          "The response can help you regulate, say less, offer a safe next step, and avoid escalating the interaction. It is a guide for a moment, not a label for your child.",
        ],
      },
      {
        heading: "Build consistency across caregivers",
        body: [
          "A boundary is easier to trust when caregivers understand the family plan. The Shared Family Board gives adults a place to keep core rules and useful notes visible to the people caring for the child.",
          "For a deeper practical framework, read [Gentle Parenting Boundaries That Actually Work](/blog/gentle-parenting-boundaries-that-work).",
        ],
      },
    ],
    faqs: [
      {
        question: "Does ParentHug support gentle parenting?",
        answer:
          "ParentHug provides non-shaming, practical scripts that combine connection with clear limits. It does not treat gentle parenting as the absence of boundaries.",
      },
      {
        question: "Can ParentHug help when my child hits or talks back?",
        answer:
          "Yes. Describe the moment in Hug and it can give you a concise, situation-specific script and next steps.",
      },
      {
        question: "Can ParentHug make my child comply immediately?",
        answer:
          "No tool can guarantee a child's response. ParentHug helps you choose a calmer, clearer adult response and hold the limit consistently.",
      },
    ],
  },
  {
    slug: "parenting-app-for-grandparents-and-babysitters",
    title: "Can Grandparents and Babysitters Use ParentHug to Follow Our Family Plan?",
    description:
      "How a shared family parenting space can help parents, grandparents, and other caregivers stay aligned on routines and context.",
    date: "July 12, 2026",
    readTime: "5 min read",
    keywords: [
      "parenting app for grandparents and babysitters",
      "app to share child routines with grandparents",
      "caregiver family rules app",
      "ParentHug for babysitters",
    ],
    related: [
      "shared-parenting-app-for-rules-and-caregiver-updates",
      "parenthug-before-you-walk-in-parenting-help",
      "parenthug-app-for-calm-boundaries",
    ],
    sections: [
      {
        heading: "Give every caregiver the helpful version of the plan",
        body: [
          "A grandparent or babysitter does not need a long manual to care well for your child. They do need the few rules, routines, and context details that make a handoff smoother and help the child feel secure.",
          "ParentHug's Shared Family Board creates a structured space for those details: rules, heads-up notes, wins, and triggers. It is more useful than hoping an important text is still visible in a busy group thread.",
        ],
      },
      {
        heading: "Share context, not criticism",
        body: [
          "The best caregiver notes make it easier to support the child rather than score another adult's parenting. A note can explain what helps at bedtime, what changed today, or how a child usually handles a transition.",
          "Try notes such as: she may need a quiet five minutes after pickup; he likes to choose the first bedtime book; please text if he seems unwell. Keep the language specific and collaborative.",
        ],
      },
      {
        heading: "Use Hug when the plan meets real life",
        body: [
          "Even with good notes, hard moments happen. Hug gives a caregiver a concise, practical response for the situation they are facing, while the board helps the family stay on the same page over time.",
          "That combination can support a calmer handoff without expecting every caregiver to parent in exactly the same way.",
        ],
      },
    ],
    faqs: [
      {
        question: "Can grandparents use ParentHug?",
        answer:
          "ParentHug is designed around a shared family space so caregivers can stay aligned on useful rules and context.",
      },
      {
        question: "Can I share routines with a babysitter in ParentHug?",
        answer:
          "The Shared Family Board can hold family rules, heads-up notes, wins, and triggers that make a caregiver handoff clearer.",
      },
      {
        question: "Is the Shared Family Board a chat app?",
        answer:
          "No. It is a structured board rather than a chat, so important family guidance is not buried in a message scroll.",
      },
    ],
  },
  {
    slug: "parenting-app-for-a-childs-birthday-and-developmental-stage",
    title: "Want Parenting Guidance That Considers Your Child's Age and Developmental Stage?",
    description:
      "How ParentHug uses a child's birthday and family-provided context to make in-the-moment scripts more age-aware.",
    date: "July 12, 2026",
    readTime: "6 min read",
    keywords: [
      "parenting app based on child birthday and developmental stage",
      "ParentHug age aware parenting scripts",
      "parenting guidance for child temperament app",
      "personalized parenting app by child age",
    ],
    related: [
      "parenthug-daily-parenting-briefing-for-caregivers",
      "parenting-app-for-toddler-tantrum-scripts",
      "helping-your-child-with-big-worries",
    ],
    sections: [
      {
        heading: "Age-aware guidance changes the words you use",
        body: [
          "A useful response for a newborn, toddler, school-age child, and teenager will not sound the same. ParentHug receives the child's birthday and developmental stage along with relevant family context before it creates Hug, Repair, or daily briefing guidance.",
          "That helps the app keep scripts realistic about what a child can understand, communicate, and practice in the moment.",
        ],
      },
      {
        heading: "A child is more than an age",
        body: [
          "Families can also provide temperament, struggles, goals, notes, and relevant moment context. This can make a suggested response more useful than generic advice while avoiding the idea that a child is defined by one hard behavior.",
          "The app's temperament choices intentionally include strengths alongside more challenging traits, supporting a fuller picture of the child.",
        ],
      },
      {
        heading: "Baby guidance stays with the adult",
        body: [
          "For newborns and infants, ParentHug provides parent-facing guidance. It does not tell a parent to ask a baby to explain feelings, follow a verbal boundary, or use language they have not developed yet.",
          "The result is meant to support the caregiver's next helpful action, whether the question is about soothing, routines, or a difficult family moment.",
        ],
      },
    ],
    faqs: [
      {
        question: "Does ParentHug use my child's age for parenting guidance?",
        answer:
          "Yes. ParentHug receives the child's birthday and developmental stage, along with family-provided context, for Hug, Repair, and daily briefing guidance.",
      },
      {
        question: "Does ParentHug give scripts for babies?",
        answer:
          "For newborns and infants, ParentHug's guidance is parent-facing rather than asking a baby to understand spoken instructions or discuss feelings.",
      },
      {
        question: "Are child profiles restricted by subscription tier?",
        answer:
          "No. Child profiles are not limited by subscription tier.",
      },
    ],
  },
];

export function getBlogPost(slug: string) {
  return blogPosts.find((post) => post.slug === slug);
}
