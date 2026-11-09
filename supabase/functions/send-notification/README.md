# send-notification

Edge Function nhận Database Webhook khi có dòng mới trong `notifications`, lấy
token thiết bị của người nhận và gửi FCM HTTP v1.

## Deploy

```bash
supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON='<service-account-json-one-line>'
supabase secrets set FCM_WEBHOOK_SECRET='<random-secret>'
supabase functions deploy send-notification --no-verify-jwt
```

Trong Supabase Dashboard tạo Database Webhook:

- Table: `public.notifications`
- Event: `INSERT`
- URL: `https://<project-ref>.supabase.co/functions/v1/send-notification`
- Header: `x-webhook-secret: <FCM_WEBHOOK_SECRET>`

Không commit file service-account Firebase vào repository.
