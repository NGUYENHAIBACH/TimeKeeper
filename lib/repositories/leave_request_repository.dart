import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/datasources/leave_request_datasource.dart';
import 'package:timekeeper/models/holiday.dart';
import 'package:timekeeper/models/leave_balance.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/models/leave_type.dart';

part 'leave_request_repository.g.dart';

/// File đính kèm người dùng chọn (chưa upload).
class LeaveAttachment {
  const LeaveAttachment({required this.name, required this.bytes});

  /// Tên file gốc, vd `giay_kham.pdf`.
  final String name;
  final Uint8List bytes;

  /// Dung lượng tối đa cho phép: 5 MB.
  static const maxBytes = 5 * 1024 * 1024;

  /// Đuôi file hợp lệ.
  static const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
}

/// Dữ liệu đầu vào để tạo đơn nghỉ.
class NewLeaveRequest {
  const NewLeaveRequest({
    required this.employeeId,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.halfDay,
    required this.totalDays,
    required this.reason,
    this.attachment,
  });

  final String employeeId;
  final String leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final HalfDay halfDay;
  final double totalDays;
  final String reason;
  final LeaveAttachment? attachment;
}

/// Repository module Nghỉ phép (TV4): đơn nghỉ, số dư theo loại phép, ngày lễ,
/// file đính kèm. ViewModel của TV4 chỉ làm việc với lớp này.
/// (`LeaveRepository` trong `leave_repository.dart` là phần đọc số dư cho
/// Home Dashboard của TV1, giữ nguyên.)
class LeaveRequestRepository {
  LeaveRequestRepository(this._ds);

  final LeaveRequestDataSource _ds;

  /// Danh sách loại phép.
  Future<List<LeaveType>> getLeaveTypes() => _ds.getLeaveTypes();

  /// Ngày lễ của cả năm [year].
  Future<List<Holiday>> getHolidaysOfYear(int year) =>
      _ds.getHolidays(DateTime(year), DateTime(year, 12, 31));

  /// Ngày lễ trong khoảng ngày.
  Future<List<Holiday>> getHolidays(DateTime from, DateTime to) =>
      _ds.getHolidays(from, to);

  /// Số dư phép năm [year]. Nếu nhân viên chưa có dòng số dư cho loại phép
  /// nào thì tự tạo theo `default_days` của loại phép đó.
  Future<List<LeaveBalance>> getBalances(String employeeId, int year) async {
    var balances = await _ds.getBalances(employeeId, year);
    final types = await _ds.getLeaveTypes();
    final have = balances.map((b) => b.leaveTypeId).toSet();
    final missing = types.where((t) => !have.contains(t.id)).toList();
    if (missing.isNotEmpty) {
      await _ds.insertBalances([
        for (final t in missing)
          {
            'employee_id': employeeId,
            'leave_type_id': t.id,
            'year': year,
            'total_days': t.defaultDays,
          },
      ]);
      balances = await _ds.getBalances(employeeId, year);
    }
    balances.sort((a, b) =>
        (a.leaveType?.name ?? '').compareTo(b.leaveType?.name ?? ''));
    return balances;
  }

  /// Đơn nghỉ của tôi, mới nhất trước.
  Future<List<LeaveRequest>> getMyRequests(String employeeId) =>
      _ds.getMyRequests(employeeId);

  /// Gửi đơn: upload file (nếu có) lên Supabase Storage rồi ghi đơn.
  /// Ghi đơn lỗi thì xóa file vừa upload để không để rác trong bucket.
  Future<LeaveRequest> submit(NewLeaveRequest input) async {
    String? url;
    final file = input.attachment;
    if (file != null) {
      url = await _ds.uploadAttachment(input.employeeId, file.bytes, file.name);
    }
    try {
      return await _ds.insertRequest({
        'employee_id': input.employeeId,
        'leave_type_id': input.leaveTypeId,
        'start_date': LeaveRequestDataSource.toDbDate(input.startDate),
        'end_date': LeaveRequestDataSource.toDbDate(input.endDate),
        'half_day': input.halfDay.dbValue,
        'total_days': input.totalDays,
        'reason': input.reason.trim(),
        'attachment_url': url,
      });
    } catch (_) {
      if (url != null) {
        try {
          await _ds.deleteAttachment(url);
        } catch (_) {}
      }
      rethrow;
    }
  }

  /// Hủy đơn đang chờ duyệt.
  Future<void> cancel(String requestId) => _ds.cancelRequest(requestId);

  /// Lịch nghỉ của đồng nghiệp cùng phòng ban trong khoảng ngày.
  Future<List<LeaveRequest>> getTeamLeaves({
    required DateTime from,
    required DateTime to,
    String? departmentId,
  }) =>
      _ds.getTeamLeaves(from: from, to: to, departmentId: departmentId);
}

/// Provider LeaveRequestRepository (keepAlive).
@Riverpod(keepAlive: true)
LeaveRequestRepository leaveRequestRepository(Ref ref) {
  return LeaveRequestRepository(ref.watch(leaveRequestDataSourceProvider));
}
