# Public assets

Static files served at the site root.

- `favicon.svg` — browser tab icon (ParentHug hug mark).
- `demo.mp4` — **(optional, add your own)** a short screen-recording of the app.
  When present, you can wire it into `src/components/PhoneMockup.tsx` by
  replacing the `.phone-screen` contents with:

  ```tsx
  <video src="/demo.mp4" autoPlay muted loop playsInline
         style={{ width: "100%", height: "100%", objectFit: "cover" }} />
  ```

  Until you add it, the page shows a polished CSS mockup of the Today screen, so
  nothing looks broken.
