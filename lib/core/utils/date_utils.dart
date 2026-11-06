import 'package:intl/intl.dart';

/// Tiện ích giờ phút cho phần Cài đặt và Home (TV1).
/// Các hàm ngày tháng, định dạng và đổi múi giờ dùng lớp [AppDate] bên dưới.
class AppDateUtils {
  AppDateUtils._();

  /// Chuyển sang chuỗi `yyyy-MM-dd` (kiểu `date` của Postgres), theo giờ máy.
  static String toDateString(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Ngày đầu tháng của [date].
  static DateTime firstDayOfMonth(DateTime date) => DateTime(date.year, date.month);

  /// Ngày cuối tháng của [date].
  static DateTime lastDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  /// Định dạng giờ phút `HH:mm` theo giờ máy.
  static String toHourMinute(DateTime time) {
    final local = time.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Đổi chuỗi `HH:mm` thành (giờ, phút). Trả null nếu sai định dạng.
  static (int hour, int minute)? parseHourMinute(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
    return (h, m);
  }

  /// Ghép giờ phút thành chuỗi `HH:mm`.
  static String formatHourMinute(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

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
