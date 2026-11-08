import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/core/utils/ot_calculator.dart';
import 'package:timekeeper/repositories/ot_repository.dart';

part 'ot_form_viewmodel.g.dart';

class OtFormState {
  const OtFormState({
    this.date,
    this.startTime,
    this.endTime,
    this.reason = '',
    this.holidays = const [],
  });

  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String reason;
  final List<DateTime> holidays;
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

  OtFormState copyWith({
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
    List<DateTime>? holidays,
  }) {
    return OtFormState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      holidays: holidays ?? this.holidays,
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

  void _update(OtFormState Function(OtFormState current) update) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(update(current));
  }
}
