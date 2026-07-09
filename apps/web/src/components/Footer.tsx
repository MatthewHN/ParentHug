import Link from "next/link";

export function Footer() {
  return (
    <footer className="footer">
      <div className="container footer-inner">
        <nav className="footer-links">
          <Link href="/terms">Terms</Link>
          <Link href="/privacy">Privacy</Link>
          <Link href="/contact">Contact</Link>
          <Link href="/manage-subscription">Manage Subscription</Link>
        </nav>
        <div className="footer-copy">© 2026 ParentHug. All rights reserved.</div>
      </div>
    </footer>
  );
}
