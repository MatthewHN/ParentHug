import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Terms of Service" };

export default function TermsPage() {
  return (
    <LegalLayout kicker="Legal" title="Terms of Service" updated="July 9, 2026">
      <div className="notice">
        ⚠️ This is a starter template, not legal advice. Please have a qualified
        attorney review and adapt it for your business before launch.
      </div>

      <p>
        These Terms govern your use of ParentHug. By creating an account or using
        the app, you agree to them.
      </p>

      <h2>What ParentHug is — and isn&apos;t</h2>
      <p>
        ParentHug provides supportive, educational parenting guidance. It is{" "}
        <strong>not</strong> medical, psychological, legal, or emergency advice
        and is not a substitute for professional care. If you or a child may be in
        danger, contact your local emergency services immediately.
      </p>

      <h2>Accounts</h2>
      <p>
        You are responsible for the activity on your account and for keeping your
        credentials secure. You must be an adult (18+) to create an account. A
        family may include additional parents or caregivers you invite.
      </p>

      <h2>Subscriptions &amp; billing</h2>
      <ul>
        <li>
          Paid plans (ParentHug Plus and Family) are billed through the Apple App
          Store or Google Play, according to the pricing shown at purchase.
        </li>
        <li>
          Subscriptions renew automatically until cancelled. Manage or cancel
          anytime in your app store account settings.
        </li>
        <li>
          One paid subscription covers the parents within a single family.
        </li>
        <li>
          Refunds are handled by the app store under their respective policies.
        </li>
      </ul>

      <h2>Acceptable use</h2>
      <p>
        Don&apos;t misuse the service: no unlawful, harmful, or abusive activity,
        no attempts to breach security, and no uploading content you don&apos;t
        have the right to share.
      </p>

      <h2>Your content</h2>
      <p>
        You retain ownership of the content you create. You grant us a limited
        license to store and process it solely to operate the service for you and
        your family.
      </p>

      <h2>Disclaimers &amp; limitation of liability</h2>
      <p>
        The service is provided “as is” without warranties of any kind. To the
        maximum extent permitted by law, ParentHug is not liable for indirect or
        consequential damages arising from your use of the app.
      </p>

      <h2>Changes &amp; termination</h2>
      <p>
        We may update these Terms or the service over time. We may suspend or
        terminate accounts that violate these Terms. You can stop using ParentHug
        at any time.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about these Terms? Email{" "}
        <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
      </p>
    </LegalLayout>
  );
}
