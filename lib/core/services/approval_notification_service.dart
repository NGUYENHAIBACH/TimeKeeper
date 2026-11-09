import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/core_providers.dart';

part 'approval_notification_service.g.dart';

/// Owns FCM and Supabase Realtime listeners for the signed-in profile.
class ApprovalNotificationService {
  ApprovalNotificationService(this.client);

  final SupabaseClient client;
  final local = FlutterLocalNotificationsPlugin();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final _openEvents = StreamController<Map<String, dynamic>>.broadcast();
  final _realtimeEvents = StreamController<Map<String, dynamic>>.broadcast();
  RealtimeChannel? _channel;

  Stream<Map<String, dynamic>> get openEvents => _openEvents.stream;
  Stream<Map<String, dynamic>> get realtimeEvents => _realtimeEvents.stream;

  Future<void> start(String profileId) async {
    await stop();
    await local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final decoded = jsonDecode(payload);
        if (decoded is Map) {
          _openEvents.add(Map<String, dynamic>.from(decoded));
        }
      },
    );
    await FirebaseMessaging.instance.requestPermission();

    Future<void> save(String token) => client.from('fcm_tokens').upsert({
      'employee_id': profileId,
      'token': token,
      'platform': 'android',
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'token');

    // ignore: deprecated_member_use
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await save(token);
    _subscriptions.add(
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          await save(token);
        } catch (_) {
          // Retry when the next app session starts.
        }
      }),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessage.listen((message) async {
        await local.show(
          id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
          title: message.notification?.title ?? 'TimeKeeper',
          body: message.notification?.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'approval',
              'Duyệt đơn',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _openEvents.add(message.data),
      ),
    );
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _openEvents.add(initial.data);

    _channel = client
        .channel('notifications-$profileId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: profileId,
          ),
          callback: (payload) => _realtimeEvents.add(payload.newRecord),
        )
        .subscribe();
  }

  Future<void> stop() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    final channel = _channel;
    _channel = null;
    if (channel != null) await client.removeChannel(channel);
  }
}

@Riverpod(keepAlive: true)
ApprovalNotificationService approvalNotificationService(Ref ref) =>
    ApprovalNotificationService(ref.watch(supabaseProvider));
