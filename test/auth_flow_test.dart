import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeper/core/router/app_router.dart';
import 'package:timekeeper/core/router/app_routes.dart';
import 'package:timekeeper/models/profile.dart';
import 'package:timekeeper/repositories/auth_repository.dart';
import 'package:timekeeper/repositories/profile_repository.dart';
import 'package:timekeeper/viewmodels/auth/auth_state_provider.dart';
import 'package:timekeeper/viewmodels/auth/auth_viewmodel.dart';
import 'package:timekeeper/views/auth/forgot_password_screen.dart';
import 'package:timekeeper/views/auth/login_screen.dart';

class _User extends Fake implements User {}

class _AuthRepository extends Fake implements AuthRepository {
  final login = Completer<User>();
  String? submittedPassword;

  @override
  Future<User> signIn({required String email, required String password}) {
    submittedPassword = password;
    return login.future;
  }
}

class _ProfileRepository extends Fake implements ProfileRepository {
  int syncCount = 0;

  @override
  Future<Profile> syncAfterLogin(User user) async {
    syncCount++;
    return const Profile(
      id: 'profile',
      firebaseUid: 'user',
      email: 'test@test.vn',
    );
  }
}

void main() {
  test('Profile sync finishes when the login screen stops listening', () async {
    final auth = _AuthRepository();
    final profile = _ProfileRepository();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        profileRepositoryProvider.overrideWithValue(profile),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(authViewModelProvider, (_, _) {});
    await container.read(authViewModelProvider.future);
    final operation = container
        .read(authViewModelProvider.notifier)
        .signIn('test@test.vn', 'oldpass');
    subscription.close();
    await container.pump();
    auth.login.complete(_User());
    await operation;
    expect(profile.syncCount, 1);
  });

  testWidgets('Auth refresh preserves the router and public navigation', (
    tester,
  ) async {
    final events = StreamController<User?>();
    final container = ProviderContainer(
      overrides: [authStateProvider.overrideWith((ref) => events.stream)],
    );
    addTearDown(() async {
      container.dispose();
      await events.close();
    });
    final routerSubscription = container.listen(routerProvider, (_, _) {});
    final router = routerSubscription.read();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    events.add(null);
    await tester.pumpAndSettle();
    router.push(AppRoutes.register);
    await tester.pumpAndSettle();
    events.add(null);
    await tester.pumpAndSettle();
    expect(identical(container.read(routerProvider), router), isTrue);
    expect(find.text('Tạo tài khoản'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Existing passwords are not rejected by registration rules', (
    tester,
  ) async {
    final auth = _AuthRepository();
    final profile = _ProfileRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileRepositoryProvider.overrideWithValue(profile),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'test@test.vn');
    await tester.enterText(find.byType(TextFormField).at(1), 'oldpass');
    await tester.ensureVisible(find.text('Đăng nhập'));
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    expect(auth.submittedPassword, 'oldpass');
    auth.login.completeError(const AuthException('Test login failed'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Forgot password fits a short viewport with the keyboard open', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ForgotPasswordScreen())),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Gửi email'));
    expect(find.text('Gửi email'), findsOneWidget);
  });
}
