import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Contact" };

export default function ContactPage() {
  return (
    <LegalLayout kicker="We're here" title="Contact us" updated="July 9, 2026">
      <p>
        We&apos;d love to hear from you — whether it&apos;s a question, a bug, or
        a story about a hard moment ParentHug helped with.
      </p>

      <div className="card-block">
        <h2 style={{ marginTop: 0 }}>📧 Email support</h2>
        <p style={{ marginBottom: 0 }}>
          <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>
          <br />
          We aim to reply within 2 business days.
        </p>
      </div>

      <div className="card-block">
        <h2 style={{ marginTop: 0 }}>💳 Billing &amp; subscriptions</h2>
        <p style={{ marginBottom: 0 }}>
          Manage or cancel your plan from your app store account. See{" "}
          <a href="/manage-subscription">Manage Subscription</a> for steps.
        </p>
      </div>

      <div className="card-block">
        <h2 style={{ marginTop: 0 }}>🔒 Privacy requests</h2>
        <p style={{ marginBottom: 0 }}>
          To access or delete your data, email us from your account address and
          we&apos;ll help. See our <a href="/privacy">Privacy Policy</a>.
        </p>
      </div>
    </LegalLayout>
  );
}
