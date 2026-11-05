/// Tên đường dẫn của toàn app. Mọi `context.go(...)` phải dùng hằng ở đây,
/// không gõ chuỗi tay, để đổi route một chỗ là xong.
class AppRoutes {
  AppRoutes._();

  // ----- TV1: Auth & Cá nhân -----
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';

  // ----- TV2: Chấm công -----
  static const checkin = '/attendance/checkin';
  static const attendanceCalendar = '/attendance/calendar';
  static const attendanceDay = '/attendance/day'; // + ?date=yyyy-MM-dd
  static const attendanceCorrection = '/attendance/correction'; // + ?date=yyyy-MM-dd

  /// Đường dẫn chi tiết ngày công, vd `/attendance/day?date=2026-11-05`.
  static String attendanceDayOf(DateTime day) => '$attendanceDay?date=${_dateKey(day)}';

  /// Đường dẫn form đơn bù công của ngày [day].
  static String attendanceCorrectionOf(DateTime day) =>
      '$attendanceCorrection?date=${_dateKey(day)}';

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}'
      '-${d.day.toString().padLeft(2, '0')}';

  // ----- TV3: OT + Báo cáo -----
  static const otForm = '/overtime/new';
  static const otList = '/overtime';
  static const otReport = '/overtime/report';

  // ----- TV4: Nghỉ phép -----
  static const leaveForm = '/leave/new';
  static const leaveHistory = '/leave';
  static const leaveTeamCalendar = '/leave/team';

  // ----- TV5: Duyệt đơn & Thông báo -----
  static const approvalInbox = '/approval';
  static const notifications = '/notifications';
  static const teamDashboard = '/team';

  /// Các route không cần đăng nhập.
  static const publicRoutes = {splash, login, register, forgotPassword};
}
