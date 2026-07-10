---
name: write-blog-posts
description: Write SEO/GEO blog posts for the ParentHug parenting blog. Use whenever the user asks to "write N more blog posts", "add a blog post", or similar. Encodes the exact voice, structure, keyword strategy, internal-linking, and app-plug conventions so posts ship consistently.
---

# Writing ParentHug blog posts

ParentHug's blog is a programmatic SEO/GEO play: each post targets a **high-intent
long-tail keyword** a stressed parent would search ("what to say when…", "how to
… without yelling"), answers it with calm, concrete scripts, and subtly routes the
reader to the app. Goal: own the "parenting scripts" topic cluster in both search
engines and AI answer engines (ChatGPT/Perplexity/AI Overviews).

## Where everything lives
- **Content:** `apps/web/src/lib/blog.ts` — one `BlogPost` object per post in the
  `blogPosts` array. This is the ONLY file you author content in.
- **Rendering (already built, don't rewrite):** `apps/web/src/app/blog/[slug]/page.tsx`
  parses inline markdown links in `body`/`faqs`, renders a "Keep reading" block
  from `related`, appends the app CTA, and emits Article + FAQ JSON-LD.
- **Index + sitemap:** `apps/web/src/app/blog/page.tsx` and `app/sitemap.ts` map
  `blogPosts` automatically — new posts appear with no extra work.

## The `BlogPost` schema
```ts
{
  slug: string;          // kebab-case, IS the target keyword (e.g. "how-to-stop-a-tantrum-in-public")
  title: string;         // Title Case, contains the keyword; a real search phrase
  description: string;   // 1 sentence, ~140–160 chars, contains the keyword
  date: string;          // "Month D, YYYY" (use today's date)
  readTime: string;      // "6 min read" / "7 min read"
  keywords: string[];    // 5 high-intent long-tail phrases (see below)
  related: string[];     // 3 slugs of related posts (internal linking)
  sections: { heading; body: string[] }[]; // 4 sections, 2 paragraphs each
  faqs: { question; answer }[];             // 3 FAQs (GEO); last one plugs the app
}
```

## Voice (match the existing posts exactly)
- Warm, calm, plain. Short sentences. Talk to a stressed parent, not down to them.
- Non-preachy, non-clinical. No jargon, no "As a parent, you know…" filler.
- Every section gives a concrete script on its own line starting with **`Try: …`**.
- Scripts are short and speakable — the words a parent could actually say out loud.
- No shaming of the parent or child. Assume good intent and a hard moment.
- American English. No em dashes in body copy; use plain sentences.

## Structure of each post
1. **4 sections**, each with a short imperative `heading` and **2 short paragraphs**.
   Paragraph 1 = the idea/reframe; paragraph 2 (or end of 1) = a `Try: …` script.
   A good arc: (1) reframe the behavior, (2) validate the feeling, (3) hold the
   limit / coach, (4) repair / connect afterward.
2. **3 FAQs** phrased as real search/voice queries ("What should I not say when…?",
   "How do I…?"). **Answer-first**: the first sentence directly answers, then 1–2
   sentences of detail. This is what wins featured snippets and AI answers (GEO).
   The **last FAQ** is always "Can/does ParentHug help with X?" and plugs the app.

## Keyword strategy (SEO)
- The **slug + title + description + keywords[0]** all revolve around ONE primary
  high-intent phrase. Prefer buyer/searcher intent: "what to say when…",
  "how to … without yelling", "…script", "…won't stop …".
- `keywords` = 5 variations/related phrases (synonyms, age variants, question forms).
- **Pick a NEW angle every time.** Before writing, read `blog.ts` and list existing
  slugs so you don't overlap. Untapped angles include: hitting/biting, whining,
  picky eating/mealtime, potty-training regressions, separation anxiety, lying,
  public tantrums, transitions, homework battles, spirited/ADHD kids,
  co-parenting alignment, praise vs encouragement, natural consequences.

## Internal linking (REQUIRED on every post)
- **Inline links:** weave **2–3** contextual links into the `body` using markdown
  `[anchor text](/blog/other-slug)`. Anchor text must be natural and descriptive
  (not "click here"). Link where it genuinely helps the reader.
- **`related`:** set 3 relevant sibling slugs → renders the "Keep reading" block.
- **Bidirectional:** after adding a new post, also add its slug to the `related`
  array (and, where natural, an inline link) of the 1–3 existing posts it relates
  to. A tight cluster > orphan pages.

## App plug (subtle, once or twice per post)
- One natural inline mention linking `[ParentHug](/download)` inside a body
  paragraph where it fits (usually the "coach/repair" section), framed as the tool
  that hands you the words in the moment — never a hard sell.
- Plus the final FAQ ("Can ParentHug help with X?") with `[ParentHug](/download)`.
- Keep it helpful and understated. The reader should feel helped, then curious.

## Workflow
1. Read `apps/web/src/lib/blog.ts`; list existing slugs + angles.
2. Choose N fresh angles + primary keywords (state them to the user).
3. Append N new `BlogPost` objects to the `blogPosts` array (before the closing `];`).
4. Add each new slug into the `related` of the existing posts it pairs with
   (bidirectional links).
5. Verify: `preview_start` the `web` server, open `/blog` (count grew) and one new
   post; confirm inline links + "Keep reading" + CTA render and the rendered
   `<article>` has NO raw `[..](..)` markdown (the RSC hydration script harmlessly
   contains it — ignore that; only the visible article matters). Check no console errors.
6. Commit + push (the user's repo is direct-to-`master`).

## Guardrails
- Do NOT invent statistics, studies, or expert quotes. Keep claims experiential.
- Keep medical/safety framing responsible; nothing that discourages professional help.
- Match the existing formatting exactly so the file stays consistent and diffable.
