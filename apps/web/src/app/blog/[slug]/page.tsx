import type { ReactNode } from "react";
import Link from "next/link";
import { notFound } from "next/navigation";
import { getBlogPost, blogPosts, type BlogPost } from "@/lib/blog";
import { site } from "@/lib/site";

export function generateStaticParams() {
  return blogPosts.map((post) => ({ slug: post.slug }));
}

export function generateMetadata({ params }: { params: { slug: string } }) {
  const post = getBlogPost(params.slug);

  if (!post) {
    return {};
  }

  return {
    title: post.title,
    description: post.description,
    keywords: post.keywords,
    alternates: {
      canonical: `/blog/${post.slug}`,
    },
    openGraph: {
      title: post.title,
      description: post.description,
      type: "article",
      url: `${site.url}/blog/${post.slug}`,
    },
  };
}

const LINK_RE = /\[([^\]]+)\]\(([^)]+)\)/g;

/** Render text with inline [label](url) links — internal (/) as Next <Link>. */
function renderRich(text: string): ReactNode[] {
  const nodes: ReactNode[] = [];
  let last = 0;
  let key = 0;
  for (const match of text.matchAll(LINK_RE)) {
    const index = match.index ?? 0;
    if (index > last) nodes.push(text.slice(last, index));
    const [full, label, url] = match;
    nodes.push(
      url.startsWith("/") ? (
        <Link key={key++} href={url}>
          {label}
        </Link>
      ) : (
        <a key={key++} href={url} target="_blank" rel="noopener noreferrer">
          {label}
        </a>
      ),
    );
    last = index + full.length;
  }
  if (last < text.length) nodes.push(text.slice(last));
  return nodes;
}

/** Plain text for structured data — strips the markdown link syntax. */
function stripMarkdown(text: string): string {
  return text.replace(LINK_RE, "$1");
}

export default function BlogPostPage({ params }: { params: { slug: string } }) {
  const post = getBlogPost(params.slug);

  if (!post) {
    notFound();
  }

  const related = (post.related ?? [])
    .map((slug) => getBlogPost(slug))
    .filter((p): p is BlogPost => Boolean(p));

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: post.title,
    description: post.description,
    datePublished: "2026-07-09",
    dateModified: "2026-07-09",
    author: {
      "@type": "Organization",
      name: "ParentHug",
    },
    publisher: {
      "@type": "Organization",
      name: "ParentHug",
      logo: {
        "@type": "ImageObject",
        url: `${site.url}/ParentHug-appcion.png`,
      },
    },
    mainEntity: post.faqs.map((faq) => ({
      "@type": "Question",
      name: faq.question,
      acceptedAnswer: {
        "@type": "Answer",
        text: stripMarkdown(faq.answer),
      },
    })),
  };

  return (
    <div className="container">
      <article className="prose blog-post">
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
        <div className="kicker">Parenting scripts</div>
        <h1>{post.title}</h1>
        <p className="updated">
          {post.date} | {post.readTime}
        </p>
        <p>{post.description}</p>

        {post.sections.map((section) => (
          <section key={section.heading}>
            <h2>{section.heading}</h2>
            {section.body.map((paragraph) => (
              <p key={paragraph}>{renderRich(paragraph)}</p>
            ))}
          </section>
        ))}

        <section>
          <h2>Quick answers</h2>
          {post.faqs.map((faq) => (
            <div className="faq-item" key={faq.question}>
              <h3>{faq.question}</h3>
              <p>{renderRich(faq.answer)}</p>
            </div>
          ))}
        </section>

        <aside className="blog-cta">
          <h3>Get the words before you need them</h3>
          <p>
            ParentHug turns the moment you are dreading into a short, calm
            script — for tantrums, back talk, screen-time battles, and bedtime.
          </p>
          <Link className="btn btn-primary" href="/download">
            Get ParentHug
          </Link>
        </aside>

        {related.length > 0 && (
          <section className="blog-related">
            <h2>Keep reading</h2>
            <ul>
              {related.map((r) => (
                <li key={r.slug}>
                  <Link href={`/blog/${r.slug}`}>{r.title}</Link>
                </li>
              ))}
            </ul>
          </section>
        )}
      </article>
    </div>
  );
}
