import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';

class QuizTrueFalseWidget extends StatelessWidget {
  final LearnQuestion question;

  const QuizTrueFalseWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    return Row(
      children: ['True', 'False'].map((option) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Obx(() {
              bool isSelected = controller.selectedAnswer.value == option;
              bool isCorrect = option == question.correctAnswer;
              bool showFeedback = controller.showFeedback.value;

              Color color = option == 'True' ? Colors.green : Colors.red;
              if (showFeedback) {
                if (!isCorrect && isSelected) {
                  color = Colors.grey;
                }
              }

              return ElevatedButton(
                onPressed: () => controller.checkQuizAnswer(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? color : Colors.white,
                  foregroundColor: isSelected ? Colors.white : color,
                  side: BorderSide(color: color, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  elevation: isSelected ? 4 : 0,
                ),
                child: Text(
                  option == 'True' ? 'Đúng' : 'Sai',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}
