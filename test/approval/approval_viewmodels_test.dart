import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/repositories/approval_repository.dart';
import 'package:timekeeper/viewmodels/approval/approval_inbox_viewmodel.dart';
import 'package:timekeeper/viewmodels/approval/notification_center_viewmodel.dart';
import 'package:timekeeper/viewmodels/approval/team_dashboard_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

const manager = Profile(
  id: 'manager-1',
  firebaseUid: 'firebase-manager',
  email: 'manager@timekeeper.vn',
  role: UserRole.manager,
);

class _ProfileViewModel extends ProfileViewModel {
  @override
  Future<Profile?> build() async => manager;
}

class _ApprovalRepository extends ApprovalRepository {
  _ApprovalRepository() : super(SupabaseClient('https://example.supabase.co', 'test-key'));

  final decisions = <(String, bool, String)>[];

  @override
  Future<List<Map<String, dynamic>>> inbox(Profile actor) async => [
    {
      'id': 'leave-1',
      'table': 'leave_requests',
      'employee_id': 'employee-1',
      'total_days': 1.5,
    },
  ];

  @override
  Future<void> decide(
    Profile actor,
    Map<String, dynamic> row,
    bool approve,
    String reason,
  ) async {
    decisions.add((row['id'] as String, approve, reason));
  }

  @override
  Future<List<Map<String, dynamic>>> notifications(Profile actor) async => [
    {
      'id': 'notification-1',
      'recipient_id': actor.id,
      'ref_table': 'leave_requests',
      'ref_id': 'leave-1',
    },
  ];

  @override
  Future<Map<String, dynamic>> detail(
    Profile actor,
    String table,
    String id,
  ) async => {'id': id, 'table': table};

  @override
  Future<void> markRead(Profile actor, String id) async {}

  @override
  Future<List<Map<String, dynamic>>> dashboard(Profile actor) async => [
    {'employee_id': 'employee-1', 'kind': 'Đi muộn', 'late_minutes': 10},
  ];
}

ProviderContainer _container(_ApprovalRepository repository) {
  final container = ProviderContainer(
    overrides: [
      profileViewModelProvider.overrideWith(_ProfileViewModel.new),
      approvalRepositoryProvider.overrideWithValue(repository),
    ],
  );
  container.listen(approvalInboxViewModelProvider, (_, _) {});
  container.listen(notificationCenterViewModelProvider, (_, _) {});
  container.listen(teamDashboardViewModelProvider, (_, _) {});
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('ApprovalInboxViewModel tải dữ liệu và chuyển thao tác duyệt', () async {
    final repository = _ApprovalRepository();
    final container = _container(repository);

    final rows = await container.read(approvalInboxViewModelProvider.future);
    expect(rows.single['table'], 'leave_requests');

    await container
        .read(approvalInboxViewModelProvider.notifier)
        .decide(rows.single, true, '');
    expect(repository.decisions, [('leave-1', true, '')]);
  });

  test('NotificationCenterViewModel mở đúng đơn được tham chiếu', () async {
    final container = _container(_ApprovalRepository());
    final rows = await container.read(notificationCenterViewModelProvider.future);
    final detail = await container
        .read(notificationCenterViewModelProvider.notifier)
        .detail(rows.single['ref_table'] as String, rows.single['ref_id'] as String);
    expect(detail, {'id': 'leave-1', 'table': 'leave_requests'});
  });

  test('TeamDashboardViewModel tải dữ liệu thật qua repository', () async {
    final container = _container(_ApprovalRepository());
    final rows = await container.read(teamDashboardViewModelProvider.future);
    expect(rows.single['late_minutes'], 10);
  });

  test('route push giữ đủ bảng, đơn và notification id', () {
    final uri = Uri.parse(
      AppRoutes.notificationDetail(
        table: 'attendance_corrections',
        id: 'correction-1',
        notificationId: 'notification-1',
      ),
    );
    expect(uri.path, AppRoutes.notifications);
    expect(uri.queryParameters['table'], 'attendance_corrections');
    expect(uri.queryParameters['id'], 'correction-1');
    expect(uri.queryParameters['notificationId'], 'notification-1');
  });
}
