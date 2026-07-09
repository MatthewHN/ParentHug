# ParentHug - Landing page (`apps/web`)

Next.js (App Router, TypeScript) marketing site for **parenthug.app**.

## Local development

```bash
cd apps/web
cp .env.example .env.local     # fill in store links when available
npm install
npm run dev                    # http://localhost:3000
```

## Pages

| Route | Purpose |
| --- | --- |
| `/` | Hero, features, download CTA |
| `/download` | Simple app download page |
| `/blog` | Parenting articles |
| `/privacy` | Privacy Policy |
| `/terms` | Terms of Service |

## Environment variables

Set these in Vercel (Project → Settings → Environment Variables) or `.env.local`:

| Variable | Description |
| --- | --- |
| `NEXT_PUBLIC_APP_STORE_URL` | App Store link (use `#` until live) |
| `NEXT_PUBLIC_GOOGLE_PLAY_URL` | Google Play link (use `#` until live) |
| `NEXT_PUBLIC_SITE_URL` | Canonical URL, e.g. `https://parenthug.app` |
| `NEXT_PUBLIC_SUPPORT_EMAIL` | Support email shown in legal pages |

## Deploy to Vercel

1. Import the repository in Vercel.
2. **Set the project Root Directory to `apps/web`.** (This is the key step for a
   monorepo - Vercel then builds only the landing page.)
3. Framework preset: **Next.js** (auto-detected). Build command `next build`,
   output handled automatically.
4. Add the environment variables above.
5. Add the domain `parenthug.app` and configure DNS as Vercel instructs.

## Notes

- Fully static/SSR-ready, no external runtime services required.
- Styling is plain CSS (`src/app/globals.css`) with brand variables - no CSS
  framework dependency.
- Optional demo video: drop `public/demo.mp4` and wire it into
  `src/components/PhoneMockup.tsx` (see `public/README.md`).
