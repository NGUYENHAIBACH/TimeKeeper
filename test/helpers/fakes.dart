// Đồ giả dùng chung cho các test của TV1.

import 'package:timekeeper/models/attendance_record.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

/// Hồ sơ mẫu.
const testProfile = Profile(
  id: '11111111-1111-1111-1111-111111111111',
  firebaseUid: 'firebase-uid-1',
  email: 'nhanvien.a@timekeeper.vn',
  fullName: 'Nguyen Van A',
);

/// ProfileViewModel giả: trả về hồ sơ cố định, không gọi Firebase / Supabase.
/// Dùng: `profileViewModelProvider.overrideWith(() => FakeProfileViewModel(p))`.
class FakeProfileViewModel extends ProfileViewModel {
  FakeProfileViewModel(this.profile);
  final Profile? profile;

  @override
  Future<Profile?> build() async => profile;
}

/// Tạo nhanh một bản ghi chấm công (model của TV2) cho test.
/// [checkIn] / [checkOut] là giờ trong ngày [day]; bỏ trống = chưa chấm.
AttendanceRecord attendanceOf(
  int day, {
  (int, int)? checkIn = (8, 0),
  (int, int)? checkOut,
  double hours = 0,
  int late = 0,
}) {
  final date = DateTime(2026, 11, day);
  DateTime? at((int, int)? t) =>
      t == null ? null : DateTime(2026, 11, day, t.$1, t.$2);
  return AttendanceRecord(
    id: 'rec-$day',
    employeeId: testProfile.id,
    workDate: date,
    checkInAt: at(checkIn),
    checkOutAt: at(checkOut),
    workHours: hours,
    lateMinutes: late,
    status: late > 0 ? AttendanceRecordStatus.late : AttendanceRecordStatus.present,
  );
}

/// Hai ngày công mẫu: 8 giờ đúng giờ + 7.5 giờ đi trễ 15 phút = 15.5 giờ.
final sampleMonthRecords = [
  attendanceOf(2, checkOut: (17, 0), hours: 8),
  attendanceOf(3, checkIn: (8, 20), checkOut: (17, 0), hours: 7.5, late: 15),
];
