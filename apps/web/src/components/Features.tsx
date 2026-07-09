import { features } from "@/lib/site";

export function Features() {
  return (
    <section className="section" id="features">
      <div className="container">
        <div className="section-head">
          <h2>Everything you need in the hard moments</h2>
          <p>
            One calm home for both parents — practical words, shared context, and
            the memories worth keeping.
          </p>
        </div>
        <div className="feature-grid">
          {features.map((f) => (
            <article className="feature-card" key={f.title}>
              <div
                className="feature-emoji"
                style={{ background: `color-mix(in srgb, ${f.color} 16%, white)` }}
              >
                {f.emoji}
              </div>
              <h3>{f.title}</h3>
              <p>{f.body}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
