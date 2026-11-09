import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/approval_repository.dart';
import '../settings/profile_viewmodel.dart';
import 'approval_context.dart';

part 'approval_inbox_viewmodel.g.dart';

/// ViewModel của màn Hộp duyệt đơn.
@riverpod
class ApprovalInboxViewModel extends _$ApprovalInboxViewModel {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    final actor = await currentApprovalProfile(ref);
    return ref.read(approvalRepositoryProvider).inbox(actor);
  }

  /// Duyệt hoặc từ chối đơn rồi tải lại hộp duyệt.
  Future<void> decide(
    Map<String, dynamic> request,
    bool approve,
    String reason,
  ) async {
    final repository = ref.read(approvalRepositoryProvider);
    final actor = await currentApprovalProfile(ref);
    await repository.decide(actor, request, approve, reason);
    ref.invalidateSelf();
  }
}
