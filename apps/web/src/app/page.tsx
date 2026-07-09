import { Hero } from "@/components/Hero";
import { Features } from "@/components/Features";
import { StoreButtons } from "@/components/StoreButtons";

const steps = [
  {
    n: "1",
    title: "Tell ParentHug what's happening",
    body: "“My 4-year-old is screaming because I turned off the iPad.” Add a tone and a bit of context.",
  },
  {
    n: "2",
    title: "Get the next right words",
    body: "Calm, practical guidance in seconds: first regulate, say this, do next, avoid this, repair later.",
  },
  {
    n: "3",
    title: "Stay aligned with your co-parent",
    body: "Save scripts, share to your Family Board, and open the app each day for context that keeps you both in sync.",
  },
];

export default function HomePage() {
  return (
    <>
      <Hero />
      <Features />

      <section className="section" id="how">
        <div className="container">
          <div className="section-head">
            <h2>How ParentHug works</h2>
            <p>From overwhelmed to “I&apos;ve got this” in about ten seconds.</p>
          </div>
          <div className="feature-grid">
            {steps.map((s) => (
              <article className="feature-card" key={s.n}>
                <div
                  className="feature-emoji"
                  style={{
                    background: "linear-gradient(135deg,#2F9CF4,#FF6B7A)",
                    color: "#fff",
                    fontWeight: 900,
                  }}
                >
                  {s.n}
                </div>
                <h3>{s.title}</h3>
                <p>{s.body}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container">
          <div className="cta-band">
            <h2>Bring a little more calm home</h2>
            <p>
              Join parents using ParentHug to respond with warmth in the moments
              that matter most.
            </p>
            <StoreButtons />
          </div>
        </div>
      </section>
    </>
  );
}
