import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/approval_notification_service.dart';
import '../settings/profile_viewmodel.dart';

part 'approval_notification_sync.g.dart';

/// Starts/stops notification infrastructure with the authenticated profile.
@riverpod
Future<void> approvalNotificationSync(Ref ref) async {
  final service = ref.watch(approvalNotificationServiceProvider);
  final profile = await ref.watch(profileViewModelProvider.future);
  if (profile == null) {
    await service.stop();
    return;
  }
  await service.start(profile.id);
  ref.onDispose(() => unawaited(service.stop()));
}

@riverpod
Stream<Map<String, dynamic>> approvalNotificationOpenEvents(Ref ref) =>
    ref.watch(approvalNotificationServiceProvider).openEvents;

@riverpod
Stream<Map<String, dynamic>> approvalNotificationRealtimeEvents(Ref ref) =>
    ref.watch(approvalNotificationServiceProvider).realtimeEvents;
