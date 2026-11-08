import 'package:timekeeper/models/holiday.dart';
import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/models/leave_type.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

/// Dữ liệu giả dùng chung cho test module Nghỉ phép.
final testYear = DateTime.now().year;

const testProfile = Profile(
  id: 'emp-1',
  firebaseUid: 'uid-1',
  email: 'a@test.com',
  fullName: 'Nguyễn Văn A',
  departmentId: 'dep-1',
);

const annual = LeaveType(id: 'lt-annual', code: 'annual', name: 'Nghỉ phép năm', defaultDays: 12);
const sick = LeaveType(
  id: 'lt-sick',
  code: 'sick',
  name: 'Nghỉ ốm',
  defaultDays: 30,
  requiresDocument: true,
);
const unpaid = LeaveType(id: 'lt-unpaid', code: 'unpaid', name: 'Nghỉ không lương', isPaid: false);

LeaveBalance balance(LeaveType t, {double total = 12, double used = 0}) => LeaveBalance(
      id: 'b-${t.id}',
      employeeId: testProfile.id,
      leaveTypeId: t.id,
      year: testYear,
      totalDays: total,
      usedDays: used,
      remainingDays: total - used,
      leaveType: t,
    );

LeaveRequest request(
  String id, {
  LeaveType type = annual,
  required DateTime start,
  DateTime? end,
  double days = 1,
  LeaveStatus status = LeaveStatus.pending,
  HalfDay halfDay = HalfDay.none,
  String employeeId = 'emp-1',
  String? employeeName,
  String reason = 'Việc gia đình',
}) =>
    LeaveRequest(
      id: id,
      employeeId: employeeId,
      leaveTypeId: type.id,
      startDate: start,
      endDate: end ?? start,
      halfDay: halfDay,
      totalDays: days,
      reason: reason,
      status: status,
      leaveType: type,
      employeeName: employeeName,
    );

/// Hồ sơ giả, không cần Firebase.
class FakeProfileViewModel extends ProfileViewModel {
  @override
  Future<Profile?> build() async => testProfile;
}

/// Repository giả, ghi lại các lời gọi để test kiểm tra.
class FakeLeaveRequestRepository implements LeaveRequestRepository {
  FakeLeaveRequestRepository({
    this.types = const [annual, sick, unpaid],
    List<LeaveBalance>? balances,
    List<LeaveRequest>? requests,
    this.teamLeaves = const [],
    this.holidays = const [],
    this.error,
  })  : balances = balances ?? [balance(annual, total: 12, used: 2), balance(sick, total: 30)],
        requests = requests ?? [];

  final List<LeaveType> types;
  final List<LeaveBalance> balances;
  final List<LeaveRequest> requests;
  final List<LeaveRequest> teamLeaves;
  final List<Holiday> holidays;

  /// Nếu khác null, mọi lời gọi đọc dữ liệu ném lỗi này.
  final Object? error;

  final cancelled = <String>[];
  final submitted = <NewLeaveRequest>[];

  Future<T> _ret<T>(T v) async {
    if (error != null) throw error!;
    return v;
  }

  @override
  Future<List<LeaveType>> getLeaveTypes() => _ret(types);

  @override
  Future<List<Holiday>> getHolidaysOfYear(int year) => _ret(holidays);

  @override
  Future<List<Holiday>> getHolidays(DateTime from, DateTime to) => _ret(holidays);

  @override
  Future<List<LeaveBalance>> getBalances(String employeeId, int year) => _ret(balances);

  @override
  Future<List<LeaveRequest>> getMyRequests(String employeeId) => _ret(requests);

  @override
  Future<LeaveRequest> submit(NewLeaveRequest input) async {
    submitted.add(input);
    return request('new', start: input.startDate, end: input.endDate, days: input.totalDays);
  }

  @override
  Future<void> cancel(String requestId) async {
    cancelled.add(requestId);
    final i = requests.indexWhere((r) => r.id == requestId);
    if (i >= 0) requests[i] = requests[i].copyWith(status: LeaveStatus.cancelled);
  }

  @override
  Future<List<LeaveRequest>> getTeamLeaves({
    required DateTime from,
    required DateTime to,
    String? departmentId,
  }) =>
      _ret(teamLeaves);
}
