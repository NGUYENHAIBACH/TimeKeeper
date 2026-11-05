// Đồ giả dùng chung cho các test của TV1.

import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

/// Hồ sơ mẫu.
const testProfile = Profile(
  id: '11111111-1111-1111-1111-111111111111',
  firebaseUid: 'firebase-uid-1',
  email: 'nhanvien.a@timekeeper.vn',
  fullName: 'Nguyen Van A',
);

/// ProfileViewModel giả: trả về hồ sơ cố định, không gọi Firebase / Supabase.
/// Dùng: `profileViewModelProvider.overrideWith(() => FakeProfileViewModel(p))`.
class FakeProfileViewModel extends ProfileViewModel {
  FakeProfileViewModel(this.profile);
  final Profile? profile;

  @override
  Future<Profile?> build() async => profile;
}
