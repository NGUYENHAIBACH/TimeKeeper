import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/approval_repository.dart';
import '../../services/approval/team_report_export_service.dart';
import '../settings/profile_viewmodel.dart';
import 'approval_context.dart';

part 'team_dashboard_viewmodel.g.dart';

/// ViewModel của màn Team Dashboard và xuất báo cáo.
@riverpod
class TeamDashboardViewModel extends _$TeamDashboardViewModel {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    ref.watch(profileViewModelProvider);
    final actor = await currentApprovalProfile(ref);
    return ref.read(approvalRepositoryProvider).dashboard(actor);
  }

  /// Xuất dữ liệu dashboard hiện tại thành PDF hoặc Excel.
  Future<String> export(bool pdf) async {
    final rows = await future;
    return ref.read(teamReportExportServiceProvider).export(rows, pdf);
  }
}
