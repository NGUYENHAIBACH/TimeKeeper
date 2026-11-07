// Test hồi quy cho lỗi tìm ra khi chạy trên máy ảo: sau khi đăng ký, router
// rời màn Register làm AuthViewModel (autoDispose) bị hủy giữa chừng nên hồ sơ
// không được tạo trên Supabase và Home kẹt ở "Đang đăng nhập".

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/repositories/auth_repository.dart';
import 'package:timekeeper/repositories/profile_repository.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';
import 'package:timekeeper/viewmodels/auth/auth_viewmodel.dart';
import 'package:timekeeper/viewmodels/settings/profile_viewmodel.dart';

/// User Firebase giả, chỉ cần uid / email / displayName.
class _FakeUser implements User {
  _FakeUser({this.displayName});

  @override
  String get uid => 'uid-1';
  @override
  String? get email => 'a@timekeeper.vn';
  @override
  final String? displayName;
  @override
  String? get photoURL => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// AuthRepository giả: đăng nhập thành công sau một nhịp, hoặc ném lỗi.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.error});
  final Object? error;
  final gate = Completer<void>();

  Future<User> _login() async {
    await gate.future;
    if (error != null) throw error!;
    return _FakeUser(displayName: 'Nguyen Van A');
  }

  @override
  Future<User> signIn({required String email, required String password}) => _login();

  @override
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
  }) =>
      _login();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// ProfileRepository giả lưu hồ sơ trong bộ nhớ, đếm số lần upsert.
class _FakeProfileRepository implements ProfileRepository {
  Profile? stored;
  int syncCalls = 0;

  @override
  Future<Profile?> getByUid(String uid) async => stored;

  @override
  Future<Profile> syncAfterLogin(User user) async {
    syncCalls++;
    return stored = Profile(
      id: 'p1',
      firebaseUid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? stored?.fullName,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ProfileViewModel', () {
    ProviderContainer make(_FakeProfileRepository repo, User? user) {
      final c = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(user)),
          profileRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(c.dispose);
      // Riverpod 3 tạm dừng provider không có ai lắng nghe (stream sẽ không
      // phát), nên phải listen như một View đang mở.
      c.listen(profileViewModelProvider, (_, _) {});
      return c;
    }

    test('chưa đăng nhập -> null, không đụng Supabase', () async {
      final repo = _FakeProfileRepository();
      final c = make(repo, null);
      expect(await c.read(profileViewModelProvider.future), isNull);
      expect(repo.syncCalls, 0);
    });

    test('đã đăng nhập nhưng chưa có hồ sơ -> tự tạo (không trả null)', () async {
      final repo = _FakeProfileRepository();
      final c = make(repo, _FakeUser());
      final profile = await c.read(profileViewModelProvider.future);
      expect(profile, isNotNull);
      expect(profile!.firebaseUid, 'uid-1');
      expect(repo.syncCalls, 1);
    });

    test('đã có hồ sơ -> chỉ đọc, không upsert lại', () async {
      final repo = _FakeProfileRepository()
        ..stored = const Profile(id: 'p1', firebaseUid: 'uid-1', email: 'a@timekeeper.vn');
      final c = make(repo, _FakeUser());
      expect((await c.read(profileViewModelProvider.future))!.id, 'p1');
      expect(repo.syncCalls, 0);
    });
  });

  group('AuthViewModel', () {
    test('màn hình bị hủy giữa lúc đăng ký -> vẫn đồng bộ hồ sơ lên Supabase',
        () async {
      final auth = _FakeAuthRepository();
      final profiles = _FakeProfileRepository();
      final c = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileRepositoryProvider.overrideWithValue(profiles),
          authStateProvider.overrideWith((ref) => Stream.value(_FakeUser())),
        ],
      );
      addTearDown(c.dispose);

      // View đang lắng nghe ViewModel rồi bấm "Tạo tài khoản".
      final sub = c.listen(authViewModelProvider, (_, _) {});
      final done = c
          .read(authViewModelProvider.notifier)
          .register('a@timekeeper.vn', 'Matkhau123', 'Nguyen Van A');

      // Router rời màn Register: View bỏ lắng nghe trước khi Firebase trả lời.
      sub.close();
      await Future<void>.delayed(Duration.zero);
      auth.gate.complete();
      await done;

      expect(profiles.syncCalls, 1);
      expect(profiles.stored!.fullName, 'Nguyen Van A');
    });

    test('đăng nhập sai -> state lỗi, không tạo hồ sơ', () async {
      final auth = _FakeAuthRepository(
        error: const AuthException('Email hoặc mật khẩu không đúng'),
      );
      final profiles = _FakeProfileRepository();
      final c = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
      );
      addTearDown(c.dispose);
      c.listen(authViewModelProvider, (_, _) {});

      final done = c.read(authViewModelProvider.notifier).signIn('a@b.vn', 'sai12345');
      auth.gate.complete();
      await done;

      final state = c.read(authViewModelProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), 'Email hoặc mật khẩu không đúng');
      expect(profiles.syncCalls, 0);
    });
  });
}
