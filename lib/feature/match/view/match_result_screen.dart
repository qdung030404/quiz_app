import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/base_screen.dart';
import '../../flashcard_set/controller/flashcard_controller.dart';
import '../controller/match_controller.dart';

class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({super.key});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 200.h),
          Center(
            child: Obx(
              () => Text(
                controller.isBestAchievement.value
                    ? 'Thành tích mới\n ${controller.currentAchievement.value.toStringAsFixed(1)} giây'
                    : 'Bạn đã hoàn thành trong \n ${controller.second.value.toStringAsFixed(1)} giây\n Thành tích tốt nhất của bạn là ${controller.bestAchievement.value.toStringAsFixed(1)} giây',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.sp),
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
                'Chơi lại',
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
    );
  }
}
