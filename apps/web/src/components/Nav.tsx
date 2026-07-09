import Image from "next/image";
import Link from "next/link";

export function Nav() {
  return (
    <header className="nav">
      <div className="container nav-inner">
        <Link href="/" className="brand" aria-label="ParentHug home">
          <span className="brand-mark">
            <Image
              src="/ParentHug-appcion.png"
              alt=""
              width={40}
              height={40}
              priority
            />
          </span>
          <span>ParentHug</span>
        </Link>
        <nav className="nav-links">
          <a href="/#features">Features</a>
          <Link href="/blog">Blog</Link>
        </nav>
        <div className="nav-cta">
          <Link className="btn btn-primary" href="/download">
            Get the app
          </Link>
        </div>
      </div>
    </header>
  );
}
