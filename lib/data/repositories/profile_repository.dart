import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  /// Stream dữ liệu profile theo ID của user hiện tại.
  Stream<List<Map<String, dynamic>>> watchCurrentUserProfile() {
    final userId = _supabase.auth.currentUser!.id;
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId);
  }

  /// Cập nhật chuỗi ngày mở app (streak)
  Future<void> updateStreak() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('profiles')
          .select('streak_count, last_login_at')
          .eq('id', userId)
          .single();

      final int currentStreak = response['streak_count'] ?? 1;
      final String? lastLoginStr = response['last_login_at'];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (lastLoginStr == null || (response['streak_count'] ?? 0) == 0) {
        // Lần đầu đăng nhập hoặc dữ liệu streak đang là 0
        await _supabase
            .from('profiles')
            .update({'streak_count': 1, 'last_login_at': now.toIso8601String()})
            .eq('id', userId);
        return;
      }

      final lastLogin = DateTime.parse(lastLoginStr).toLocal();
      final lastDate = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        // Là ngày tiếp theo
        await _supabase
            .from('profiles')
            .update({
              'streak_count': currentStreak + 1,
              'last_login_at': now.toIso8601String(),
            })
            .eq('id', userId);
      } else if (difference > 1) {
        // Bị ngắt quãng
        await _supabase
            .from('profiles')
            .update({'streak_count': 1, 'last_login_at': now.toIso8601String()})
            .eq('id', userId);
      }
      // Nếu difference == 0 (vẫn trong cùng ngày) thì không làm gì
    } catch (e) {
      print('Error updating streak: $e');
    }
  }
}
