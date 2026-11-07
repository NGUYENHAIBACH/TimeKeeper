import 'package:flutter/material.dart';

import 'package:timekeeper/core/utils/attendance_status.dart';

/// Màu và icon cho từng trạng thái ngày công.
extension AttendanceStatusStyle on AttendanceStatus {
  Color get color => switch (this) {
        AttendanceStatus.onTime => const Color(0xFF2E7D32),
        AttendanceStatus.late => const Color(0xFFEF6C00),
        AttendanceStatus.overtime => const Color(0xFF1565C0),
        AttendanceStatus.missingCheckOut => const Color(0xFF8E24AA),
        AttendanceStatus.absent => const Color(0xFFC62828),
        AttendanceStatus.inProgress => const Color(0xFF00897B),
        AttendanceStatus.dayOff => const Color(0xFF9E9E9E),
        AttendanceStatus.upcoming => const Color(0xFF607D8B),
      };

  IconData get icon => switch (this) {
        AttendanceStatus.onTime => Icons.check_circle,
        AttendanceStatus.late => Icons.schedule,
        AttendanceStatus.overtime => Icons.more_time,
        AttendanceStatus.missingCheckOut => Icons.logout,
        AttendanceStatus.absent => Icons.cancel,
        AttendanceStatus.inProgress => Icons.work_history,
        AttendanceStatus.dayOff => Icons.weekend,
        AttendanceStatus.upcoming => Icons.event,
      };

  /// Các trạng thái hiện trong chú thích và tổng kết.
  static const legend = [
    AttendanceStatus.onTime,
    AttendanceStatus.late,
    AttendanceStatus.overtime,
    AttendanceStatus.missingCheckOut,
    AttendanceStatus.absent,
  ];
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(status.icon, color: Colors.white, size: 18),
      label: Text(status.label, style: const TextStyle(color: Colors.white)),
      backgroundColor: status.color,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
