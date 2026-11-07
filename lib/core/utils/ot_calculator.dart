/// Cac he so OT theo ke hoach nghiep vu cua TimeKeeper.
class OtMultiplier {
  OtMultiplier._();

  static const weekday = 1.5;
  static const weekend = 2.0;
  static const holiday = 3.0;
}

/// Tinh so gio va he so OT cho don tang ca.
class OtCalculator {
  OtCalculator._();

  /// Tra ve he so 300% cho ngay le, 200% cho cuoi tuan va 150% cho ngay thuong.
  /// Ngay le duoc uu tien neu trung vao thu Bay hoac Chu nhat.
  static double multiplierFor(
    DateTime date, {
    Iterable<DateTime> holidays = const [],
  }) {
    final isHoliday = holidays.any((holiday) => _isSameDate(date, holiday));
    if (isHoliday) return OtMultiplier.holiday;

    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    return isWeekend ? OtMultiplier.weekend : OtMultiplier.weekday;
  }

  /// Tinh so gio OT tu [start] den [end].
  ///
  /// Nem [ArgumentError] neu gio ket thuc khong sau gio bat dau.
  static double hoursBetween(DateTime start, DateTime end) {
    if (!end.isAfter(start)) {
      throw ArgumentError('Gio ket thuc phai sau gio bat dau');
    }
    return end.difference(start).inMinutes / Duration.minutesPerHour;
  }

  /// Tinh so gio OT quy doi sau khi ap dung he so.
  static double paidHours({
    required DateTime start,
    required DateTime end,
    Iterable<DateTime> holidays = const [],
  }) {
    return hoursBetween(start, end) * multiplierFor(start, holidays: holidays);
  }

  static bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
