import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';

import '../../flashcard_set/controller/flashcard_controller.dart';
import '../controller/match_controller.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchController());
    return BaseScreen(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => controller.toggleSound(),
              icon: Icon(
                controller.isMuted.value ? Icons.volume_up : Icons.volume_off,
              ),
            ),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bạn đã sẵn sàng',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.h),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final flashcardController = Get.find<FlashcardController>();
                  controller.startGame(flashcardController.cardInSet);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff5038ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                child: Text(
                  'Bắt đầu',
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
