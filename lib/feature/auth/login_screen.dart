import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/core/service/auth_service.dart';
import 'package:quiz_app/feature/auth/forgot_password.dart';
import 'package:quiz_app/feature/bottom_navigation_bar/bottom_navigation_bar.dart';

import 'package:quiz_app/core/theme/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _authService = AuthService();

  bool _obscuredPassword = true;
  bool isFormValid = false;
  bool isLoading = false;

  void _updateFormValidStatus() {
    setState(() {
      isFormValid = email.text.isNotEmpty && password.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    email.addListener(_updateFormValidStatus);
    password.addListener(_updateFormValidStatus);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() => isLoading = true);
    final result = await _authService.signIn(
      email: email.text,
      password: password.text,
    );
    if (!mounted) return;
    if (result.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.errorMessage ?? 'Đăng nhập thất bại'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);
    final result = await _authService.signInWithGoogle();
    if (!mounted) return;
    if (result.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.errorMessage ?? 'Đăng nhập Google thất bại'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Đăng nhập',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.fillColor(context),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16.h,
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColor.borderColor(context),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: password,
                        obscureText: _obscuredPassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.fillColor(context),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16.h,
                          ),
                          labelText: 'Mật Khẩu',
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppColor.borderColor(context),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      isLoading ? CircularProgressIndicator() :
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2A1896),
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isFormValid ? () => signIn() : null,
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Quên mật khẩu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      isLoading ? CircularProgressIndicator() :
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2A1896),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => signInWithGoogle(),
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: Text(
                            'Tiếp tục với google',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
