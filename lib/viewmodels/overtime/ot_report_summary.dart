import 'package:timekeeper/models/ot_request.dart';

class OtReportSummary {
  const OtReportSummary({
    required this.year,
    required this.approvedCount,
    required this.pendingCount,
    required this.actualHours,
    required this.paidHours,
    required this.monthlyHours,
  });

  final int year;
  final int approvedCount;
  final int pendingCount;
  final double actualHours;
  final double paidHours;
  final List<double> monthlyHours;

  factory OtReportSummary.fromRequests(
    List<OtRequest> requests, {
    required int year,
  }) {
    final yearRequests = requests
        .where((request) => request.otDate.year == year)
        .toList();
    final approved = yearRequests
        .where((request) => request.status == 'approved')
        .toList();
    final monthlyHours = List<double>.filled(12, 0);

    for (final request in approved) {
      monthlyHours[request.otDate.month - 1] += request.hours;
    }

    return OtReportSummary(
      year: year,
      approvedCount: approved.length,
      pendingCount: yearRequests
          .where((request) => request.status == 'pending')
          .length,
      actualHours: approved.fold(0, (sum, request) => sum + request.hours),
      paidHours: approved.fold(0, (sum, request) => sum + request.paidHours),
      monthlyHours: List.unmodifiable(monthlyHours),
    );
  }

  double estimatePay(double hourlyRate) {
    if (hourlyRate <= 0) return 0;
    return paidHours * hourlyRate;
  }
}
