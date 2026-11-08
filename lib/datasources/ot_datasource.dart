import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timekeeper/core/providers/core_providers.dart';

part 'ot_datasource.g.dart';

class OtDataSource {
  OtDataSource(this._client);

  final SupabaseClient _client;

  Future<List<DateTime>> getHolidays() async {
    final rows = await _client
        .from('holidays')
        .select('holiday_date')
        .order('holiday_date');

    return rows.map((row) {
      return DateTime.parse(row['holiday_date'] as String);
    }).toList();
  }

  Future<void> createRequest({
    required String employeeId,
    required DateTime start,
    required DateTime end,
    required double hours,
    required String otType,
    required double multiplier,
    required String reason,
  }) async {
    await _client.from('ot_requests').insert({
      'employee_id': employeeId,
      'ot_date': _formatDate(start),
      'start_time': _formatTime(start),
      'end_time': _formatTime(end),
      'hours': hours,
      'ot_type': otType,
      'multiplier': multiplier,
      'reason': reason.trim(),
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getRequestsByEmployee(
    String employeeId,
  ) async {
    final rows = await _client
        .from('ot_requests')
        .select()
        .eq('employee_id', employeeId)
        .order('ot_date', ascending: false)
        .order('created_at', ascending: false);

    return rows.cast<Map<String, dynamic>>();
  }

  Future<bool> cancelRequest({
    required String requestId,
    required String employeeId,
  }) async {
    final rows = await _client
        .from('ot_requests')
        .update({'status': 'cancelled'})
        .eq('id', requestId)
        .eq('employee_id', employeeId)
        .eq('status', 'pending')
        .select('id');

    return rows.isNotEmpty;
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '${value.year}-$month-$day';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }
}

@Riverpod(keepAlive: true)
OtDataSource otDataSource(Ref ref) {
  return OtDataSource(ref.watch(supabaseProvider));
}
