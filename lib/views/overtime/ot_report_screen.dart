import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/services/overtime/ot_report_export_service.dart';
import 'package:timekeeper/viewmodels/overtime/ot_list_viewmodel.dart';
import 'package:timekeeper/viewmodels/overtime/ot_report_summary.dart';

class OtReportScreen extends ConsumerStatefulWidget {
  const OtReportScreen({super.key});

  @override
  ConsumerState<OtReportScreen> createState() => _OtReportScreenState();
}

class _OtReportScreenState extends ConsumerState<OtReportScreen> {
  late int _selectedYear;
  final _hourlyRateController = TextEditingController();
  final _exportService = const OtReportExportService();
  double _hourlyRate = 0;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _exportReport(
    OtReportSummary summary,
    OtReportExportFormat format,
  ) async {
    setState(() => _isExporting = true);
    try {
      final uri = await _exportService.export(
        summary: summary,
        hourlyRate: _hourlyRate,
        format: format,
      );
      if (!mounted || uri == null) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đã xuất báo cáo: $uri')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể xuất báo cáo: ${ErrorView.friendlyMessage(error)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(otListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo tăng ca'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () =>
                ref.read(otListViewModelProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const LoadingView(message: 'Đang tổng hợp dữ liệu OT'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(otListViewModelProvider),
        ),
        data: (state) {
          final years = <int>{
            DateTime.now().year,
            for (final request in state.requests) request.otDate.year,
          }.toList()..sort((a, b) => b.compareTo(a));
          final summary = OtReportSummary.fromRequests(
            state.requests,
            year: _selectedYear,
          );

          return RefreshIndicator(
            onRefresh: ref.read(otListViewModelProvider.notifier).refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<OtReportExportFormat>(
                    enabled: !_isExporting,
                    tooltip: 'Xuất báo cáo',
                    onSelected: (format) => _exportReport(summary, format),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: OtReportExportFormat.pdf,
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf_outlined),
                          title: Text('Xuất PDF'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: OtReportExportFormat.excel,
                        child: ListTile(
                          leading: Icon(Icons.table_view_outlined),
                          title: Text('Xuất Excel'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _isExporting
                            ? Theme.of(context).colorScheme.surfaceContainerHigh
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isExporting)
                              const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                Icons.download_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              _isExporting ? 'Đang xuất...' : 'Xuất báo cáo',
                              style: TextStyle(
                                color: _isExporting
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'Năm báo cáo',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: [
                    for (final year in years)
                      DropdownMenuItem(value: year, child: Text('$year')),
                  ],
                  onChanged: (year) {
                    if (year != null) setState(() => _selectedYear = year);
                  },
                ),
                const SizedBox(height: 16),
                _SummaryGrid(summary: summary),
                const SizedBox(height: 16),
                _MonthlyChart(summary: summary),
                const SizedBox(height: 16),
                _PayEstimateCard(
                  summary: summary,
                  controller: _hourlyRateController,
                  hourlyRate: _hourlyRate,
                  onChanged: (value) {
                    final normalized = value.replaceAll(RegExp(r'[^0-9]'), '');
                    setState(() {
                      _hourlyRate = double.tryParse(normalized) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Báo cáo và ước tính lương chỉ tính các đơn đã được duyệt.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final OtReportSummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _MetricCard(
          icon: Icons.task_alt,
          label: 'Đơn đã duyệt',
          value: '${summary.approvedCount}',
        ),
        _MetricCard(
          icon: Icons.hourglass_top,
          label: 'Đơn chờ duyệt',
          value: '${summary.pendingCount}',
        ),
        _MetricCard(
          icon: Icons.schedule,
          label: 'Giờ OT thực tế',
          value: '${_number(summary.actualHours)} h',
        ),
        _MetricCard(
          icon: Icons.payments_outlined,
          label: 'Giờ quy đổi',
          value: '${_number(summary.paidHours)} h',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.summary});

  final OtReportSummary summary;

  @override
  Widget build(BuildContext context) {
    final highest = summary.monthlyHours.fold<double>(0, math.max);
    final interval = _chartInterval(highest);
    final maxY = math.max(
      interval * 4,
      (highest / interval).ceilToDouble() * interval,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giờ OT đã duyệt theo tháng',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          'Tháng ${group.x + 1}\n${_number(rod.toY)} giờ',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: interval,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${value.toInt() + 1}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                  barGroups: [
                    for (
                      var index = 0;
                      index < summary.monthlyHours.length;
                      index++
                    )
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: summary.monthlyHours[index],
                            width: 12,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayEstimateCard extends StatelessWidget {
  const _PayEstimateCard({
    required this.summary,
    required this.controller,
    required this.hourlyRate,
    required this.onChanged,
  });

  final OtReportSummary summary;
  final TextEditingController controller;
  final double hourlyRate;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ước tính tiền tăng ca',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Lương theo giờ',
                hintText: 'Ví dụ: 50000',
                prefixIcon: Icon(Icons.attach_money),
                suffixText: 'đ/giờ',
              ),
              onChanged: onChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_number(summary.paidHours)} giờ quy đổi × '
                    '${currency.format(hourlyRate)}',
                  ),
                ),
                Text(
                  currency.format(summary.estimatePay(hourlyRate)),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _number(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2);

double _chartInterval(double highest) {
  if (highest <= 4) return 1;

  final roughInterval = highest / 4;
  final magnitude = math
      .pow(10, (math.log(roughInterval) / math.ln10).floor())
      .toDouble();
  final normalized = roughInterval / magnitude;

  final niceInterval = switch (normalized) {
    <= 1.5 => 1,
    <= 3 => 2,
    <= 7 => 5,
    _ => 10,
  };
  return niceInterval * magnitude;
}
