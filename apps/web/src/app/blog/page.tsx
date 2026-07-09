import Link from "next/link";
import { blogPosts } from "@/lib/blog";

export const metadata = {
  title: "Parenting Blog",
  description:
    "Practical parenting scripts and calm guidance for tantrums, repair, and hard family moments.",
};

export default function BlogPage() {
  return (
    <div className="container">
      <section className="blog-index">
        <div className="section-head">
          <h1>Parenting Blog</h1>
          <p>
            Calm, practical guidance for the moments when parents need words
            fast.
          </p>
        </div>
        <div className="blog-list">
          {blogPosts.map((post) => (
            <article className="blog-card" key={post.slug}>
              <div className="blog-meta">
                {post.date} · {post.readTime}
              </div>
              <h2>
                <Link href={`/blog/${post.slug}`}>{post.title}</Link>
              </h2>
              <p>{post.description}</p>
              <Link className="blog-read" href={`/blog/${post.slug}`}>
                Read article
              </Link>
            </article>
          ))}
        </div>
      </section>
    </div>
  );
}
