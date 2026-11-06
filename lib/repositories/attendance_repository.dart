import 'dart:developer' as dev;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/datasources/attendance_local_ds.dart';
import 'package:timekeeper/datasources/attendance_remote_ds.dart';
import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/office_location.dart';
import 'package:timekeeper/models/work_shift.dart';

part 'attendance_repository.g.dart';

/// Repository chấm công dùng cho cả app.
@Riverpod(keepAlive: true)
Future<AttendanceRepository> attendanceRepository(Ref ref) async {
  final local = await ref.watch(attendanceLocalDataSourceProvider.future);
  return OfflineFirstAttendanceRepository(
    local: local,
    remote: ref.watch(attendanceRemoteDataSourceProvider),
  );
}

/// Interface duy nhất mà ViewModel dùng để đọc/ghi dữ liệu chấm công.
/// View KHÔNG gọi thẳng SQLite/Supabase.
///
/// TV1 (Home Dashboard) và TV5 (báo cáo) cũng đọc dữ liệu qua interface này.
abstract class AttendanceRepository {
  /// Văn phòng dùng để kiểm tra geofence.
  Future<OfficeLocation?> getOffice();

  /// Lưu lại văn phòng (chỉ dùng cho nút debug).
  Future<void> saveOffice(OfficeLocation office);

  /// Ca làm theo `profiles.shift_id`. Null hoặc không tìm thấy thì trả về
  /// ca hành chính [WorkShift.standard].
  Future<WorkShift> getShift(String? shiftId);

  /// Bản ghi của nhân viên trong ngày [day].
  Future<AttendanceRecord?> getRecord(String employeeId, DateTime day);

  /// Bản ghi cả tháng chứa [month].
  Future<List<AttendanceRecord>> getRecordsInMonth(String employeeId, DateTime month);

  /// Check-in. Ném [StateError] nếu hôm nay đã check-in.
  Future<AttendanceRecord> checkIn({
    required String employeeId,
    required DateTime at,
    required double latitude,
    required double longitude,
    required String? officeId,
    required int lateMinutes,
    required bool isLate,
  });

  /// Check-out. Ném [StateError] nếu chưa check-in hoặc đã check-out.
  Future<AttendanceRecord> checkOut({
    required String employeeId,
    required DateTime at,
    required double latitude,
    required double longitude,
    required int earlyLeaveMinutes,
  });

  /// Đơn bù công của ngày [day], mới nhất trước.
  Future<List<AttendanceCorrection>> getCorrections(String employeeId, DateTime day);

  /// Đơn bù công cả tháng chứa [month].
  Future<List<AttendanceCorrection>> getCorrectionsInMonth(
    String employeeId,
    DateTime month,
  );

  /// Gửi đơn bù công mới (trạng thái `pending`).
  Future<AttendanceCorrection> submitCorrection({
    required String employeeId,
    required DateTime workDate,
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String reason,
  });
}

/// Đọc Supabase khi có mạng và lưu bản sao vào SQLite; mất mạng thì đọc
/// SQLite. Ghi vào SQLite trước (`synced = 0`) rồi đẩy lên Supabase, lần
/// sau có mạng sẽ tự đẩy nốt những gì còn thiếu.
class OfflineFirstAttendanceRepository implements AttendanceRepository {
  OfflineFirstAttendanceRepository({
    required this._local,
    required this._remote,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final AttendanceLocalDataSource _local;
  final AttendanceRemoteDataSource _remote;
  final Uuid _uuid;

  Future<void>? _syncing;

  // ---------- office ----------

  @override
  Future<OfficeLocation?> getOffice() async {
    await _whenOnline(() async {
      final office = await _remote.getActiveOffice();
      if (office != null) await _local.upsertOffice(office);
    });
    return _local.getActiveOffice();
  }

  @override
  Future<void> saveOffice(OfficeLocation office) async {
    await _remote.updateOffice(office);
    await _local.upsertOffice(office);
  }

  @override
  Future<WorkShift> getShift(String? shiftId) async {
    if (shiftId == null) return WorkShift.standard;
    await _whenOnline(() async {
      final shift = await _remote.getShift(shiftId);
      if (shift != null) await _local.upsertShift(shift);
    });
    return await _local.getShift(shiftId) ?? WorkShift.standard;
  }

  // ---------- records ----------

  @override
  Future<AttendanceRecord?> getRecord(String employeeId, DateTime day) async {
    final d = AppDate.dateOnly(day);
    await _refreshRecords(employeeId, d, d);
    return _local.getRecord(employeeId, d);
  }

  @override
  Future<List<AttendanceRecord>> getRecordsInMonth(
    String employeeId,
    DateTime month,
  ) async {
    final (from, to) = AppDate.monthRange(month);
    await _refreshRecords(employeeId, from, to);
    return _local.getRecordsBetween(employeeId, from, to);
  }

  @override
  Future<AttendanceRecord> checkIn({
    required String employeeId,
    required DateTime at,
    required double latitude,
    required double longitude,
    required String? officeId,
    required int lateMinutes,
    required bool isLate,
  }) async {
    final day = AppDate.dateOnly(at);
    final existing = await getRecord(employeeId, day);
    if (existing != null && existing.hasCheckedIn) {
      throw StateError('Hôm nay bạn đã check-in rồi.');
    }
    final record = AttendanceRecord(
      id: existing?.id ?? _uuid.v4(),
      employeeId: employeeId,
      workDate: day,
      checkInAt: at,
      checkInLat: latitude,
      checkInLng: longitude,
      officeId: officeId,
      lateMinutes: lateMinutes,
      status: isLate ? AttendanceRecordStatus.late : AttendanceRecordStatus.present,
      synced: false,
    );
    await _local.upsertRecord(record);
    return _pushRecord(record);
  }

  @override
  Future<AttendanceRecord> checkOut({
    required String employeeId,
    required DateTime at,
    required double latitude,
    required double longitude,
    required int earlyLeaveMinutes,
  }) async {
    final existing = await getRecord(employeeId, at);
    if (existing == null || !existing.hasCheckedIn) {
      throw StateError('Bạn chưa check-in hôm nay.');
    }
    if (existing.hasCheckedOut) {
      throw StateError('Hôm nay bạn đã check-out rồi.');
    }
    final minutes = at.difference(existing.checkInAt!).inMinutes;
    final record = existing.copyWith(
      checkOutAt: at,
      checkOutLat: latitude,
      checkOutLng: longitude,
      earlyLeaveMinutes: earlyLeaveMinutes,
      workHours: minutes / 60,
      synced: false,
    );
    await _local.upsertRecord(record);
    return _pushRecord(record);
  }

  // ---------- corrections ----------

  @override
  Future<List<AttendanceCorrection>> getCorrections(
    String employeeId,
    DateTime day,
  ) async {
    final d = AppDate.dateOnly(day);
    await _refreshCorrections(employeeId, d, d);
    return _local.getCorrectionsBetween(employeeId, d, d);
  }

  @override
  Future<List<AttendanceCorrection>> getCorrectionsInMonth(
    String employeeId,
    DateTime month,
  ) async {
    final (from, to) = AppDate.monthRange(month);
    await _refreshCorrections(employeeId, from, to);
    return _local.getCorrectionsBetween(employeeId, from, to);
  }

  @override
  Future<AttendanceCorrection> submitCorrection({
    required String employeeId,
    required DateTime workDate,
    required DateTime? checkIn,
    required DateTime? checkOut,
    required String reason,
  }) async {
    final day = AppDate.dateOnly(workDate);
    final record = await _local.getRecord(employeeId, day);
    final correction = AttendanceCorrection(
      id: _uuid.v4(),
      employeeId: employeeId,
      workDate: day,
      // Chỉ gắn khi bản ghi đã có trên server, tránh lỗi khóa ngoại.
      attendanceId: (record?.synced ?? false) ? record!.id : null,
      requestedCheckIn: checkIn,
      requestedCheckOut: checkOut,
      reason: reason.trim(),
      createdAt: DateTime.now(),
      synced: false,
    );
    await _local.upsertCorrection(correction);
    try {
      await _remote.upsertCorrection(correction);
      await _local.markCorrectionSynced(correction.id);
      return correction.copyWith(synced: true);
    } catch (e) {
      dev.log('Chưa đẩy được đơn bù công: $e', name: 'attendance');
      return correction;
    }
  }

  // ---------- đồng bộ ----------

  /// Đẩy các bản ghi/đơn còn `synced = 0` lên Supabase. Gọi đồng thời nhiều
  /// lần thì chỉ chạy một lượt.
  Future<void> syncPending() => _syncing ??= _doSync().whenComplete(() => _syncing = null);

  Future<void> _doSync() async {
    for (final r in await _local.getUnsyncedRecords()) {
      await _remote.upsertRecord(r);
      await _local.markRecordSynced(r.id);
    }
    for (final c in await _local.getUnsyncedCorrections()) {
      await _remote.upsertCorrection(c);
      await _local.markCorrectionSynced(c.id);
    }
  }

  Future<void> _refreshRecords(String employeeId, DateTime from, DateTime to) =>
      _whenOnline(() async {
        await syncPending();
        await _local.cacheRecords(
          await _remote.getRecordsBetween(employeeId, from, to),
        );
      });

  Future<void> _refreshCorrections(
    String employeeId,
    DateTime from,
    DateTime to,
  ) =>
      _whenOnline(() async {
        await syncPending();
        await _local.cacheCorrections(
          await _remote.getCorrectionsBetween(employeeId, from, to),
        );
      });

  Future<AttendanceRecord> _pushRecord(AttendanceRecord record) async {
    try {
      await _remote.upsertRecord(record);
      await _local.markRecordSynced(record.id);
      return record.copyWith(synced: true);
    } catch (e) {
      // Mất mạng: giữ trong SQLite, lần đọc sau sẽ tự đẩy lên.
      dev.log('Chưa đẩy được bản ghi chấm công: $e', name: 'attendance');
      return record;
    }
  }

  /// Chạy [action] trên Supabase. Lỗi mạng / timeout thì bỏ qua để dùng
  /// SQLite. Lỗi từ Postgres (sai cột, vi phạm ràng buộc...) thì ném ra để
  /// lập trình viên thấy, không bị che đi.
  Future<void> _whenOnline(Future<void> Function() action) async {
    try {
      await action();
    } on PostgrestException {
      rethrow;
    } catch (e) {
      dev.log('Supabase không truy cập được, dùng SQLite: $e', name: 'attendance');
    }
  }
}
