import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  final supabase = Supabase.instance.client;

  final bool _obscuredPassword = true;
  bool isFormValid = false;
  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true;
    });
    try {
      final result = await supabase.auth.signUp(
        email: email.text,
        password: password.text,
      );
      if (result.user != null && result.session != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'home')),
          (context) => false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C0630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Đăng ký',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SizedBox(height: 32),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: email,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff9181F4),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16.h,
                  ),
                  labelText: 'Email hoặc tên người dùng',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
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
                  fillColor: Color(0xff9181F4),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16.h,
                  ),
                  labelText: 'Mật Khẩu',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
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
              loading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
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
                        onPressed: isFormValid ? () => register() : null,
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
