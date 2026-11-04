import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/datasources/profile_datasource.dart';
import 'package:timekeeper/models/profile.dart';

part 'profile_repository.g.dart';

/// Repository hồ sơ nhân viên. Nối Firebase (danh tính) với Supabase (dữ liệu).
class ProfileRepository {
  ProfileRepository(this._ds);

  final ProfileDataSource _ds;

  /// Gọi ngay sau khi đăng nhập thành công: tạo hoặc cập nhật dòng `profiles`
  /// theo `firebase_uid`. Đây là điểm nối duy nhất giữa hai hệ thống.
  Future<Profile> syncAfterLogin(User user) {
    return _ds.upsert(
      firebaseUid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName,
      avatarUrl: user.photoURL,
    );
  }

  /// Lấy hồ sơ theo uid Firebase.
  Future<Profile?> getByUid(String uid) => _ds.getByFirebaseUid(uid);

  /// Lấy hồ sơ theo id Supabase.
  Future<Profile?> getById(String id) => _ds.getById(id);

  /// Người dùng tự sửa họ tên / số điện thoại / avatar.
  Future<Profile> update(
    String id, {
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) {
    return _ds.update(id, fullName: fullName, phone: phone, avatarUrl: avatarUrl);
  }

  /// Upload avatar rồi lưu URL vào hồ sơ.
  Future<Profile> changeAvatar(String id, List<int> bytes, String ext) async {
    final url = await _ds.uploadAvatar(id, bytes, ext);
    return _ds.update(id, avatarUrl: url);
  }
}

/// Provider ProfileRepository (keepAlive).
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(profileDataSourceProvider));
}
