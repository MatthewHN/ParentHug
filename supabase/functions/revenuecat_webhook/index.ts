// revenuecat_webhook — receives RevenueCat subscriber events and updates the
// subscriptions table. Configure the webhook URL + Authorization value in the
// RevenueCat dashboard (Project settings → Integrations → Webhooks).
//
// Auth: RevenueCat sends the value you set as the "Authorization" header. We
// compare it (with/without a "Bearer " prefix) to REVENUECAT_WEBHOOK_SECRET.
// If the secret is not configured, verification is skipped (dev only).
import { handleOptions, jsonResponse } from "../_shared/cors.ts";
import { adminClient } from "../_shared/supabase.ts";

// RevenueCat event types that mean the entitlement is currently active.
const ACTIVE_TYPES = new Set([
  "INITIAL_PURCHASE",
  "RENEWAL",
  "PRODUCT_CHANGE",
  "UNCANCELLATION",
  "NON_RENEWING_PURCHASE",
  "SUBSCRIPTION_EXTENDED",
  "TEMPORARY_ENTITLEMENT_GRANT",
]);
// CANCELLATION keeps access until expiration; EXPIRATION/PAUSE end it.
const INACTIVE_TYPES = new Set(["EXPIRATION", "SUBSCRIPTION_PAUSED", "BILLING_ISSUE"]);

function mapPlan(entitlements: string[], productId: string): "free" | "plus" | "family" {
  const hay = [...entitlements, productId].join(" ").toLowerCase();
  if (hay.includes("family")) return "family";
  if (hay.includes("plus")) return "plus";
  return "free";
}

function verifyAuth(req: Request): boolean {
  const secret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET") ?? "";
  if (!secret) return true; // not configured → allow (dev only)
  const header = req.headers.get("Authorization") ?? "";
  return header === secret || header === `Bearer ${secret}`;
}

Deno.serve(async (req) => {
  const pre = handleOptions(req);
  if (pre) return pre;
  if (req.method !== "POST") return jsonResponse({ error: "method_not_allowed" }, 405);
  if (!verifyAuth(req)) return jsonResponse({ error: "unauthorized" }, 401);

  try {
    const payload = await req.json().catch(() => ({}));
    const event = payload.event ?? payload; // RevenueCat wraps in { event: ... }

    const appUserId: string | undefined = event.app_user_id;
    const type: string = event.type ?? "";
    const entitlements: string[] = event.entitlement_ids ??
      (event.entitlement_id ? [event.entitlement_id] : []);
    const productId: string = event.product_id ?? "";
    const expiresMs: number | null = event.expiration_at_ms ?? null;

    if (!appUserId) {
      // Nothing to map (anonymous). Acknowledge so RevenueCat stops retrying.
      return jsonResponse({ ok: true, note: "no app_user_id" });
    }

    const plan = mapPlan(entitlements, productId);
    const isActive = INACTIVE_TYPES.has(type)
      ? false
      : ACTIVE_TYPES.has(type)
      ? true
      : type === "CANCELLATION"; // cancelled but still entitled until expiry
    const status = isActive ? "active" : (type === "EXPIRATION" ? "expired" : "inactive");
    const expiresAt = expiresMs ? new Date(expiresMs).toISOString() : null;

    const db = adminClient();

    // app_user_id is the Supabase user id (client calls Purchases.logIn(userId)).
    // Apply the entitlement to every family the purchaser belongs to.
    const { data: memberships } = await db
      .from("family_members")
      .select("family_id")
      .eq("user_id", appUserId);

    if (!memberships || memberships.length === 0) {
      return jsonResponse({ ok: true, note: "user has no family yet" });
    }

    for (const m of memberships) {
      await db.from("subscriptions").upsert(
        {
          family_id: m.family_id,
          user_id: appUserId,
          plan: isActive ? plan : "free",
          status,
          is_active: isActive,
          rc_app_user_id: appUserId,
          rc_entitlement: entitlements.join(",") || null,
          product_id: productId || null,
          expires_at: expiresAt,
          updated_at: new Date().toISOString(),
        },
        { onConflict: "family_id" },
      );
    }

    return jsonResponse({ ok: true, plan, is_active: isActive, families: memberships.length });
  } catch (err) {
    console.error("revenuecat_webhook error:", err);
    return jsonResponse({ error: "internal_error" }, 500);
  }
});
