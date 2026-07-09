import { ReactNode } from "react";

export function LegalLayout({
  kicker,
  title,
  updated,
  children,
}: {
  kicker: string;
  title: string;
  updated: string;
  children: ReactNode;
}) {
  return (
    <div className="container">
      <article className="prose">
        <div className="kicker">{kicker}</div>
        <h1>{title}</h1>
        <p className="updated">Last updated: {updated}</p>
        {children}
      </article>
    </div>
  );
}
