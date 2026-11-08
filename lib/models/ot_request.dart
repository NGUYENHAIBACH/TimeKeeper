class OtRequest {
  const OtRequest({
    required this.id,
    required this.employeeId,
    required this.otDate,
    required this.startTime,
    required this.endTime,
    required this.hours,
    required this.otType,
    required this.multiplier,
    required this.paidHours,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.approvedBy,
    this.approvedAt,
    this.rejectReason,
  });

  final String id;
  final String employeeId;
  final DateTime otDate;
  final String startTime;
  final String endTime;
  final double hours;
  final String otType;
  final double multiplier;
  final double paidHours;
  final String reason;
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectReason;
  final DateTime createdAt;

  String get timeRange => '${_shortTime(startTime)} - ${_shortTime(endTime)}';

  factory OtRequest.fromJson(Map<String, dynamic> json) {
    return OtRequest(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      otDate: DateTime.parse(json['ot_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      hours: (json['hours'] as num).toDouble(),
      otType: json['ot_type'] as String,
      multiplier: (json['multiplier'] as num).toDouble(),
      paidHours: (json['paid_hours'] as num).toDouble(),
      reason: json['reason'] as String,
      status: json['status'] as String,
      approvedBy: json['approved_by'] as String?,
      approvedAt: _optionalDate(json['approved_at']),
      rejectReason: json['reject_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  static DateTime? _optionalDate(Object? value) {
    return value == null ? null : DateTime.parse(value as String).toLocal();
  }

  static String _shortTime(String value) {
    final parts = value.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : value;
  }
}
