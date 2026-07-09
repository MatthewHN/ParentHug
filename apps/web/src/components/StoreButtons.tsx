import Image from "next/image";
import { site } from "@/lib/site";

export function StoreButtons() {
  return (
    <div className="store-row">
      <a
        className="store-badge official-store-badge"
        href={site.appStoreUrl}
        aria-label="Download on the App Store"
      >
        <Image
          src="/store-appstore.png"
          alt="Download on the App Store"
          width={300}
          height={101}
        />
      </a>
      <a
        className="store-badge official-store-badge"
        href={site.googlePlayUrl}
        aria-label="Get it on Google Play"
      >
        <Image
          src="/store-googleplay.png"
          alt="Get it on Google Play"
          width={300}
          height={92}
        />
      </a>
    </div>
  );
}
