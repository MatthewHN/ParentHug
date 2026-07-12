// AI provider abstraction. ALL prompts live server-side (see prompts.ts).
//
// Design goal: the app must work end-to-end WITHOUT any AI credentials. If
// AI_API_KEY is missing (or AI_PROVIDER is "placeholder"), callAiJson returns
// null and the caller falls back to a warm, hand-authored static response.
//
// Supported providers (set AI_PROVIDER):
//   * "openai"     - any OpenAI-compatible /chat/completions endpoint
//   * "anthropic"  - Anthropic Messages API
//   * "placeholder"/"none"/unset - no external call; caller uses fallback
//
// Optional overrides: AI_BASE_URL, AI_MODEL.

export interface AiMessage {
  system: string;
  user: string;
}

const TIMEOUT_MS = 25_000;

export function aiConfigured(): boolean {
  const provider = (Deno.env.get("AI_PROVIDER") ?? "placeholder").toLowerCase();
  const key = Deno.env.get("AI_API_KEY") ?? "";
  return !!key && provider !== "placeholder" && provider !== "none";
}

export async function callAiJson(
  msg: AiMessage,
): Promise<Record<string, unknown> | null> {
  if (!aiConfigured()) return null;
  const provider = (Deno.env.get("AI_PROVIDER") ?? "").toLowerCase();
  const apiKey = Deno.env.get("AI_API_KEY")!;
  try {
    const raw = provider === "anthropic"
      ? await callAnthropic(apiKey, msg)
      : await callOpenAiCompatible(apiKey, msg);
    return JSON.parse(extractJson(raw));
  } catch (err) {
    console.error("AI call failed; falling back to static response:", err);
    return null;
  }
}

async function callOpenAiCompatible(apiKey: string, msg: AiMessage): Promise<string> {
  const base = Deno.env.get("AI_BASE_URL") ?? "https://api.openai.com/v1";
  const model = Deno.env.get("AI_MODEL") ?? "gpt-5-mini";
  const res = await withTimeout((signal) =>
    fetch(`${base}/chat/completions`, {
      method: "POST",
      signal,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model,
        // GPT-5 reasoning models reject non-default sampling parameters.
        ...(model.startsWith("gpt-5") ? {} : { temperature: 0.7 }),
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: msg.system },
          { role: "user", content: msg.user },
        ],
      }),
    })
  );
  if (!res.ok) throw new Error(`AI ${res.status}: ${await res.text()}`);
  const data = await res.json();
  return data.choices?.[0]?.message?.content ?? "{}";
}

async function callAnthropic(apiKey: string, msg: AiMessage): Promise<string> {
  const model = Deno.env.get("AI_MODEL") ?? "claude-haiku-4-5-20251001";
  const res = await withTimeout((signal) =>
    fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      signal,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model,
        max_tokens: 1024,
        system: `${msg.system}\n\nRespond with ONLY a single valid JSON object and no other text.`,
        messages: [{ role: "user", content: msg.user }],
      }),
    })
  );
  if (!res.ok) throw new Error(`AI ${res.status}: ${await res.text()}`);
  const data = await res.json();
  return data.content?.[0]?.text ?? "{}";
}

function withTimeout(fn: (signal: AbortSignal) => Promise<Response>): Promise<Response> {
  const ctrl = new AbortController();
  const t = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
  return fn(ctrl.signal).finally(() => clearTimeout(t));
}

/** Pull the first {...} block out of a model response (defensive parsing). */
function extractJson(text: string): string {
  const start = text.indexOf("{");
  const end = text.lastIndexOf("}");
  if (start === -1 || end === -1 || end < start) return "{}";
  return text.slice(start, end + 1);
}

/** Keep only the requested keys, coercing everything to trimmed strings. */
export function coerceShape(
  obj: Record<string, unknown> | null,
  keys: string[],
): Record<string, string> | null {
  if (!obj) return null;
  const out: Record<string, string> = {};
  for (const k of keys) {
    const v = obj[k];
    if (v == null) return null; // incomplete → let caller use fallback
    out[k] = String(v).trim();
  }
  return out;
}
