import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';

class QuizMultipleChoiceWidget extends StatelessWidget {
  final LearnQuestion question;

  const QuizMultipleChoiceWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    return Column(
      children: (question.options ?? []).map((option) {
        return Obx(() {
          bool isSelected = controller.selectedAnswer.value == option;
          bool isCorrect = option == question.correctAnswer;
          bool showFeedback = controller.showFeedback.value;

          Color borderColor = Colors.grey[300]!;
          Color backgroundColor = Colors.transparent;

          if (showFeedback) {
            if (isCorrect) {
              borderColor = Colors.green;
              backgroundColor = Colors.green.withOpacity(0.1);
            } else if (isSelected) {
              borderColor = Colors.red;
              backgroundColor = Colors.red.withOpacity(0.1);
            }
          } else if (isSelected) {
            borderColor = const Color(0xff7e62f4);
            backgroundColor = const Color(0xff7e62f4).withOpacity(0.05);
          }

          return GestureDetector(
            onTap: () => controller.checkQuizAnswer(option),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (showFeedback && isCorrect)
                    const Icon(Icons.check_circle, color: Colors.green),
                  if (showFeedback && isSelected && !isCorrect)
                    const Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}
