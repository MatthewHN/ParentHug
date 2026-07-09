import { Hero } from "@/components/Hero";
import { Features } from "@/components/Features";
import { StoreButtons } from "@/components/StoreButtons";

export default function HomePage() {
  return (
    <>
      <Hero />
      <Features />

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
