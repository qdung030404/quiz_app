import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_mode/learn_result_screen.dart';

class LearnFeedbackWidget extends StatelessWidget {
  final VoidCallback onContinue;

  const LearnFeedbackWidget({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlashcardController>();

    return Obx(() {
      if (!controller.showFeedback.value) return const SizedBox.shrink();

      final bool correct = controller.isCorrect.value;
      final currentQ = controller.learnQuestions[controller.currentQuestionIndex.value];

      return Container(
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: correct ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.error,
                  color: correct ? Colors.green : Colors.red,
                ),
                SizedBox(width: 12.w),
                Text(
                  correct ? 'Chính xác!' : 'Chưa đúng',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: correct ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (!correct)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Đáp án đúng: ${currentQ.correctAnswer}',
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.currentQuestionIndex.value <
                      controller.learnQuestions.length - 1) {
                    onContinue();
                    controller.nextQuestion();
                  } else {
                    Get.to(() => const LearnResultScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: correct ? Colors.green : Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Tiếp tục',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
