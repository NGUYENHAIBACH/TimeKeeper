import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:timekeeper/core/utils/leave_calculator.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/models/leave_request.dart';
import 'package:timekeeper/viewmodels/leave/leave_team_calendar_viewmodel.dart';
import 'package:timekeeper/views/leave/widgets/leave_status_chip.dart';

/// Màn Lịch nghỉ của team (TV4): calendar tháng đánh dấu ngày có đồng nghiệp
/// cùng phòng ban nghỉ; chọn ngày để xem ai nghỉ.
class LeaveTeamCalendarScreen extends ConsumerStatefulWidget {
  const LeaveTeamCalendarScreen({super.key});

  @override
  ConsumerState<LeaveTeamCalendarScreen> createState() => _LeaveTeamCalendarScreenState();
}

class _LeaveTeamCalendarScreenState extends ConsumerState<LeaveTeamCalendarScreen> {
  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  DateTime _focused = DateTime.now();
  DateTime _selected = LeaveCalculator.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(leaveTeamCalendarViewModelProvider);
    final data = async.value;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch nghỉ của team'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(leaveTeamCalendarViewModelProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (async.isLoading) const LinearProgressIndicator(),
          TableCalendar<LeaveRequest>(
            key: const Key('team_calendar'),
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 1, 12, 31),
            focusedDay: _focused,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {CalendarFormat.month: 'Tháng'},
            selectedDayPredicate: (d) => isSameDay(d, _selected),
            eventLoader: (d) => data?.leavesOn(d) ?? const [],
            holidayPredicate: (d) =>
                data?.holidays.containsKey(LeaveCalculator.dateOnly(d)) ?? false,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (d, _) => 'Tháng ${d.month}/${d.year}',
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (d, _) => _weekdays[d.weekday - 1],
            ),
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(color: scheme.tertiary, shape: BoxShape.circle),
              holidayTextStyle: TextStyle(color: scheme.error),
              holidayDecoration: const BoxDecoration(shape: BoxShape.circle),
              weekendTextStyle: TextStyle(color: scheme.outline),
            ),
            onDaySelected: (selected, focused) => setState(() {
              _selected = LeaveCalculator.dateOnly(selected);
              _focused = focused;
            }),
            onPageChanged: (focused) {
              _focused = focused;
              ref.read(leaveTeamCalendarViewModelProvider.notifier).changeMonth(focused);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: async.when(
              skipLoadingOnRefresh: false,
              loading: () => const SizedBox.shrink(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.read(leaveTeamCalendarViewModelProvider.notifier).refresh(),
              ),
              data: (data) => _DayDetail(data: data, day: _selected),
            ),
          ),
        ],
      ),
    );
  }
}

/// Danh sách người nghỉ trong ngày đang chọn + tóm tắt tháng.
class _DayDetail extends StatelessWidget {
  const _DayDetail({required this.data, required this.day});

  final TeamLeaveData data;
  final DateTime day;

  static final _fmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final holiday = data.holidays[LeaveCalculator.dateOnly(day)];
    final leaves = data.leavesOn(day);
    final busiest = data.busiestDay;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Tháng này: ${data.peopleOnLeave} người có lịch nghỉ'
          '${busiest == null ? '' : ' · đông nhất ${_fmt.format(busiest.day)} (${busiest.count} người)'}',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Text('Ngày ${_fmt.format(day)}', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        if (holiday != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.celebration_outlined),
              title: Text('Ngày lễ: $holiday'),
            ),
          )
        else if (LeaveCalculator.isWeekend(day))
          const ListTile(leading: Icon(Icons.weekend_outlined), title: Text('Cuối tuần'))
        else if (leaves.isEmpty)
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Không ai nghỉ, team đi làm đủ'),
          )
        else
          for (final r in leaves)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text((r.employeeName ?? '?').characters.first.toUpperCase()),
                ),
                title: Text(
                  r.employeeId == data.myEmployeeId
                      ? '${r.employeeName ?? 'Tôi'} (bạn)'
                      : (r.employeeName ?? 'Đồng nghiệp'),
                ),
                subtitle: Text(
                  '${r.leaveType?.name ?? 'Nghỉ phép'}'
                  '${r.halfDay == HalfDay.none ? '' : ' · ${r.halfDay.label}'}'
                  '\n${_fmt.format(r.startDate)} - ${_fmt.format(r.endDate)}',
                ),
                isThreeLine: true,
                trailing: LeaveStatusChip(status: r.status),
              ),
            ),
      ],
    );
  }
}
