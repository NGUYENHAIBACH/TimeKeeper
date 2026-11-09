import { createClient } from "npm:@supabase/supabase-js@2";
import { GoogleAuth } from "npm:google-auth-library@10";

type NotificationRow = {
  id: string;
  recipient_id: string;
  title: string;
  body: string;
  type: string;
  ref_table: string | null;
  ref_id: string | null;
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });

Deno.serve(async (request) => {
  if (request.method !== "POST") return json({ error: "Method not allowed" }, 405);

  const webhookSecret = Deno.env.get("FCM_WEBHOOK_SECRET");
  if (!webhookSecret || request.headers.get("x-webhook-secret") !== webhookSecret) {
    return json({ error: "Unauthorized" }, 401);
  }

  const payload = await request.json();
  const record = (payload.record ?? payload) as NotificationRow;
  if (!record.id || !record.recipient_id) {
    return json({ error: "Invalid notification payload" }, 400);
  }

  const serviceAccountJson = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON");
  if (!serviceAccountJson) return json({ error: "Missing Firebase credentials" }, 500);
  const credentials = JSON.parse(serviceAccountJson);
  const projectId = credentials.project_id as string;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data: tokens, error } = await supabase
    .from("fcm_tokens")
    .select("token")
    .eq("employee_id", record.recipient_id);
  if (error) return json({ error: error.message }, 500);
  if (!tokens?.length) return json({ sent: 0, message: "No registered devices" });

  const auth = new GoogleAuth({
    credentials,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });
  const authClient = await auth.getClient();
  const accessToken = (await authClient.getAccessToken()).token;
  if (!accessToken) return json({ error: "Could not mint FCM access token" }, 500);

  const invalidTokens: string[] = [];
  let sent = 0;
  for (const { token } of tokens) {
    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
      {
        method: "POST",
        headers: {
          authorization: `Bearer ${accessToken}`,
          "content-type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token,
            notification: { title: record.title, body: record.body },
            data: {
              notification_id: record.id,
              type: record.type ?? "general",
              ref_table: record.ref_table ?? "",
              ref_id: record.ref_id ?? "",
            },
            android: { priority: "high" },
          },
        }),
      },
    );
    if (response.ok) {
      sent++;
      continue;
    }
    const failure = await response.text();
    if (response.status === 404 || failure.includes("UNREGISTERED")) {
      invalidTokens.push(token);
    } else {
      console.error("FCM send failed", response.status, failure);
    }
  }

  if (invalidTokens.length) {
    await supabase.from("fcm_tokens").delete().in("token", invalidTokens);
  }
  return json({ sent, removed_invalid_tokens: invalidTokens.length });
});
