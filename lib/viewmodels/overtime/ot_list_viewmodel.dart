import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timekeeper/models/ot_request.dart';
import 'package:timekeeper/repositories/ot_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

const otStatuses = ['all', 'pending', 'approved', 'rejected', 'cancelled'];

class OtListState {
  const OtListState({
    required this.employeeId,
    required this.requests,
    required this.selectedMonth,
    this.selectedStatus = 'all',
  });

  final String employeeId;
  final List<OtRequest> requests;
  final DateTime? selectedMonth;
  final String selectedStatus;

  List<OtRequest> get filteredRequests {
    return requests.where((request) {
      final month = selectedMonth;
      final matchesMonth =
          month == null ||
          (request.otDate.year == month.year &&
              request.otDate.month == month.month);
      final matchesStatus =
          selectedStatus == 'all' || request.status == selectedStatus;
      return matchesMonth && matchesStatus;
    }).toList();
  }

  OtListState copyWith({
    List<OtRequest>? requests,
    DateTime? selectedMonth,
    bool clearMonth = false,
    String? selectedStatus,
  }) {
    return OtListState(
      employeeId: employeeId,
      requests: requests ?? this.requests,
      selectedMonth: clearMonth ? null : (selectedMonth ?? this.selectedMonth),
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}

class OtListViewModel extends AsyncNotifier<OtListState> {
  @override
  Future<OtListState> build() async {
    final profile = await ref.watch(profileViewModelProvider.future);
    if (profile == null) {
      throw StateError('Không tìm thấy hồ sơ người dùng');
    }

    final requests = await ref
        .watch(otRepositoryProvider)
        .getMyRequests(profile.id);
    final now = DateTime.now();
    return OtListState(
      employeeId: profile.id,
      requests: requests,
      selectedMonth: DateTime(now.year, now.month),
    );
  }

  void setMonth(DateTime? month) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      month == null
          ? current.copyWith(clearMonth: true)
          : current.copyWith(selectedMonth: DateTime(month.year, month.month)),
    );
  }

  void setStatus(String status) {
    final current = state.value;
    if (current == null || !otStatuses.contains(status)) return;
    state = AsyncData(current.copyWith(selectedStatus: status));
  }

  Future<void> refresh() async {
    final current = state.value;
    if (current == null) {
      ref.invalidateSelf();
      return;
    }

    final requests = await ref
        .read(otRepositoryProvider)
        .getMyRequests(current.employeeId);
    if (ref.mounted) {
      state = AsyncData(current.copyWith(requests: requests));
    }
  }
}

final otListViewModelProvider =
    AsyncNotifierProvider<OtListViewModel, OtListState>(OtListViewModel.new);
