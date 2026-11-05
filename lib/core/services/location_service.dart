import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Service GPS dùng chung. keepAlive để nhớ lựa chọn LocationManager.
@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => LocationService();

/// Lỗi lấy vị trí, có sẵn câu thông báo tiếng Việt.
class LocationException implements Exception {
  const LocationException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Một tọa độ GPS.
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude, {this.accuracy});
  final double latitude;
  final double longitude;

  /// Sai số GPS (mét).
  final double? accuracy;
}

/// Bọc geolocator: xin quyền, lấy vị trí hiện tại.
class LocationService {
  LocationService();

  /// true sau khi người dùng từ chối dịch vụ vị trí của Google Play.
  bool _useLocationManager = false;

  Future<GeoPoint> _read({required bool useLocationManager}) async {
    final settings = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            forceLocationManager: useLocationManager,
            timeLimit: const Duration(seconds: 15),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          );
    final pos = await Geolocator.getCurrentPosition(locationSettings: settings);
    return GeoPoint(pos.latitude, pos.longitude, accuracy: pos.accuracy);
  }

  /// Xin quyền nếu cần rồi lấy vị trí hiện tại. Lỗi ném [LocationException]
  /// với câu tiếng Việt.
  Future<GeoPoint> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException('GPS đang tắt. Hãy bật định vị rồi thử lại.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException('Bạn chưa cho phép app dùng vị trí.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Quyền vị trí bị chặn. Vào Cài đặt > Ứng dụng để bật lại.',
      );
    }

    try {
      return await _read(useLocationManager: _useLocationManager);
    } on LocationServiceDisabledException {
      // Người dùng từ chối hộp thoại "Location Accuracy" của Google nhưng
      // định vị máy vẫn bật → dùng LocationManager gốc của Android, và nhớ
      // lựa chọn này để không hỏi lại mỗi lần.
      if (defaultTargetPlatform == TargetPlatform.android &&
          !_useLocationManager &&
          await Geolocator.isLocationServiceEnabled()) {
        _useLocationManager = true;
        try {
          return await _read(useLocationManager: true);
        } on TimeoutException {
          throw const LocationException(
            'Không bắt được tín hiệu GPS. Hãy ra chỗ thoáng và thử lại.',
          );
        }
      }
      throw const LocationException('GPS đang tắt. Hãy bật định vị rồi thử lại.');
    } on PermissionDeniedException {
      throw const LocationException('Bạn chưa cho phép app dùng vị trí.');
    } on TimeoutException {
      // Dự phòng: dùng vị trí gần nhất nếu còn mới (dưới 2 phút).
      final last = await Geolocator.getLastKnownPosition();
      if (last != null &&
          DateTime.now().difference(last.timestamp) < const Duration(minutes: 2)) {
        return GeoPoint(last.latitude, last.longitude, accuracy: last.accuracy);
      }
      throw const LocationException(
        'Không bắt được tín hiệu GPS. Hãy ra chỗ thoáng và thử lại.',
      );
    }
  }

  /// Chặn vị trí giả (app fake GPS) trên Android.
  Future<bool> isMocked() async {
    final pos = await Geolocator.getLastKnownPosition();
    return pos?.isMocked ?? false;
  }

  /// Mở trang cài đặt quyền của app.
  Future<void> openSettings() => Geolocator.openAppSettings();
}
