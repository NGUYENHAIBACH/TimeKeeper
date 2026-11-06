import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/attendance_status.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/viewmodels/attendance/attendance_calendar_viewmodel.dart';
import 'package:timekeeper/views/attendance/widgets/status_style.dart';

/// Screen 2 (TV2): Lịch công tháng, tô màu theo trạng thái.
class AttendanceCalendarScreen extends ConsumerWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(attendanceCalendarViewModelProvider);
    final month = ref.watch(selectedMonthProvider);
    final filter = ref.watch(calendarFilterProvider);
    final vm = ref.read(attendanceCalendarViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch công'),
        actions: [
          IconButton(
            tooltip: 'Về tháng này',
            icon: const Icon(Icons.today),
            onPressed: () => vm.changeMonth(DateTime.now()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(attendanceCalendarViewModelProvider.future),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            if (async.isLoading) const LinearProgressIndicator(),
            TableCalendar<void>(
              locale: 'vi_VN',
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime(DateTime.now().year + 1, 12, 31),
              focusedDay: month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: 'Tháng'},
              headerStyle: const HeaderStyle(titleCentered: true),
              onPageChanged: vm.changeMonth,
              onDaySelected: (day, _) => _openDay(context, day),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (_, day, _) =>
                    _dayCell(context, async.value, filter, day, isToday: false),
                todayBuilder: (_, day, _) =>
                    _dayCell(context, async.value, filter, day, isToday: true),
              ),
            ),
            const Divider(),
            async.when(
              skipLoadingOnReload: true,
              loading: () => const LoadingView(message: 'Đang tải lịch công'),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(attendanceCalendarViewModelProvider),
              ),
              data: (s) => _Summary(state: s, filter: filter, onTap: vm.toggleFilter),
            ),
          ],
        ),
      ),
    );
  }

  void _openDay(BuildContext context, DateTime day) {
    context.push(AppRoutes.attendanceDayOf(day));
  }

  Widget _dayCell(
    BuildContext context,
    CalendarState? s,
    AttendanceStatus? filter,
    DateTime day, {
    required bool isToday,
  }) {
    final status = s?.statusOf(day) ?? AttendanceStatus.upcoming;
    final dimmed = filter != null && filter != status;
    final showColor = status != AttendanceStatus.upcoming &&
        status != AttendanceStatus.dayOff &&
        !dimmed;
    final pending = s?.hasPendingCorrection(day) ?? false;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: showColor ? status.color.withValues(alpha: 0.85) : null,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: showColor
                  ? Colors.white
                  : (AppDate.isWeekend(day) ? Colors.grey : null),
              fontWeight: isToday ? FontWeight.bold : null,
            ),
          ),
          if (pending)
            const Positioned(
              right: -10,
              top: -8,
              child: Icon(Icons.hourglass_top, size: 12, color: Colors.amber),
            ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state, required this.filter, required this.onTap});
  final CalendarState state;
  final AttendanceStatus? filter;
  final void Function(AttendanceStatus) onTap;

  @override
  Widget build(BuildContext context) {
    final counts = state.counts;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tổng kết tháng ${state.month.month}/${state.month.year}',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Bấm vào một trạng thái để chỉ tô màu ngày đó.',
              style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final st in AttendanceStatusStyle.legend)
                FilterChip(
                  selected: filter == st,
                  onSelected: (_) => onTap(st),
                  avatar: CircleAvatar(backgroundColor: st.color, radius: 6),
                  label: Text('${st.label}: ${counts[st] ?? 0}'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(label: 'Tổng giờ làm', value: AppDate.duration(state.totalWorked)),
                  _Stat(label: 'Ngày có công', value: '${state.records.length}'),
                  _Stat(label: 'Phút đi muộn', value: '${state.totalLateMinutes}'),
                ],
              ),
            ),
          ),
          if (state.pendingCorrectionDays.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(children: [
                const Icon(Icons.hourglass_top, size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Text('${state.pendingCorrectionDays.length} đơn bù công đang chờ duyệt'),
              ]),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
