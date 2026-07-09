import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Privacy Policy" };

export default function PrivacyPage() {
  return (
    <LegalLayout kicker="Legal" title="Privacy Policy" updated="July 9, 2026">
      <div className="notice">
        ⚠️ This is a starter template, not legal advice. Please have a qualified
        attorney review and adapt it for your business before launch.
      </div>

      <p>
        ParentHug (“we”, “us”) helps parents with in-the-moment guidance, shared
        family notes, and private memories. This policy explains what we collect,
        how we use it, and the choices you have.
      </p>

      <h2>Information we collect</h2>
      <ul>
        <li>
          <strong>Account data</strong> — your name, email, and authentication
          details used to sign in.
        </li>
        <li>
          <strong>Family &amp; child profiles</strong> — information you add such
          as a child&apos;s name, birthday, temperament, goals, and struggles.
        </li>
        <li>
          <strong>Content you create</strong> — situations you enter, Family
          Board notes, saved scripts, and photos you upload to your HugBook.
        </li>
        <li>
          <strong>Subscription status</strong> — plan and entitlement data from
          our payments provider (we never receive your full card details).
        </li>
        <li>
          <strong>Basic device/usage data</strong> — needed to operate and secure
          the service.
        </li>
      </ul>

      <h2>How we use information</h2>
      <ul>
        <li>To generate guidance and briefings you request.</li>
        <li>To sync context between the parents in your family.</li>
        <li>To provide, secure, and improve the app.</li>
        <li>To manage subscriptions and prevent abuse.</li>
      </ul>

      <h2>Children&apos;s information &amp; photos</h2>
      <p>
        ParentHug is designed for parents and caregivers — not for use by
        children. Information and photos about your child are{" "}
        <strong>private by default</strong> and accessible only to members of
        your family. Photos are stored in access-controlled storage and served
        through short-lived, signed links.
      </p>

      <h2>How guidance is generated</h2>
      <p>
        In-the-moment guidance is produced by our servers, which may send the
        situation text and relevant child context to an AI provider to create a
        response. We do not sell your content, and AI provider keys are never
        stored in the app.
      </p>

      <h2>Service providers</h2>
      <p>
        We rely on trusted vendors to run ParentHug, including Supabase
        (authentication, database, and storage), RevenueCat (subscription
        management), and an AI provider for generating guidance. Each processes
        data only to provide their service.
      </p>

      <h2>Data retention &amp; your choices</h2>
      <p>
        You can edit or delete your content in the app, and you may request
        deletion of your account and associated data by contacting us. We retain
        information for as long as your account is active or as needed to comply
        with legal obligations.
      </p>

      <h2>Security</h2>
      <p>
        We use industry-standard measures including row-level access controls so
        data is scoped to your family, encrypted connections, and private storage
        buckets. No system is perfectly secure, but we work hard to protect your
        family&apos;s information.
      </p>

      <h2>Contact</h2>
      <p>
        Questions? Email us at{" "}
        <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
      </p>
    </LegalLayout>
  );
}
