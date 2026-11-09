import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/approval_repository.dart';
import '../settings/profile_viewmodel.dart';
import 'approval_context.dart';

part 'notification_center_viewmodel.g.dart';

/// ViewModel của màn Trung tâm thông báo.
@riverpod
class NotificationCenterViewModel extends _$NotificationCenterViewModel {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    final actor = await currentApprovalProfile(ref);
    return ref.read(approvalRepositoryProvider).notifications(actor);
  }

  /// Đọc chi tiết đơn được tham chiếu bởi thông báo.
  Future<Map<String, dynamic>> detail(String table, String id) async {
    final actor = await currentApprovalProfile(ref);
    return ref.read(approvalRepositoryProvider).detail(actor, table, id);
  }

  /// Đánh dấu thông báo đã đọc rồi tải lại danh sách.
  Future<void> markRead(String id) async {
    final actor = await currentApprovalProfile(ref);
    await ref.read(approvalRepositoryProvider).markRead(actor, id);
    ref.invalidateSelf();
  }
}
