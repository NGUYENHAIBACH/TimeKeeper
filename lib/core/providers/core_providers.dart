import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'core_providers.g.dart';

/// Các provider "hạ tầng" dùng chung cho toàn app.
/// Tất cả đều keepAlive vì chỉ tạo một lần và sống suốt vòng đời app.
/// View KHÔNG được watch trực tiếp các provider này; chỉ DataSource /
/// Repository mới được dùng.

/// Instance Firebase Auth. Mock được trong test bằng overrideWithValue.
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

/// Client Supabase (đã initialize trong main()).
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) => Supabase.instance.client;

/// SharedPreferences. Giá trị thật được override trong main():
/// `sharedPrefsProvider.overrideWithValue(prefs)`.
/// Nếu quên override sẽ ném lỗi ngay khi dùng, dễ phát hiện.
@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError(
    'sharedPrefsProvider phải được override trong ProviderScope ở main().',
  );
}
