/// Tiện ích ngày giờ dùng chung cho cả nhóm.
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
