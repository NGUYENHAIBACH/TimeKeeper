import 'dart:math' as math;

/// Tính khoảng cách và kiểm tra nằm trong bán kính văn phòng.
class GeoFence {
  GeoFence._();

  static const _earthRadiusMeters = 6371000.0;

  /// Khoảng cách (mét) giữa 2 tọa độ, công thức Haversine.
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    double rad(double deg) => deg * math.pi / 180;
    final dLat = rad(lat2 - lat1);
    final dLng = rad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(rad(lat1)) *
            math.cos(rad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * _earthRadiusMeters * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  /// Khoảng cách [distanceMeters] có nằm trong bán kính [radiusMeters] không.
  static bool isInside({
    required double distanceMeters,
    required double radiusMeters,
  }) =>
      distanceMeters <= radiusMeters;
}
