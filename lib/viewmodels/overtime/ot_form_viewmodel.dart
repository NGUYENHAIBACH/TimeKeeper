import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ot_form_viewmodel.g.dart';

class OtFormState {
  const OtFormState({
    this.date,
    this.startTime,
    this.endTime,
    this.reason = '',
  });

  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String reason;

  OtFormState copyWith({
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? reason,
  }) {
    return OtFormState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
    );
  }
}

@riverpod
class OtFormViewModel extends _$OtFormViewModel {
  @override
  OtFormState build() => const OtFormState();

  void setDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void setStartTime(TimeOfDay value) {
    state = state.copyWith(startTime: value);
  }

  void setEndTime(TimeOfDay value) {
    state = state.copyWith(endTime: value);
  }

  void setReason(String value) {
    state = state.copyWith(reason: value);
  }
}
