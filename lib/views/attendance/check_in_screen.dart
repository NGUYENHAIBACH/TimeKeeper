import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/core/utils/date_utils.dart';
import 'package:timekeeper/core/widgets/app_button.dart';
import 'package:timekeeper/core/widgets/error_view.dart';
import 'package:timekeeper/core/widgets/loading_view.dart';
import 'package:timekeeper/viewmodels/attendance/action_result.dart';
import 'package:timekeeper/viewmodels/attendance/check_in_viewmodel.dart';
import 'package:timekeeper/views/attendance/widgets/status_style.dart';

/// Screen 1 (TV2): Check-in / Check-out bằng GPS + vân tay.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Lấy vị trí ngay khi mở màn, sau khi dữ liệu đã tải xong.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(checkInViewModelProvider.future);
      if (mounted) {
        ref.read(checkInViewModelProvider.notifier).refreshLocation();
      }
    });
  }

  void _showResult(ActionResult r) {
    if (!mounted) return;
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(r.message),
      backgroundColor: r.success ? null : scheme.error,
    ));
  }

  /// Khi người dùng ở ngoài vòng, thu phóng để thấy cả văn phòng và người dùng.
  void _fitMap(CheckInState s) {
    final office = s.office;
    final me = s.position;
    if (office == null || me == null) return;
    final officePoint = LatLng(office.latitude, office.longitude);
    try {
      if (s.isInsideOffice) {
        _mapController.move(officePoint, 17);
      } else {
        _mapController.fitCamera(CameraFit.coordinates(
          coordinates: [officePoint, LatLng(me.latitude, me.longitude)],
          padding: const EdgeInsets.all(40),
          maxZoom: 17,
        ));
      }
    } catch (_) {
      // Bản đồ chưa vẽ xong lần đầu, bỏ qua.
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkInViewModelProvider, (prev, next) {
      final p = prev?.value?.position;
      final n = next.value?.position;
      final officeMoved = prev?.value?.office?.latitude != next.value?.office?.latitude ||
          prev?.value?.office?.longitude != next.value?.office?.longitude;
      if (n != null &&
          (officeMoved || p?.latitude != n.latitude || p?.longitude != n.longitude)) {
        _fitMap(next.requireValue);
      }
    });
    final async = ref.watch(checkInViewModelProvider);
    final vm = ref.read(checkInViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chấm công'),
        actions: [
          IconButton(
            tooltip: 'Lịch công',
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push(AppRoutes.attendanceCalendar),
          ),
          if (kDebugMode && async.hasValue)
            IconButton(
              tooltip: 'Đặt văn phòng tại vị trí hiện tại (debug)',
              icon: const Icon(Icons.edit_location_alt),
              onPressed: () async => _showResult(await vm.moveOfficeHere()),
            ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingView(message: 'Đang tải dữ liệu chấm công'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(checkInViewModelProvider),
        ),
        data: (s) => RefreshIndicator(
          onRefresh: vm.refreshLocation,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ClockHeader(state: s),
              const SizedBox(height: 16),
              _OfficeMap(state: s, controller: _mapController),
              const SizedBox(height: 12),
              _LocationCard(state: s, onRefresh: vm.refreshLocation),
              const SizedBox(height: 12),
              _TodayCard(state: s),
              const SizedBox(height: 24),
              _PunchButton(
                state: s,
                onPressed: () async {
                  final r = s.canCheckIn ? await vm.checkIn() : await vm.checkOut();
                  _showResult(r);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClockHeader extends StatelessWidget {
  const _ClockHeader({required this.state});
  final CheckInState state;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppDate.weekdayName(now)}, ${AppDate.display(now)}',
                  style: theme.textTheme.titleMedium),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (_, _) => Text(
                  AppDate.time(DateTime.now()),
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        StatusChip(state.todayStatus),
      ],
    );
  }
}

class _OfficeMap extends StatelessWidget {
  const _OfficeMap({required this.state, required this.controller});
  final CheckInState state;
  final MapController controller;

  @override
  Widget build(BuildContext context) {
    final office = state.office;
    if (office == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Chưa cấu hình văn phòng.'),
        ),
      );
    }
    final officePoint = LatLng(office.latitude, office.longitude);
    final me = state.position;
    final inside = state.isInsideOffice;
    final scheme = Theme.of(context).colorScheme;
    final ringColor = inside ? Colors.green : scheme.primary;

    return ClipRRect(
      // Cùng độ bo với Card trong theme chung.
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          mapController: controller,
          options: MapOptions(initialCenter: officePoint, initialZoom: 17),
          children: [
            // Dùng server OSM Đức vì một số mạng ở VN chặn tile.openstreetmap.org.
            // (CARTO giờ cần API key.)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.prm393.timekeeper',
            ),
            CircleLayer(circles: [
              CircleMarker(
                point: officePoint,
                radius: office.radiusMeters.toDouble(),
                useRadiusInMeter: true,
                color: ringColor.withValues(alpha: 0.2),
                borderColor: ringColor,
                borderStrokeWidth: 2,
              ),
            ]),
            MarkerLayer(markers: [
              Marker(
                point: officePoint,
                child: Icon(Icons.business, color: scheme.primary, size: 32),
              ),
              if (me != null)
                Marker(
                  point: LatLng(me.latitude, me.longitude),
                  child: Icon(Icons.my_location, color: scheme.error, size: 28),
                ),
            ]),
            const SimpleAttributionWidget(
              source: Text('OpenStreetMap contributors'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.state, required this.onRefresh});
  final CheckInState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (state.isLocating) {
      content = const Row(children: [
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        SizedBox(width: 12),
        Text('Đang lấy vị trí…'),
      ]);
    } else if (state.locationError != null) {
      content = Text(state.locationError!,
          style: TextStyle(color: Theme.of(context).colorScheme.error));
    } else if (state.distanceMeters == null) {
      content = const Text('Chưa có vị trí. Kéo xuống hoặc bấm làm mới.');
    } else {
      final inside = state.isInsideOffice;
      content = Row(children: [
        Icon(inside ? Icons.verified : Icons.wrong_location,
            color: inside ? Colors.green : Theme.of(context).colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            inside
                ? 'Trong phạm vi văn phòng (${state.distanceMeters!.round()} m)'
                : 'Ngoài phạm vi: cách ${state.distanceMeters!.round()} m '
                    '(cho phép ${state.office!.radiusMeters.round()} m)',
          ),
        ),
      ]);
    }

    return Card(
      child: ListTile(
        title: Text(state.office?.name ?? 'Văn phòng'),
        subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: content),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: state.isLocating ? null : onRefresh,
        ),
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.state});
  final CheckInState state;

  @override
  Widget build(BuildContext context) {
    final r = state.today;
    final worked = r?.workedDuration;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TimeColumn(label: 'Giờ vào', value: AppDate.time(r?.checkInAt)),
            _TimeColumn(label: 'Giờ ra', value: AppDate.time(r?.checkOutAt)),
            _TimeColumn(
              label: 'Tổng giờ',
              value: worked == null ? '--' : AppDate.duration(worked),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 4),
      Text(value, style: Theme.of(context).textTheme.titleLarge),
    ]);
  }
}

class _PunchButton extends StatelessWidget {
  const _PunchButton({required this.state, required this.onPressed});
  final CheckInState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (state.isDone) {
      return const Center(
        child: Text('Bạn đã hoàn thành chấm công hôm nay 🎉'),
      );
    }
    final isIn = state.canCheckIn;
    // Nút chung của nhóm: check-in là nút đặc, check-out là nút viền.
    return AppButton(
      label: isIn ? 'Check-in' : 'Check-out',
      icon: Icons.fingerprint,
      outlined: !isIn,
      loading: state.isSubmitting,
      onPressed: onPressed,
    );
  }
}
