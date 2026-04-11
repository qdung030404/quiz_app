import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bottom_navigation_bar/view/bottom_navigation_bar.dart';
import '../../intro/view/intro.dart';

class SplashController extends GetxController {
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    nextScreen();
  }

  Future<void> nextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (supabase.auth.currentSession == null) {
      Get.offAll(() => const Intro());
    } else {
      Get.offAll(() => const MainScreen());
    }
  }
}
