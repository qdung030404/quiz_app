import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../core/theme/app_color.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Đặt lại mật khẩu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
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
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 16),

            // Mật khẩu mới
            Obx(() => _buildPasswordField(
              context: context,
              controller: controller.passwordController,
              label: 'Mật khẩu mới',
              obscure: controller.obscuredPassword.value,
              onToggle: () => controller.togglePasswordVisibility(),
            )),

            const SizedBox(height: 16),

            // Xác nhận mật khẩu
            Obx(() => _buildPasswordField(
              context: context,
              controller: controller.confirmPasswordController,
              label: 'Xác nhận mật khẩu',
              obscure: controller.obscuredConfirmPassword.value,
              onToggle: () => controller.toggleConfirmPasswordVisibility(),
            )),

            const SizedBox(height: 8),
            Obx(() {
              final mismatch = controller.confirmPasswordController.text.isNotEmpty &&
                  controller.passwordController.text != controller.confirmPasswordController.text;
              return mismatch
                  ? Text(
                      'Mật khẩu không khớp',
                      style: TextStyle(
                          color: Colors.redAccent, fontSize: 12.sp),
                    )
                  : const SizedBox.shrink();
            }),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2A1896),
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: controller.isResetFormValid && !controller.updatePasswordLoading.value 
                    ? () => controller.updatePassword() 
                    : null,
                child: controller.updatePasswordLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Cập nhật mật khẩu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.fillColor(context),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 16.h),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggle,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColor.borderColor(context), width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
