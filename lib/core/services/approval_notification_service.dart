import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Owns FCM listeners. The caller must stop this service on sign-out.
class ApprovalNotificationService {
  ApprovalNotificationService(this.client);
  final SupabaseClient client;
  final local = FlutterLocalNotificationsPlugin();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Future<void> start(
    String profileId,
    void Function(Map<String, dynamic>) onOpen,
  ) async {
    await stop();
    await local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    await FirebaseMessaging.instance.requestPermission();
    Future<void> save(String token) async {
      await client.from('fcm_tokens').upsert({
        'employee_id': profileId,
        'token': token,
        'platform': 'android',
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'token');
    }

    // ignore: deprecated_member_use
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await save(token);
    _subscriptions.add(
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          await save(token);
        } catch (_) {
          /* Retry on next app session. */
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
        );
      }),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => onOpen(message.data),
      ),
    );
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) onOpen(initial.data);
  }

  Future<void> stop() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }
}
