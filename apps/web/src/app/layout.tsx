import "./globals.css";
import type { Metadata } from "next";
import { Nav } from "@/components/Nav";
import { Footer } from "@/components/Footer";
import { site } from "@/lib/site";

export const metadata: Metadata = {
  metadataBase: new URL(site.url),
  title: {
    default: "ParentHug — Know what to say when parenting gets hard",
    template: "%s · ParentHug",
  },
  description:
    "ParentHug helps both parents stay calm, aligned, and connected — with instant scripts, a shared family board, and memories that matter.",
  applicationName: "ParentHug",
  keywords: [
    "parenting app",
    "gentle parenting",
    "co-parenting",
    "parenting scripts",
    "family app",
  ],
  openGraph: {
    title: "ParentHug — Know what to say when parenting gets hard",
    description: site.tagline,
    url: site.url,
    siteName: "ParentHug",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "ParentHug",
    description: site.tagline,
  },
  icons: { icon: "/favicon.svg" },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Nav />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}
