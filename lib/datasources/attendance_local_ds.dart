import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/models/attendance_correction.dart';
import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/office_location.dart';
import 'package:timekeeper/models/work_shift.dart';

part 'attendance_local_ds.g.dart';

/// Mở SQLite chấm công một lần cho cả app.
@Riverpod(keepAlive: true)
Future<AttendanceLocalDataSource> attendanceLocalDataSource(Ref ref) async {
  final db = await AttendanceLocalDataSource.open();
  ref.onDispose(db.close);
  return AttendanceLocalDataSource(db);
}

/// Lưu dữ liệu chấm công trong SQLite trên máy, để chấm công được khi
/// mất mạng (offline-first).
///
/// Bảng giống bảng trên Supabase, thêm cột `synced` (0 = chưa đẩy lên
/// server). File DB riêng `attendance.db`, không dùng chung với module khác.
class AttendanceLocalDataSource {
  AttendanceLocalDataSource(this._db);

  final Database _db;

  /// Tên file SQLite.
  static const dbName = 'attendance.db';
  static const _version = 2;

  /// Bảng ca làm (thêm ở bản 2), cache từ `shifts` trên Supabase.
  static const _createShifts = '''
    CREATE TABLE IF NOT EXISTS shifts (
      id TEXT PRIMARY KEY,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      grace_minutes INTEGER NOT NULL DEFAULT 5
    )''';

  /// Mở (hoặc tạo) file DB.
  static Future<Database> open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      p.join(dir, dbName),
      version: _version,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await db.execute(_createShifts);
      },
      onCreate: (db, version) async {
        await db.execute(_createShifts);
        await db.execute('''
          CREATE TABLE office_locations (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            address TEXT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            radius_meters INTEGER NOT NULL DEFAULT 100,
            is_active INTEGER NOT NULL DEFAULT 1
          )''');
        await db.execute('''
          CREATE TABLE attendance_records (
            id TEXT PRIMARY KEY,
            employee_id TEXT NOT NULL,
            work_date TEXT NOT NULL,
            check_in_at TEXT,
            check_out_at TEXT,
            check_in_lat REAL,
            check_in_lng REAL,
            check_out_lat REAL,
            check_out_lng REAL,
            office_id TEXT,
            late_minutes INTEGER NOT NULL DEFAULT 0,
            early_leave_minutes INTEGER NOT NULL DEFAULT 0,
            work_hours REAL NOT NULL DEFAULT 0,
            status TEXT NOT NULL DEFAULT 'present',
            is_mocked_location INTEGER NOT NULL DEFAULT 0,
            note TEXT,
            synced INTEGER NOT NULL DEFAULT 0,
            UNIQUE(employee_id, work_date)
          )''');
        await db.execute('''
          CREATE TABLE attendance_corrections (
            id TEXT PRIMARY KEY,
            employee_id TEXT NOT NULL,
            work_date TEXT NOT NULL,
            attendance_id TEXT,
            requested_check_in TEXT,
            requested_check_out TEXT,
            reason TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'pending',
            approved_by TEXT,
            approved_at TEXT,
            reject_reason TEXT,
            created_at TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0
          )''');
      },
    );
  }

  // ---------- office_locations ----------

  /// Văn phòng đang hoạt động đầu tiên (theo tên).
  Future<OfficeLocation?> getActiveOffice() async {
    final rows = await _db.query(
      'office_locations',
      where: 'is_active = 1',
      orderBy: 'name',
      limit: 1,
    );
    return rows.isEmpty ? null : OfficeLocation.fromMap(rows.first);
  }

  /// Thêm hoặc ghi đè văn phòng.
  Future<void> upsertOffice(OfficeLocation office) => _db.insert(
        'office_locations',
        office.toLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  // ---------- shifts ----------

  /// Ca làm đã lưu theo id, null nếu chưa có.
  Future<WorkShift?> getShift(String id) async {
    final rows = await _db.query('shifts', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : WorkShift.fromMap(rows.first);
  }

  /// Thêm hoặc ghi đè ca làm.
  Future<void> upsertShift(WorkShift shift) => _db.insert(
        'shifts',
        shift.toLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  // ---------- attendance_records ----------

  /// Bản ghi của nhân viên trong ngày [day], null nếu chưa có.
  Future<AttendanceRecord?> getRecord(String employeeId, DateTime day) async {
    final rows = await _db.query(
      'attendance_records',
      where: 'employee_id = ? AND work_date = ?',
      whereArgs: [employeeId, AppDate.key(day)],
      limit: 1,
    );
    return rows.isEmpty ? null : AttendanceRecord.fromMap(rows.first);
  }

  /// Bản ghi trong khoảng [from, to] (tính cả 2 đầu).
  Future<List<AttendanceRecord>> getRecordsBetween(
    String employeeId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _db.query(
      'attendance_records',
      where: 'employee_id = ? AND work_date BETWEEN ? AND ?',
      whereArgs: [employeeId, AppDate.key(from), AppDate.key(to)],
      orderBy: 'work_date',
    );
    return rows.map(AttendanceRecord.fromMap).toList();
  }

  /// Ghi một bản ghi (do người dùng vừa check-in/out).
  Future<void> upsertRecord(AttendanceRecord record) => _db.insert(
        'attendance_records',
        record.toLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  /// Lưu bản sao dữ liệu từ server. Bỏ qua ngày đang có bản ghi chưa
  /// đồng bộ để không mất thao tác offline của người dùng.
  Future<void> cacheRecords(List<AttendanceRecord> records) async {
    if (records.isEmpty) return;
    await _db.transaction((txn) async {
      final pending = await txn.query(
        'attendance_records',
        columns: ['employee_id', 'work_date'],
        where: 'synced = 0',
      );
      final skip = {for (final r in pending) '${r['employee_id']}|${r['work_date']}'};
      final batch = txn.batch();
      for (final r in records) {
        if (skip.contains('${r.employeeId}|${AppDate.key(r.workDate)}')) continue;
        batch.insert(
          'attendance_records',
          r.copyWith(synced: true).toLocal(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// Bản ghi chưa đẩy lên server.
  Future<List<AttendanceRecord>> getUnsyncedRecords() async {
    final rows = await _db.query('attendance_records', where: 'synced = 0');
    return rows.map(AttendanceRecord.fromMap).toList();
  }

  /// Đánh dấu bản ghi đã đồng bộ.
  Future<void> markRecordSynced(String id) => _db.update(
        'attendance_records',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );

  // ---------- attendance_corrections ----------

  /// Đơn bù công trong khoảng [from, to], mới nhất trước.
  Future<List<AttendanceCorrection>> getCorrectionsBetween(
    String employeeId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _db.query(
      'attendance_corrections',
      where: 'employee_id = ? AND work_date BETWEEN ? AND ?',
      whereArgs: [employeeId, AppDate.key(from), AppDate.key(to)],
      orderBy: 'created_at DESC',
    );
    return rows.map(AttendanceCorrection.fromMap).toList();
  }

  /// Ghi một đơn (do người dùng vừa gửi).
  Future<void> upsertCorrection(AttendanceCorrection c) => _db.insert(
        'attendance_corrections',
        c.toLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  /// Lưu bản sao đơn từ server (lấy trạng thái duyệt mới nhất), bỏ qua đơn
  /// chưa đồng bộ.
  Future<void> cacheCorrections(List<AttendanceCorrection> list) async {
    if (list.isEmpty) return;
    await _db.transaction((txn) async {
      final pending = await txn.query(
        'attendance_corrections',
        columns: ['id'],
        where: 'synced = 0',
      );
      final skip = {for (final r in pending) r['id']};
      final batch = txn.batch();
      for (final c in list) {
        if (skip.contains(c.id)) continue;
        batch.insert(
          'attendance_corrections',
          c.copyWith(synced: true).toLocal(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// Đơn chưa đẩy lên server.
  Future<List<AttendanceCorrection>> getUnsyncedCorrections() async {
    final rows = await _db.query('attendance_corrections', where: 'synced = 0');
    return rows.map(AttendanceCorrection.fromMap).toList();
  }

  /// Đánh dấu đơn đã đồng bộ.
  Future<void> markCorrectionSynced(String id) => _db.update(
        'attendance_corrections',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
}
