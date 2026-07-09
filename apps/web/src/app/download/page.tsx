import Image from "next/image";
import { StoreButtons } from "@/components/StoreButtons";

export const metadata = {
  title: "Download ParentHug",
  description:
    "Download ParentHug for practical parenting scripts, family notes, and calm support in hard moments.",
};

const screenshots = [
  {
    title: "Hug Button",
    text: "Get calm words for the exact situation in front of you.",
  },
  {
    title: "Repair Mode",
    text: "Reconnect after a hard moment with a short, caring script.",
  },
  {
    title: "Family Board",
    text: "Keep notes, scripts, and routines in one private family space.",
  },
];

export default function DownloadPage() {
  return (
    <section className="download-hero">
      <div className="container download-grid">
        <div className="download-copy">
          <Image
            className="download-icon"
            src="/ParentHug-appcion.png"
            alt="ParentHug app icon"
            width={86}
            height={86}
            priority
          />
          <h1>Download ParentHug</h1>
          <p>
            Practical scripts, family notes, and private memories for the hard
            moments of parenting.
          </p>
          <StoreButtons />
        </div>
        <div className="download-screens" aria-label="ParentHug app screenshots">
          {screenshots.map((shot) => (
            <article className="download-shot" key={shot.title}>
              <div className="shot-status" />
              <h2>{shot.title}</h2>
              <p>{shot.text}</p>
              <div className="shot-lines">
                <span />
                <span />
                <span />
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
