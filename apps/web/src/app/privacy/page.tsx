import { LegalLayout } from "@/components/LegalLayout";
import { site } from "@/lib/site";

export const metadata = { title: "Privacy Policy" };

export default function PrivacyPage() {
  return (
    <LegalLayout kicker="Legal" title="Privacy Policy" updated="July 9, 2026">
      <p>
        This Privacy Policy explains how {site.company.name} collects, uses, and
        protects personal data when you use ParentHug, including our mobile app,
        website, and related services.
      </p>

      <h2>Data controller</h2>
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

      <h2>Information we collect</h2>
      <ul>
        <li>
          <strong>Account information:</strong> name, email address,
          authentication identifiers, language, and app settings.
        </li>
        <li>
          <strong>Family and child information:</strong> names, ages, birthdays,
          routines, temperament notes, goals, struggles, and family roles you add.
        </li>
        <li>
          <strong>Content you create:</strong> parenting situations, generated
          scripts, saved notes, Family Board items, memories, and uploaded photos.
        </li>
        <li>
          <strong>Subscription information:</strong> entitlement status, plan
          identifiers, renewal status, and purchase events from Apple, Google, or
          our subscription provider. We do not receive full payment card details.
        </li>
        <li>
          <strong>Technical and usage information:</strong> device type, app
          version, diagnostics, security logs, and basic usage events needed to
          operate and protect the service.
        </li>
      </ul>

      <h2>How we use information</h2>
      <ul>
        <li>To create and manage your account.</li>
        <li>To generate parenting scripts, repair prompts, and daily briefings.</li>
        <li>To sync Family Board content, memories, and child context.</li>
        <li>To provide subscriptions, support, security, and abuse prevention.</li>
        <li>To improve ParentHug, fix bugs, and understand product performance.</li>
        <li>To comply with legal obligations and respond to lawful requests.</li>
      </ul>

      <h2>AI processing</h2>
      <p>
        When you request guidance, ParentHug may process the situation text and
        relevant family context through an AI provider. We use this processing to
        return the requested response. We do not sell your content, and we do not
        allow AI provider keys to be stored in the mobile app.
      </p>

      <h2>Children&apos;s information</h2>
      <p>
        ParentHug is for adults, not for direct use by children. Parents and
        caregivers may choose to add information about children so the service can
        provide more relevant support. Child profiles, notes, and photos are
        private by default and scoped to the family space.
      </p>

      <h2>Service providers</h2>
      <p>
        We use trusted providers to operate ParentHug, including hosting,
        authentication, database, storage, subscription management, analytics,
        customer support, and AI processing providers. They may process data only
        as needed to provide services to us and under appropriate safeguards.
      </p>

      <h2>Legal bases</h2>
      <p>
        Where GDPR applies, we process personal data based on performance of a
        contract, legitimate interests such as security and product improvement,
        consent where required, and compliance with legal obligations.
      </p>

      <h2>Data sharing</h2>
      <p>
        We do not sell personal data. We may share data with service providers,
        with family members you invite into a family space, when required by law,
        to protect rights and safety, or as part of a merger, acquisition, or
        similar business transaction.
      </p>

      <h2>International transfers</h2>
      <p>
        ParentHug may be operated using providers in different countries. When
        personal data is transferred outside the European Economic Area, we use
        appropriate safeguards such as contractual protections where required.
      </p>

      <h2>Retention</h2>
      <p>
        We keep personal data for as long as needed to provide ParentHug, comply
        with legal obligations, resolve disputes, and enforce agreements. You can
        delete many items in the app or request account deletion by contacting us.
      </p>

      <h2>Your rights</h2>
      <p>
        Depending on your location, you may have rights to access, correct,
        delete, export, restrict, or object to processing of your personal data.
        You may also withdraw consent where processing is based on consent. To
        make a request, contact{" "}
        <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
      </p>

      <h2>Security</h2>
      <p>
        We use technical and organizational safeguards designed to protect family
        data, including authenticated access, row-level access controls, encrypted
        connections, private storage, and limited server-side processing. No
        system can be guaranteed perfectly secure.
      </p>

      <h2>Updates</h2>
      <p>
        We may update this Privacy Policy from time to time. If changes are
        material, we will take reasonable steps to notify users through the app,
        website, or email.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about privacy can be sent to{" "}
        <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
      </p>
    </LegalLayout>
  );
}
