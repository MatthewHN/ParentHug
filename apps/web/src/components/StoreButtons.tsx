import { site } from "@/lib/site";

function AppleIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M16.365 1.43c0 1.14-.42 2.2-1.12 2.98-.79.9-2.08 1.6-3.13 1.52-.13-1.09.42-2.24 1.09-2.97.75-.83 2.06-1.46 3.16-1.53zM20.5 17.14c-.55 1.27-.81 1.84-1.52 2.96-.99 1.56-2.39 3.5-4.12 3.51-1.54.02-1.94-1-4.03-.99-2.09.01-2.53 1.01-4.07.99-1.73-.02-3.05-1.77-4.04-3.33C-.02 16.96-.34 12.4 1.36 9.98c1.02-1.46 2.63-2.31 4.14-2.31 1.54 0 2.5 1 3.77 1 1.23 0 1.98-1 3.76-1 1.34 0 2.76.73 3.77 2-3.31 1.81-2.77 6.54.7 7.47z" />
    </svg>
  );
}

function PlayIcon() {
  return (
    <svg width="20" height="22" viewBox="0 0 24 24" aria-hidden>
      <path d="M3.6 2.2c-.3.3-.5.7-.5 1.2v17.2c0 .5.2.9.5 1.2l.1.1L14 12.1v-.2L3.7 2.1l-.1.1z" fill="#00E1FF" />
      <path d="M17.5 15.6 14 12.1v-.2l3.5-3.5.1.1 4.2 2.4c1.2.7 1.2 1.8 0 2.5l-4.3 2.2z" fill="#FFC107" />
      <path d="M3.6 2.2 14 12l3.6-3.6L4.6 1.6c-.4-.2-.8-.2-1 .6z" fill="#00F076" />
      <path d="M3.6 21.8 14 12l3.6 3.6L4.6 22.4c-.4.2-.8.2-1-.6z" fill="#FF3A44" />
    </svg>
  );
}

export function StoreButtons() {
  return (
    <div className="store-row">
      <a
        className="store-badge"
        href={site.appStoreUrl}
        aria-label="Download on the App Store"
      >
        <AppleIcon />
        <span>
          <small>Download on the</small>
          <strong>App Store</strong>
        </span>
      </a>
      <a
        className="store-badge"
        href={site.googlePlayUrl}
        aria-label="Get it on Google Play"
      >
        <PlayIcon />
        <span>
          <small>Get it on</small>
          <strong>Google Play</strong>
        </span>
      </a>
    </div>
  );
}
