import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/models/leave_type.dart';
import 'package:timekeeper/repositories/leave_request_repository.dart';
import 'package:timekeeper/viewmodels/leave/leave_history_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'leave_form_viewmodel.g.dart';

/// Dữ liệu màn Form xin nghỉ: loại phép, số dư, ngày lễ, đơn đã gửi.
class LeaveFormData {
  LeaveFormData({
    required this.employeeId,
    required this.year,
    required this.types,
    required this.balances,
    required this.holidays,
    required this.myRequests,
  });

  final String employeeId;

  /// Năm áp dụng số dư (đơn chỉ được chọn ngày trong năm này).
  final int year;
  final List<LeaveType> types;
  final List<LeaveBalance> balances;
  final Set<DateTime> holidays;
  final List<LeaveRequest> myRequests;

  /// Số dư của loại phép [typeId], null nếu chưa có.
  LeaveBalance? balanceOf(String typeId) {
    for (final b in balances) {
      if (b.leaveTypeId == typeId) return b;
    }
    return null;
  }

  /// Số ngày còn được xin của loại phép [type] (đã trừ đơn đang chờ).
  /// Null = không giới hạn (phép không lương).
  double? availableFor(LeaveType type) {
    if (!type.isPaid) return null;
    final pending = myRequests.where(
      (r) => r.leaveTypeId == type.id && r.status == LeaveStatus.pending && r.startDate.year == year,
    );
    return LeaveCalculator.availableDays(
      remainingDays: balanceOf(type.id)?.remainingDays ?? 0,
      pendingRequests: pending,
    );
  }

  /// Số ngày nghỉ thực tế của khoảng ngày đã chọn.
  double countDays(DateTime start, DateTime end, HalfDay halfDay) =>
      LeaveCalculator.countDays(
        start: start,
        end: end,
        halfDay: halfDay,
        holidays: holidays,
      );

  /// Kiểm tra toàn bộ nghiệp vụ, trả thông báo lỗi hoặc null nếu hợp lệ.
  String? validate({
    required LeaveType? type,
    required DateTime? start,
    required DateTime? end,
    required HalfDay halfDay,
    required String reason,
    required bool hasAttachment,
  }) {
    if (type == null) return 'Chọn loại phép';
    if (start == null || end == null) return 'Chọn ngày nghỉ';
    if (start.year != year || end.year != year) {
      return 'Chỉ xin nghỉ trong năm $year';
    }
    if (reason.trim().length < 5) return 'Lý do tối thiểu 5 ký tự';
    return LeaveCalculator.validate(
      start: start,
      end: end,
      halfDay: halfDay,
      days: countDays(start, end, halfDay),
      available: availableFor(type),
      requiresDocument: type.requiresDocument,
      hasAttachment: hasAttachment,
      existing: myRequests,
    );
  }
}

/// ViewModel tải dữ liệu cho Form xin nghỉ (loading / error / data).
@riverpod
class LeaveFormViewModel extends _$LeaveFormViewModel {
  @override
  Future<LeaveFormData> build() async {
    final profile = await ref.watch(profileViewModelProvider.future);
    if (profile == null) throw Exception('Chưa có hồ sơ nhân viên');
    final repo = ref.read(leaveRequestRepositoryProvider);
    final year = DateTime.now().year;

    final types = await repo.getLeaveTypes();
    final balances = await repo.getBalances(profile.id, year);
    final holidays = await repo.getHolidaysOfYear(year);
    final requests = await repo.getMyRequests(profile.id);
    return LeaveFormData(
      employeeId: profile.id,
      year: year,
      types: types,
      balances: balances,
      holidays: {for (final h in holidays) LeaveCalculator.dateOnly(h.holidayDate)},
      myRequests: requests,
    );
  }

  /// Tải lại dữ liệu.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// ViewModel gửi đơn. State `AsyncValue<LeaveRequest?>`: null = chưa gửi,
/// có giá trị = vừa gửi thành công, error = gửi lỗi.
@riverpod
class LeaveSubmitViewModel extends _$LeaveSubmitViewModel {
  @override
  FutureOr<LeaveRequest?> build() => null;

  /// Kiểm tra lại nghiệp vụ rồi gửi đơn (upload file nếu có).
  /// Trả true nếu gửi thành công.
  Future<bool> submit({
    required LeaveType? type,
    required DateTime? start,
    required DateTime? end,
    required HalfDay halfDay,
    required String reason,
    LeaveAttachment? attachment,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.read(leaveFormViewModelProvider.future);
      final error = data.validate(
        type: type,
        start: start,
        end: end,
        halfDay: halfDay,
        reason: reason,
        hasAttachment: attachment != null,
      );
      if (error != null) throw Exception(error);

      final created = await ref.read(leaveRequestRepositoryProvider).submit(
            NewLeaveRequest(
              employeeId: data.employeeId,
              leaveTypeId: type!.id,
              startDate: start!,
              endDate: end!,
              halfDay: halfDay,
              totalDays: data.countDays(start, end, halfDay),
              reason: reason,
              attachment: attachment,
            ),
          );
      // Màn lịch sử và số dư cần tải lại. Form không invalidate ở đây vì
      // View sẽ đóng ngay sau khi gửi thành công (autoDispose tự tải lại).
      ref.invalidate(leaveHistoryViewModelProvider);
      return created;
    });
    return !state.hasError;
  }
}
