import Link from "next/link";
import { site } from "@/lib/site";

export function Nav() {
  return (
    <header className="nav">
      <div className="container nav-inner">
        <Link href="/" className="brand" aria-label="ParentHug home">
          <span className="brand-mark">🤗</span>
          <span>ParentHug</span>
        </Link>
        <nav className="nav-links">
          <a href="/#features">Features</a>
          <a href="/#how">How it works</a>
          <Link href="/contact">Contact</Link>
        </nav>
        <div className="nav-cta">
          <a className="btn btn-primary" href={site.appStoreUrl}>
            Get the app
          </a>
        </div>
      </div>
    </header>
  );
}
