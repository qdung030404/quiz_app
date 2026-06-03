import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';

class QuizFeedbackWidget extends StatelessWidget {
  final TextEditingController writingController;

  const QuizFeedbackWidget({super.key, required this.writingController});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    return Obx(() {
      if (!controller.showFeedback.value) {
        if (controller.quizQuestions[controller.currentQuizIndex.value].type == QuestionType.writing) {
           return Padding(
             padding: EdgeInsets.only(top: 16.h),
             child: ElevatedButton(
               onPressed: () => controller.checkQuizAnswer(writingController.text),
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xff7e62f4),
                 minimumSize: Size(double.infinity, 50.h),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
               ),
               child: Text('Kiểm tra', style: GoogleFonts.beVietnamPro(color: Colors.white, fontWeight: FontWeight.bold)),
             ),
           );
        }
        return const SizedBox.shrink();
      }

      final isCorrect = controller.isCorrect.value;
      return Container(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.error,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      isCorrect ? 'Tuyệt vời! Bạn đã trả lời đúng.' : 'Opps! Đáp án đúng là: ${controller.quizQuestions[controller.currentQuizIndex.value].correctAnswer}',
                      style: GoogleFonts.beVietnamPro(
                        color: isCorrect ? Colors.green[800] : Colors.red[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                writingController.clear();
                controller.nextQuizQuestion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7e62f4),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                controller.currentQuizIndex.value < controller.quizQuestions.length - 1 ? 'Câu tiếp theo' : 'Xem kết quả',
                style: GoogleFonts.beVietnamPro(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
}
