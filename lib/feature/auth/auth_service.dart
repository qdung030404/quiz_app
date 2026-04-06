import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Kết quả trả về từ các hàm auth
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;
  final Session? session;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
    this.session,
  });
}

class AuthService {
  final _supabase = Supabase.instance.client;

  // ─── Email / Password ────────────────────────────────────────────────────

  /// Đăng nhập bằng email và mật khẩu
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return AuthResult(
        success: response.user != null && response.session != null,
        user: response.user,
        session: response.session,
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (_) {
      return AuthResult(success: false, errorMessage: 'Email hoặc mật khẩu không đúng');
    }
  }

  /// Đăng ký tài khoản mới
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return AuthResult(success: false, errorMessage: 'Đăng ký thất bại');
      }
      return AuthResult(
        success: response.session != null,
        user: response.user,
        session: response.session,
        // session == null có nghĩa là cần xác nhận email
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (_) {
      return AuthResult(success: false, errorMessage: 'Email đã được đăng ký');
    }
  }

  // ─── Google ──────────────────────────────────────────────────────────────

  /// Đăng nhập bằng Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT'],
        clientId: Platform.isAndroid
            ? dotenv.env['ANDROID_CLIENT']
            : dotenv.env['IOS_CLIENT'],
      );

      final account = await googleSignIn.authenticate();
      final idToken = account.authentication.idToken ?? '';
      final authorization = await account.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );

      return AuthResult(
        success: response.user != null && response.session != null,
        user: response.user,
        session: response.session,
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (_) {
      return AuthResult(success: false, errorMessage: 'Đăng nhập Google thất bại');
    }
  }

  // ─── Password Reset ──────────────────────────────────────────────────────

  /// Gửi email đặt lại mật khẩu
  Future<AuthResult> sendPasswordReset({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'quizapp://reset-callback',
      );
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (_) {
      return AuthResult(success: false, errorMessage: 'Có lỗi xảy ra, vui lòng thử lại');
    }
  }

  /// Cập nhật mật khẩu mới (sau khi reset)
  Future<AuthResult> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (_) {
      return AuthResult(success: false, errorMessage: 'Không thể cập nhật mật khẩu');
    }
  }

  // ─── Validators ──────────────────────────────────────────────────────────

  /// Kiểm tra định dạng email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Không được để trống';
    if (!value.contains('@')) return 'Email không hợp lệ';
    return null;
  }

  /// Kiểm tra mật khẩu
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Không được để trống';
    if (value.length <= 6) return 'Mật khẩu phải có tối thiểu 6 ký tự';
    return null;
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────

  Future<void> signOut() => _supabase.auth.signOut();
}
