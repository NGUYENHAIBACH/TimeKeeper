/// Mau cau hinh moi truong. Copy file nay thanh `env.dart` (cung thu muc)
/// roi dien gia tri that lay tu Supabase Dashboard > Settings > API.
/// `env.dart` da duoc .gitignore, KHONG commit. KHONG BAO GIO dung service_role key.
class Env {
  Env._();

  /// Project URL, dang https://xxxxxxxx.supabase.co
  static const supabaseUrl = 'https://YOUR_PROJECT_REF.supabase.co';

  /// Publishable key (sb_publishable_...), thay cho anon key cu
  static const supabasePublishableKey = 'YOUR_ANON_KEY';
}
