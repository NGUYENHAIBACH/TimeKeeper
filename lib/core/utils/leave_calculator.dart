import 'package:timekeeper/models/leave_request.dart';

/// Logic nghiệp vụ nghỉ phép, tách khỏi UI để unit test được.
class LeaveCalculator {
  LeaveCalculator._();

  /// Bỏ phần giờ, chỉ giữ ngày.
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Thứ 7 / Chủ nhật.
  static bool isWeekend(DateTime d) =>
      d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

  /// Ngày làm việc = không phải cuối tuần và không phải ngày lễ.
  static bool isWorkingDay(DateTime d, Set<DateTime> holidays) =>
      !isWeekend(d) && !holidays.contains(dateOnly(d));

  /// Đếm số ngày nghỉ thực tế từ [start] đến [end] (tính cả 2 đầu),
  /// bỏ qua cuối tuần và ngày lễ. Nghỉ nửa ngày (chỉ khi start == end)
  /// tính 0.5. Trả 0 nếu khoảng ngày không hợp lệ.
  static double countDays({
    required DateTime start,
    required DateTime end,
    HalfDay halfDay = HalfDay.none,
    Iterable<DateTime> holidays = const [],
  }) {
    final s = dateOnly(start);
    final e = dateOnly(end);
    if (e.isBefore(s)) return 0;
    final hs = holidays.map(dateOnly).toSet();

    if (halfDay != HalfDay.none) {
      if (s != e) return 0;
      return isWorkingDay(s, hs) ? 0.5 : 0;
    }

    var count = 0;
    for (var d = s; !d.isAfter(e); d = DateTime(d.year, d.month, d.day + 1)) {
      if (isWorkingDay(d, hs)) count++;
    }
    return count.toDouble();
  }

  /// Hai khoảng ngày có giao nhau không.
  static bool overlaps(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
    return !dateOnly(aEnd).isBefore(dateOnly(bStart)) &&
        !dateOnly(bEnd).isBefore(dateOnly(aStart));
  }

  /// Số dư còn dùng được = còn lại trên DB - các đơn đang chờ duyệt
  /// (đơn pending "giữ chỗ" số ngày, tránh gửi vượt khi chưa được duyệt).
  static double availableDays({
    required double remainingDays,
    required Iterable<LeaveRequest> pendingRequests,
  }) {
    final reserved = pendingRequests.fold<double>(0, (sum, r) => sum + r.totalDays);
    final v = remainingDays - reserved;
    return v < 0 ? 0 : v;
  }

  /// Kiểm tra đơn trước khi gửi. Trả null nếu hợp lệ, ngược lại trả
  /// thông báo lỗi tiếng Việt.
  ///
  /// - [available]: số ngày còn dùng được của loại phép; null = không giới hạn
  ///   (vd nghỉ không lương).
  /// - [existing]: các đơn của nhân viên để kiểm tra trùng ngày.
  static String? validate({
    required DateTime start,
    required DateTime end,
    required HalfDay halfDay,
    required double days,
    required double? available,
    required bool requiresDocument,
    required bool hasAttachment,
    Iterable<LeaveRequest> existing = const [],
  }) {
    if (dateOnly(end).isBefore(dateOnly(start))) {
      return 'Ngày kết thúc phải sau hoặc bằng ngày bắt đầu';
    }
    if (halfDay != HalfDay.none && dateOnly(start) != dateOnly(end)) {
      return 'Nghỉ nửa ngày chỉ áp dụng cho 1 ngày';
    }
    if (days <= 0) {
      return 'Khoảng ngày đã chọn không có ngày làm việc nào';
    }
    if (available != null && days > available) {
      return 'Vượt số dư phép: cần ${formatDays(days)} ngày, '
          'chỉ còn ${formatDays(available)} ngày';
    }
    if (requiresDocument && !hasAttachment) {
      return 'Loại phép này bắt buộc đính kèm giấy tờ';
    }
    final clash = existing.where((r) =>
        (r.status == LeaveStatus.pending || r.status == LeaveStatus.approved) &&
        overlaps(start, end, r.startDate, r.endDate));
    for (final r in clash) {
      // Hai đơn nửa ngày khác buổi trong cùng 1 ngày thì không trùng.
      final differentHalves = halfDay != HalfDay.none &&
          r.halfDay != HalfDay.none &&
          halfDay != r.halfDay;
      if (!differentHalves) return 'Đã có đơn nghỉ trùng khoảng ngày này';
    }
    return null;
  }

  /// Hiển thị số ngày gọn: 2.0 -> "2", 1.5 -> "1.5".
  static String formatDays(double d) =>
      d == d.roundToDouble() ? d.toInt().toString() : d.toStringAsFixed(1);
}
