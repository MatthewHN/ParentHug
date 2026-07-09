import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Terms of Service" };

export default function TermsPage() {
  return (
    <LegalLayout kicker="Legal" title="Terms of Service" updated="July 9, 2026">
      <p>
        These Terms of Service govern your access to and use of ParentHug,
        including our mobile app, website, and related services. ParentHug is
        operated by {site.company.name}.
      </p>

      <h2>Company information</h2>
      <p>
        {site.company.name}
        <br />
        {site.company.address.map((line) => (
          <span key={line}>
            {line}
            <br />
          </span>
        ))}
        Email: <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>
      </p>

      <h2>What ParentHug provides</h2>
      <p>
        ParentHug offers educational parenting support, practical scripts, family
        coordination tools, and private memory features. ParentHug does not
        provide medical, psychological, legal, emergency, or crisis services. If
        you or a child may be in danger, contact local emergency services or a
        qualified professional immediately.
      </p>

      <h2>Eligibility and accounts</h2>
      <p>
        You must be at least 18 years old to create an account. You are
        responsible for keeping your login details secure and for all activity
        under your account. You agree to provide accurate information and update
        it when needed.
      </p>

      <h2>Family spaces and invitations</h2>
      <p>
        ParentHug lets you create a family space and invite caregivers. Only
        invite people who are allowed to access the family information you add.
        You are responsible for the child and family content you enter, upload,
        save, or share through the service.
      </p>

      <h2>Subscriptions and billing</h2>
      <p>
        Paid plans are billed through the Apple App Store or Google Play. Prices,
        renewal terms, free trials, cancellations, and refunds are handled by the
        app store used for purchase. Subscriptions renew automatically unless you
        cancel them through your Apple or Google account settings before renewal.
      </p>

      <h2>Acceptable use</h2>
      <p>
        You agree not to misuse ParentHug, interfere with the service, attempt to
        access another family&apos;s data, upload unlawful or harmful content, use
        the service to harass or abuse others, reverse engineer the app, or use
        automated systems to overload our infrastructure.
      </p>

      <h2>Your content</h2>
      <p>
        You keep ownership of the content you add to ParentHug. You grant
        {` ${site.company.name} `}a limited license to host, store, process,
        display, and transmit that content only as needed to operate, secure, and
        improve ParentHug for you and your family space.
      </p>

      <h2>AI generated guidance</h2>
      <p>
        Some ParentHug responses may be generated with artificial intelligence.
        AI output can be incomplete or inaccurate. You are responsible for
        deciding whether guidance is appropriate for your family, and you should
        seek professional help when a situation requires it.
      </p>

      <h2>Privacy</h2>
      <p>
        Our Privacy Policy explains how we collect, use, store, and protect
        personal data. By using ParentHug, you also agree to the practices
        described in the Privacy Policy.
      </p>

      <h2>Availability and changes</h2>
      <p>
        We may change, suspend, or discontinue parts of ParentHug at any time.
        We may also update these Terms. When changes are material, we will take
        reasonable steps to notify users through the app, website, or email.
      </p>

      <h2>Termination</h2>
      <p>
        You may stop using ParentHug at any time. We may suspend or terminate
        access if you breach these Terms, create risk for other users, or use the
        service in a way that may harm ParentHug or others.
      </p>

      <h2>Disclaimers and liability</h2>
      <p>
        ParentHug is provided on an &quot;as is&quot; and &quot;as available&quot;
        basis. To the maximum extent permitted by law, {site.company.name} is not
        liable for indirect, incidental, special, consequential, or punitive
        damages, or for loss of data, profits, goodwill, or business
        opportunities.
      </p>

      <h2>Governing law</h2>
      <p>
        These Terms are governed by the laws of Estonia, without regard to
        conflict of law rules. Any disputes will be handled by the competent
        courts of Estonia, unless mandatory consumer protection law gives you
        rights in another jurisdiction.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about these Terms can be sent to{" "}
        <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
      </p>
    </LegalLayout>
  );
}
