import { PhoneMockup } from "./PhoneMockup";
import { StoreButtons } from "./StoreButtons";

export function Hero() {
  return (
    <section className="hero">
      <div className="container hero-grid">
        <div>
          <span className="eyebrow">🫶 For two-parent families</span>
          <h1 className="hero-title">
            Know what to say when <span className="hl">parenting gets hard</span>
          </h1>
          <p className="hero-sub">
            ParentHug helps both parents stay calm, aligned, and connected — with
            instant scripts, shared family notes, and memories that matter.
          </p>
          <StoreButtons />
          <p className="trust">
            Warm, practical, judgment-free · Private by default · One plan covers
            both parents
          </p>
        </div>
        <PhoneMockup />
      </div>
    </section>
  );
}
