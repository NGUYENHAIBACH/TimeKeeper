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
