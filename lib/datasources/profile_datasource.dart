import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:timekeeper/core/providers/core_providers.dart';
import 'package:timekeeper/models/profile.dart';

part 'profile_datasource.g.dart';

/// Lớp duy nhất gọi bảng `profiles` trên Supabase.
/// Chỉ Repository mới dùng lớp này.
class ProfileDataSource {
  ProfileDataSource(this._client);

  final SupabaseClient _client;
  static const _table = 'profiles';

  /// Tìm hồ sơ theo uid Firebase. Trả null nếu chưa có.
  Future<Profile?> getByFirebaseUid(String uid) async {
    final row = await _client
        .from(_table)
        .select()
        .eq('firebase_uid', uid)
        .maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }

  /// Tìm hồ sơ theo id Supabase (uuid).
  Future<Profile?> getById(String id) async {
    final row = await _client.from(_table).select().eq('id', id).maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }

  /// Tạo mới hoặc cập nhật theo `firebase_uid` (cột unique).
  /// Chỉ ghi các cột được truyền, không đụng role / department / shift
  /// do admin quản lý.
  Future<Profile> upsert({
    required String firebaseUid,
    required String email,
    String? fullName,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{
      'firebase_uid': firebaseUid,
      'email': email,
      'full_name': ?fullName,
      'avatar_url': ?avatarUrl,
    };
    final row = await _client
        .from(_table)
        .upsert(data, onConflict: 'firebase_uid')
        .select()
        .single();
    return Profile.fromJson(row);
  }

  /// Cập nhật các trường người dùng tự sửa được.
  Future<Profile> update(
    String id, {
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{
      'full_name': ?fullName,
      'phone': ?phone,
      'avatar_url': ?avatarUrl,
    };
    final row =
        await _client.from(_table).update(data).eq('id', id).select().single();
    return Profile.fromJson(row);
  }

  /// Upload ảnh đại diện lên bucket `avatars`, trả về URL public.
  Future<String> uploadAvatar(String profileId, List<int> bytes, String ext) async {
    final path = '$profileId/avatar.$ext';
    await _client.storage.from('avatars').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );
    // Thêm timestamp để tránh cache ảnh cũ.
    final url = _client.storage.from('avatars').getPublicUrl(path);
    return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// Provider ProfileDataSource (keepAlive).
@Riverpod(keepAlive: true)
ProfileDataSource profileDataSource(Ref ref) {
  return ProfileDataSource(ref.watch(supabaseProvider));
}
