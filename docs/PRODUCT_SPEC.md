# ParentHug - Product Spec

> **The next right words when parenting gets hard.**

---

## 1. Positioning

ParentHug is a **shared parenting companion for modern families**. It
turns overwhelming moments into calm, practical action, and keeps trusted caregivers on
the same page.

Most parenting apps are either trackers (sleep/feeding) or content libraries
(articles/courses). ParentHug is different: it's **in-the-moment** and **shared**.
When your 4-year-old is melting down, you don't want an article - you want to know
*exactly what to say next*. And you want your co-parent to know it too.

**One-liner:** *Know what to say when parenting gets hard - together.*

**Brand personality:** warm, calm, emotionally supportive, modern, colorful,
premium. Parent-focused, never childish. It should feel like a wellness app for
parents, not a kids' game.

---

## 2. Ideal Customer Profile (ICP)

**Primary:** Millennial/Gen-Z families with children aged ~1-8.
- Trusted caregivers involved; want to co-parent consistently.
- Value gentle, evidence-informed parenting but struggle to apply it *in the heat
  of the moment*.
- Busy; low patience for reading; want answers in seconds.
- Comfortable paying for tools that reduce stress and guilt.

**Secondary:** blended families and caregivers (grandparents, nannies) who need
shared context.

**Jobs to be done**
1. “Tell me what to say right now so I don't make it worse.”
2. “Help me repair after I lost my cool.”
3. “Keep my partner and me aligned without nagging texts.”
4. “Help me remember and treasure the good moments.”

---

## 3. Main features

| Feature | What it does | Why it matters |
| --- | --- | --- |
| **Hug Button** ⭐ | Instant 5-part script: regulate → say this → do next → avoid → repair later | The core, sellable moment of value |
| **Repair Mode** | “I lost my cool” recovery scripts + parent reassurance | Removes guilt, teaches repair |
| **Family Board** | Structured coordination board (heads-ups, rules, wins, wants, triggers, saved scripts) | Alignment without a chat thread |
| **Today's ParentHug** | Daily briefing: context, one tiny move, a “say this” script, a memory | The daily habit loop |
| **Before You Walk In** | Emotional context + an opening line for the arriving parent | Smooths the hardest transition of the day |
| **HugBook** | Private family photo album with milestones & “this day last year” | Emotional retention + delight |

**Daily habit design (important):** the reason to open the app every day is *not*
a streak. It's to (1) see what happened, (2) understand your child's context, (3)
get one useful move, (4) coordinate with your co-parent, (5) enjoy a memory.
Progress is gentle and shame-free - no aggressive streak mechanics.

**AI behavior guardrails:** warm, practical, concise, non-judgmental,
evidence-informed. Always gives exact words. Never shames parent or child. Avoids
diagnosis. Prioritizes safety and professional support when violence, self-harm,
or abuse is mentioned.

---

## 4. Pricing model

One subscription covers **a family**.

| Plan | Price | Includes |
| --- | --- | --- |
| **Free** | $0 | 3 Hug responses/month · 1 Repair trial · 1 child profile · limited Family Board · limited Today · album preview |
| **ParentHug Plus** | $9.99/mo · $59.99/yr | Unlimited Hug Button · Repair Mode · full Family Board · daily Today's ParentHug · 2 caregivers · 2 child profiles · Memories |
| **ParentHug Family** | $14.99/mo · $89.99/yr | Everything in Plus · up to 4 child profiles · extra caregivers · advanced memories · weekly recap |

**Products:** `parenthug_plus_monthly`, `parenthug_plus_yearly`,
`parenthug_family_monthly`, `parenthug_family_yearly`.
**Entitlements:** `plus`, `family` (free = no active entitlement).

**Paywall moments:** end of onboarding (soft), when a free user exceeds monthly
Hug limits, when opening a Plus-only feature (Repair Mode), and when adding a
child beyond the plan limit.

---

## 5. MVP scope (this build)

**In**
- Email/password auth (+ forgot password; Apple/Google placeholders ready).
- Onboarding: create/join family, first child, goals & struggles, invite partner,
  paywall moment.
- Child profiles (name, birthday, temperament, struggles, goals, notes).
- Families, roles (admin/parent/caregiver), invite codes.
- Hug Button with tone + context chips, refine (gentler/firmer/adapt age), save,
  share, add-to-board.
- Repair Mode.
- Family Board: full CRUD, pin, archive, filter by child & category.
- Today's ParentHug + Before You Walk In.
- HugBook: upload, private storage, timeline, milestones, “this day last year”,
  birthday-collage flow (rendering stubbed with clean architecture).
- RevenueCat paywall + entitlement gating + webhook → DB.
- Server-side AI with graceful no-key fallbacks; safety guardrails.
- Landing page + legal templates; full docs.

**Deliberately stubbed / deferred**
- Real birthday-collage / recap-video rendering (function returns a clean,
  client-ready shape).
- AI photo tagging & milestone detection.
- Push notifications.
- Apple/Google sign-in (wired as placeholders).

---

## 6. Future roadmap

**Near term**
- Push notifications (partner posted to the board; daily briefing ready).
- Apple & Google sign-in.
- Real birthday collages and yearly recap videos.
- Weekly family recap (Family plan).

**Mid term**
- AI photo tagging & automatic milestone detection.
- Age-based developmental tips and “what's normal right now”.
- Voice input for the Hug Button (hands-full moments).
- Web companion app.

**Long term**
- Expert-reviewed content packs and specialist modes (neurodivergence, sleep,
  feeding).
- Shared “family playbook” that learns your household's rules and voice.
- Localization and multi-language guidance.

---

## 7. Success metrics

- **Activation:** % of new users who complete onboarding and run one Hug Button.
- **Aha rate:** % who save or share a script in week one.
- **Habit:** weekly active families; days/week the Today tab is opened.
- **Alignment:** % of families with active caregivers using the shared board.
- **Monetization:** free → paid conversion; annual mix; retained MRR.
- **Trust:** low uninstall rate; qualitative “this helped” feedback.
