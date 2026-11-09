import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/profile.dart';
import '../settings/profile_viewmodel.dart';

/// Lấy hồ sơ hiện tại cho các ViewModel của module duyệt đơn.
Future<Profile> currentApprovalProfile(Ref ref) async {
  final profile = await ref.read(profileViewModelProvider.future);
  if (profile == null) {
    throw StateError('Chưa có hồ sơ nhân viên');
  }
  return profile;
}
