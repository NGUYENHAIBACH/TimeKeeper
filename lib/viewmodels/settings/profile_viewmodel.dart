import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/repositories/profile_repository.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';

part 'profile_viewmodel.g.dart';

/// Hồ sơ của người đang đăng nhập. Mọi module khác lấy `employee_id`,
/// role, phòng ban, ca làm từ đây: `ref.watch(profileViewModelProvider)`.
///
/// keepAlive vì được dùng ở hầu hết màn hình; tự tải lại khi `authState`
/// đổi (đăng nhập / đăng xuất) nhờ `ref.watch`.
@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<Profile?> build() async {
    final user = await ref.watch(authStateProvider.future);
    if (user == null) return null;
    return _load(user);
  }

  /// Đọc hồ sơ theo uid. Nếu Supabase chưa có dòng nào (lần đầu đăng nhập,
  /// hoặc Home mở trước khi AuthViewModel kịp đồng bộ) thì tự tạo, để người
  /// đã đăng nhập LUÔN có hồ sơ và các module khác luôn có `employee_id`.
  Future<Profile> _load(User user) async {
    final repo = ref.read(profileRepositoryProvider);
    return await repo.getByUid(user.uid) ?? await repo.syncAfterLogin(user);
  }

  /// Tải lại hồ sơ từ Supabase (sau khi admin đổi role chẳng hạn).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authStateProvider.future);
      if (user == null) return null;
      return _load(user);
    });
  }

  /// Sửa họ tên / số điện thoại.
  Future<void> updateInfo({String? fullName, String? phone}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(profileRepositoryProvider)
          .update(current.id, fullName: fullName, phone: phone),
    );
  }

  /// Đổi ảnh đại diện (upload lên Supabase Storage).
  Future<void> changeAvatar(List<int> bytes, String ext) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).changeAvatar(current.id, bytes, ext),
    );
  }
}
