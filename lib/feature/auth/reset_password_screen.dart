import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _isFormValid =>
      _passwordController.text.length >= 6 &&
      _passwordController.text == _confirmController.text;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_isFormValid) return;
    setState(() => _loading = true);
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt lại mật khẩu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Đăng xuất session reset rồi về màn login
        await _supabase.auth.signOut();
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Đặt lại mật khẩu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Nhập mật khẩu mới',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 16),

            // Mật khẩu mới
            _buildPasswordField(
              controller: _passwordController,
              label: 'Mật khẩu mới',
              obscure: _obscurePassword,
              onToggle: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),

            const SizedBox(height: 16),

            // Xác nhận mật khẩu
            _buildPasswordField(
              controller: _confirmController,
              label: 'Xác nhận mật khẩu',
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_passwordController, _confirmController]),
              builder: (context, _) {
                final mismatch = _confirmController.text.isNotEmpty &&
                    _passwordController.text != _confirmController.text;
                return mismatch
                    ? Text(
                        'Mật khẩu không khớp',
                        style: TextStyle(
                            color: Colors.redAccent, fontSize: 12.sp),
                      )
                    : const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_passwordController, _confirmController]),
                builder: (context, _) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2A1896),
                      disabledBackgroundColor: Colors.grey,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isFormValid && !_loading ? _updatePassword : null,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Cập nhật mật khẩu',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff9181F4),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 16.h),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onToggle,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
