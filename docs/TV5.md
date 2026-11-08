# TV5 — Deployment and verification status

## Contract with TV2/TV3/TV4
Requests use `ot_requests`, `leave_requests`, `attendance_corrections` with UUID `id`, `employee_id`, `status`, `reason`, `approved_by`, `approved_at`, `reject_reason`. Only pending requests may be decided; managers see direct reports, admins see other employees. Dashboard uses today's `attendance_records.late_minutes` and approved leave spanning today. Half-day leave is included as leave, not counted as a full-day total.

## Deployment
Run schema.sql then tv5_approval.sql in Supabase SQL Editor. RPC updates request and inserts notification atomically, with row locking to prevent double decisions. Before invoking the RPC, configure Firebase third-party authentication in Supabase and supply Firebase ID tokens through Supabase client's accessToken callback. The current app's anonymous Supabase client cannot invoke this RPC. Do not remove identity validation to make it work.

The existing schema grants broad development access; replace dev_all policies before production. Leave-balance accounting must be agreed with TV4 before claiming approved leave updates balances.

ApprovalNotifications provides FCM token registration and foreground local notifications, but is not yet wired into app lifecycle. A trusted server/Edge Function must send FCM HTTP v1 messages after notifications are inserted. Never put service account credentials in Flutter. Scheduled reminders and notification tap routing still require completion.

## Test results
Implementation is under verification. No successful release build or end-to-end approval/push test has been established for TV5 yet. Earlier app tests do not validate this module.

Required checks: employee denied approval; manager denied outside team; blank rejection reason denied; simultaneous decisions create one notification; employee opens correct request; expired token handling; foreground/background/terminated push; timezone and reboot reminder behavior; empty/error/data screens; PDF and Excel output.

## Demo (3 minutes)
1. Manager opens inbox and selects pending request (45 seconds).
2. Explain View → ViewModel → Repository → atomic SQL transaction (45 seconds).
3. Employee opens notification and request details (45 seconds).
4. Show daily team dashboard/export and discuss deployment limitations (45 seconds).

## Conclusion
Three screens and their independent Riverpod ViewModels are implemented against shared schema. Deployment, secure Firebase/Supabase integration, server-side push delivery and reminders remain prerequisites for a complete demo.
