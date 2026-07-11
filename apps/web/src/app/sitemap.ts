import type { MetadataRoute } from "next";
import { blogPosts } from "@/lib/blog";
import { site } from "@/lib/site";

const staticRoutes = ["", "/download", "/blog", "/terms", "/privacy"];

export default function sitemap(): MetadataRoute.Sitemap {
  const lastModified = new Date("2026-07-11");

  return [
    ...staticRoutes.map((route) => ({
      url: `${site.url}${route}`,
      lastModified,
      changeFrequency: route === "/blog" ? ("weekly" as const) : ("monthly" as const),
      priority: route === "" ? 1 : 0.8,
    })),
    ...blogPosts.map((post) => ({
      url: `${site.url}/blog/${post.slug}`,
      lastModified,
      changeFrequency: "monthly" as const,
      priority: 0.7,
    })),
  ];
}
