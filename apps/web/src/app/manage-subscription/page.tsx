import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Manage Subscription" };

export default function ManageSubscriptionPage() {
  return (
    <LegalLayout
      kicker="Billing"
      title="Manage your subscription"
      updated="July 9, 2026"
    >
      <p>
        ParentHug subscriptions are billed and managed through the app store you
        purchased from. You can upgrade, downgrade, or cancel anytime — changes
        take effect at the end of your current billing period.
      </p>

      <div className="card-block">
        <h2 style={{ marginTop: 0 }}> On iPhone / iPad (Apple ID)</h2>
        <ol>
          <li>Open <strong>Settings</strong> and tap your name.</li>
          <li>Tap <strong>Subscriptions</strong>.</li>
          <li>Select <strong>ParentHug</strong>.</li>
          <li>Change your plan or tap <strong>Cancel Subscription</strong>.</li>
        </ol>
        <p style={{ marginBottom: 0 }}>
          Or manage online at{" "}
          <a href="https://apps.apple.com/account/subscriptions">
            apps.apple.com/account/subscriptions
          </a>
          .
        </p>
      </div>

      <div className="card-block">
        <h2 style={{ marginTop: 0 }}>▶️ On Android (Google Play)</h2>
        <ol>
          <li>Open the <strong>Google Play Store</strong> app.</li>
          <li>Tap your profile icon → <strong>Payments &amp; subscriptions</strong>.</li>
          <li>Tap <strong>Subscriptions</strong> → <strong>ParentHug</strong>.</li>
          <li>Update your plan or tap <strong>Cancel subscription</strong>.</li>
        </ol>
        <p style={{ marginBottom: 0 }}>
          Or manage online at{" "}
          <a href="https://play.google.com/store/account/subscriptions">
            play.google.com/store/account/subscriptions
          </a>
          .
        </p>
      </div>

      <h2>Refunds</h2>
      <p>
        Refunds are handled by Apple or Google under their respective policies.
        We&apos;re happy to point you in the right direction — just reach out.
      </p>

      <h2>Need a hand?</h2>
      <p>
        Email <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a> and
        we&apos;ll help you sort it out.
      </p>
    </LegalLayout>
  );
}
