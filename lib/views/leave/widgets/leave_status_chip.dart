import 'package:flutter/material.dart';

import 'package:timekeeper/models/leave_request.dart';

/// Nhãn màu theo trạng thái đơn nghỉ.
class LeaveStatusChip extends StatelessWidget {
  const LeaveStatusChip({super.key, required this.status});

  final LeaveStatus status;

  /// Màu đại diện cho từng trạng thái (dùng chung với lịch team).
  static Color colorOf(LeaveStatus status, ColorScheme scheme) => switch (status) {
        LeaveStatus.pending => Colors.orange,
        LeaveStatus.approved => Colors.green,
        LeaveStatus.rejected => scheme.error,
        LeaveStatus.cancelled => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final color = colorOf(status, Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
