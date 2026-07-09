import { PhoneMockup } from "./PhoneMockup";
import { StoreButtons } from "./StoreButtons";

export function Hero() {
  return (
    <section className="hero">
      <div className="container hero-grid">
        <div>
          <h1 className="hero-title">
            Know what to say when <span className="hl">parenting gets hard</span>
          </h1>
          <p className="hero-sub">
            ParentHug helps parents and caregivers stay calm, connected, and
            steady with instant scripts, shared family notes, and memories that
            matter.
          </p>
          <StoreButtons />
          <p className="trust">
            Warm, practical, judgment-free · Private by default · Built for every
            kind of family
          </p>
        </div>
        <PhoneMockup />
      </div>
    </section>
  );
}
