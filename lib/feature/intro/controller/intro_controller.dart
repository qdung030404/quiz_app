import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/service/auth_service.dart';
import '../../auth/view/login_screen.dart';
import '../../auth/view/register_screen.dart';
import '../../bottom_navigation_bar/view/bottom_navigation_bar.dart';

class IntroController extends GetxController {
  final _authService = AuthService();
  var loadingGoogle = false.obs;

  Future<void> signInWithGoogle() async {
    loadingGoogle.value = true;
    final result = await _authService.signInWithGoogle();
    loadingGoogle.value = false;

    if (result.success) {
      Get.offAll(() => const MainScreen());
    } else {
      Get.snackbar(
        'Lỗi',
        result.errorMessage ?? 'Đăng nhập Google thất bại',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToLogin() => Get.to(() => const LoginScreen());

  void navigateToRegister() => Get.to(() => const RegisterScreen());
}
