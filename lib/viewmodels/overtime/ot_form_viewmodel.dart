import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/core/utils/ot_calculator.dart';
import 'package:timekeeper/repositories/ot_repository.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

part 'ot_form_viewmodel.g.dart';

class OtFormState {
  const OtFormState({
    this.date,
    this.startTime,
    this.endTime,
    this.reason = '',
    this.holidays = const [],
    this.isSubmitting = false,
  });

  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String reason;
  final List<DateTime> holidays;
  final bool isSubmitting;
  double? get hours {
    if (date == null || startTime == null || endTime == null) {
      return null;
    }

    final start = DateTime(
      date!.year,
      date!.month,
      date!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final end = DateTime(
      date!.year,
      date!.month,
      date!.day,
      endTime!.hour,
      endTime!.minute,
    );

    if (!end.isAfter(start)) {
      return null;
    }

    return OtCalculator.hoursBetween(start, end);
  }

  double? get multiplier {
    if (date == null) return null;

    return OtCalculator.multiplierFor(date!, holidays: holidays);
  }

  String? get otTypeLabel {
    final value = multiplier;

    if (value == OtMultiplier.holiday) {
      return 'Ngày lễ';
    }

    if (value == OtMultiplier.weekend) {
      return 'Cuối tuần';
    }

    if (value == OtMultiplier.weekday) {
      return 'Ngày thường';
    }

    return null;
  }

  String? get otType {
    final value = multiplier;

    if (value == OtMultiplier.holiday) {
      return 'holiday';
    }

    if (value == OtMultiplier.weekend) {
      return 'weekend';
    }

    if (value == OtMultiplier.weekday) {
      return 'weekday';
    }

    return null;
  }

  OtFormState copyWith({
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
    List<DateTime>? holidays,
    bool? isSubmitting,
  }) {
    return OtFormState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      holidays: holidays ?? this.holidays,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

@riverpod
class OtFormViewModel extends _$OtFormViewModel {
  @override
  Future<OtFormState> build() async {
    final holidays = await ref.watch(otRepositoryProvider).getHolidays();

    return OtFormState(holidays: holidays);
  }

  void setDate(DateTime value) {
    _update((current) => current.copyWith(date: value));
  }

  void setStartTime(TimeOfDay value) {
    _update((current) => current.copyWith(startTime: value));
  }

  void setEndTime(TimeOfDay value) {
    _update((current) => current.copyWith(endTime: value));
  }

  void setReason(String value) {
    _update((current) => current.copyWith(reason: value));
  }

  Future<void> submit() async {
    final current = state.value;

    if (current == null ||
        current.date == null ||
        current.startTime == null ||
        current.endTime == null ||
        current.hours == null ||
        current.multiplier == null ||
        current.otType == null ||
        current.reason.trim().isEmpty) {
      throw StateError('Thông tin đơn OT chưa đầy đủ');
    }

    final repository = ref.read(otRepositoryProvider);

    final start = DateTime(
      current.date!.year,
      current.date!.month,
      current.date!.day,
      current.startTime!.hour,
      current.startTime!.minute,
    );

    final end = DateTime(
      current.date!.year,
      current.date!.month,
      current.date!.day,
      current.endTime!.hour,
      current.endTime!.minute,
    );

    _update((form) => form.copyWith(isSubmitting: true));

    try {
      final profile = await ref.read(profileViewModelProvider.future);

      if (profile == null) {
        throw StateError('Không tìm thấy hồ sơ người dùng');
      }

      await repository.createRequest(
        employeeId: profile.id,
        start: start,
        end: end,
        hours: current.hours!,
        otType: current.otType!,
        multiplier: current.multiplier!,
        reason: current.reason,
      );
    } finally {
      if (ref.mounted) {
        _update((form) => form.copyWith(isSubmitting: false));
      }
    }
  }

  void _update(OtFormState Function(OtFormState current) update) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(update(current));
  }
}
