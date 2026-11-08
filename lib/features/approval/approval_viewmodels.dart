import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'approval_repository.dart';
import '../settings/viewmodel/profile_viewmodel.dart';
part 'approval_viewmodels.g.dart';

@riverpod
class ApprovalInbox extends _$ApprovalInbox {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    return ref
        .read(approvalRepositoryProvider)
        .inbox(await currentProfile(ref));
  }

  Future<void> decide(
    Map<String, dynamic> row,
    bool approve,
    String reason,
  ) async {
    final repository = ref.read(approvalRepositoryProvider);
    final actor = await currentProfile(ref);
    await repository.decide(actor, row, approve, reason);
    ref.invalidateSelf();
  }
}

@riverpod
class NotificationCenter extends _$NotificationCenter {
  Future<Map<String, dynamic>> detail(String table, String id) async => ref
      .read(approvalRepositoryProvider)
      .detail(await currentProfile(ref), table, id);
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    return ref
        .read(approvalRepositoryProvider)
        .notifications(await currentProfile(ref));
  }

  Future<void> markRead(String id) async {
    await ref
        .read(approvalRepositoryProvider)
        .markRead(await currentProfile(ref), id);
    ref.invalidateSelf();
  }
}

@riverpod
class TeamDashboard extends _$TeamDashboard {
  Future<String> export(bool pdf) async =>
      ref.read(approvalRepositoryProvider).export(await future, pdf);
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    return ref
        .read(approvalRepositoryProvider)
        .dashboard(await currentProfile(ref));
  }
}
