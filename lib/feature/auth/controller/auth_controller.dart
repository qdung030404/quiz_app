import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/auth_service.dart';
import '../../bottom_navigation_bar/view/bottom_navigation_bar.dart';
import '../../intro/view/intro.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();
  
  // Observable states
  var emailSignInLoading = false.obs;
  var googleSignInLoading = false.obs;
  var registerLoading = false.obs;
  var forgotPasswordLoading = false.obs;
  var updatePasswordLoading = false.obs;
  var obscuredPassword = true.obs;
  var obscuredConfirmPassword = true.obs;
  var isFormValid = false.obs;

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(updateFormValidStatus);
    passwordController.addListener(updateFormValidStatus);
    confirmPasswordController.addListener(updateFormValidStatus);
  }

  void updateFormValidStatus() {
    isFormValid.value = emailController.text.isNotEmpty;
  }

  bool get isResetFormValid =>
      passwordController.text.length >= 6 &&
      passwordController.text == confirmPasswordController.text;

  void togglePasswordVisibility() {
    obscuredPassword.value = !obscuredPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscuredConfirmPassword.value = !obscuredConfirmPassword.value;
  }

  String? emailValidator(String? value) => _authService.validateEmail(value);
  String? passwordValidator(String? value) => _authService.validatePassword(value);

  Future<void> signIn() async {
    emailSignInLoading.value = true;
    final result = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    emailSignInLoading.value = false;

    if (result.success) {
      Get.offAll(() => const MainScreen());
    } else {
      Get.snackbar('Lỗi', result.errorMessage ?? 'Đăng nhập thất bại', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> sendPasswordReset() async {
    forgotPasswordLoading.value = true;
    final result = await _authService.sendPasswordReset(email: emailController.text);
    forgotPasswordLoading.value = false;

    if (result.success) {
      Get.back();
      Get.snackbar('Thành công', 'Vui lòng kiểm tra email để đặt lại mật khẩu', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Lỗi', result.errorMessage ?? 'Có lỗi xảy ra', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updatePassword() async {
    if (!isResetFormValid) return;
    updatePasswordLoading.value = true;
    final result = await _authService.updatePassword(
      newPassword: passwordController.text,
    );
    updatePasswordLoading.value = false;

    if (result.success) {
      Get.snackbar('Thành công', 'Đặt lại mật khẩu thành công!', backgroundColor: Colors.green, colorText: Colors.white);
      await _authService.signOut();
      Get.offAll(() => const Intro());
    } else {
      Get.snackbar('Lỗi', result.errorMessage ?? 'Không thể cập nhật mật khẩu', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    
    registerLoading.value = true;
    final result = await _authService.signUp(
      email: emailController.text,
      password: passwordController.text,
    );
    registerLoading.value = false;

    if (result.success) {
      Get.snackbar('Thành công', 'Đăng ký thành công', backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAll(() => const MainScreen());
    } else {
      Get.snackbar('Lỗi', result.errorMessage ?? 'Đăng ký thất bại', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> signInWithGoogle() async {
    googleSignInLoading.value = true;
    final result = await _authService.signInWithGoogle();
    googleSignInLoading.value = false;

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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
