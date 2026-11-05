import 'package:intl/intl.dart';

/// Các hàm ngày giờ dùng chung.
class AppDate {
  AppDate._();

  static final _dateKey = DateFormat('yyyy-MM-dd');
  static final _display = DateFormat('dd/MM/yyyy');
  static final _time = DateFormat('HH:mm');

  /// Bỏ phần giờ, chỉ giữ ngày.
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Hai mốc thời gian có cùng ngày không.
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Khóa ngày dạng `yyyy-MM-dd`, dùng cho cột `date` và query string.
  static String key(DateTime d) => _dateKey.format(d);

  /// Đọc khóa ngày `yyyy-MM-dd`.
  static DateTime parseKey(String s) => _dateKey.parse(s);

  /// Thời điểm -> chuỗi ISO giờ UTC, dùng cho cột `timestamptz`.
  /// Phải đổi sang UTC, nếu không Supabase hiểu nhầm giờ VN là giờ UTC.
  static String? toDb(DateTime? d) => d?.toUtc().toIso8601String();

  /// Chuỗi ISO từ DB -> giờ địa phương.
  static DateTime? fromDb(Object? v) =>
      v == null ? null : DateTime.parse(v as String).toLocal();

  /// `dd/MM/yyyy`
  static String display(DateTime d) => _display.format(d);

  /// `HH:mm`, hoặc `--:--` nếu null.
  static String time(DateTime? d) => d == null ? '--:--' : _time.format(d);

  /// Thứ Bảy hoặc Chủ Nhật.
  static bool isWeekend(DateTime d) =>
      d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

  /// "Thứ Hai" ... "Chủ Nhật".
  static String weekdayName(DateTime d) => const [
        'Thứ Hai',
        'Thứ Ba',
        'Thứ Tư',
        'Thứ Năm',
        'Thứ Sáu',
        'Thứ Bảy',
        'Chủ Nhật',
      ][d.weekday - 1];

  /// "7 giờ 30 phút"
  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '$m phút';
    return m == 0 ? '$h giờ' : '$h giờ $m phút';
  }

  /// Ngày đầu và ngày cuối của tháng chứa [month].
  static (DateTime, DateTime) monthRange(DateTime month) => (
        DateTime(month.year, month.month, 1),
        DateTime(month.year, month.month + 1, 0),
      );
}
