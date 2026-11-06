import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:timekeeper/core/providers/core_providers.dart';

part 'auth_state_provider.g.dart';

/// Stream trạng thái đăng nhập Firebase. `null` = chưa đăng nhập.
/// keepAlive vì router dùng để redirect; mọi module khác dùng để lấy uid.
///
/// Dùng: `ref.watch(authStateProvider)` trả về `AsyncValue<User?>`.
/// Đang loading nghĩa là Firebase chưa khôi phục xong phiên (màn Splash).
@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}
