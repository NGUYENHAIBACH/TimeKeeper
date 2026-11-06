import 'package:freezed_annotation/freezed_annotation.dart';

part 'office_location.freezed.dart';

/// Văn phòng để chấm công (geofence). Map với bảng `office_locations`.
@freezed
abstract class OfficeLocation with _$OfficeLocation {
  const OfficeLocation._();

  const factory OfficeLocation({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,

    /// Bán kính cho phép chấm công (mét).
    @Default(100) int radiusMeters,
    @Default(true) bool isActive,
  }) = _OfficeLocation;

  /// Đọc một dòng từ Supabase hoặc SQLite.
  factory OfficeLocation.fromMap(Map<String, dynamic> map) => OfficeLocation(
        id: map['id'] as String,
        name: map['name'] as String,
        address: map['address'] as String?,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        radiusMeters: (map['radius_meters'] as num?)?.toInt() ?? 100,
        isActive: _bool(map['is_active'], true),
      );

  /// Dòng để ghi lên Supabase.
  Map<String, dynamic> toRemote() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'radius_meters': radiusMeters,
        'is_active': isActive,
      };

  /// Dòng để ghi vào SQLite (bool -> 0/1).
  Map<String, dynamic> toLocal() => {...toRemote(), 'is_active': isActive ? 1 : 0};
}

bool _bool(Object? v, bool fallback) =>
    v == null ? fallback : (v is bool ? v : v == 1);
