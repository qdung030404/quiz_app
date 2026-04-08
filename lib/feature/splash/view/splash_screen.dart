import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    Get.put(SplashController());

    return const Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(child: FlutterLogo(size: 100)),
    );
  }
}
