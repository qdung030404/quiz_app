import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';

class MultipleChoiceQuestionWidget extends StatelessWidget {
  final LearnQuestion question;

  const MultipleChoiceQuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlashcardController>();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.options!.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final option = question.options![index];
        return Obx(() {
          final bool isSelected = controller.selectedAnswer.value == option;
          final bool showFeedback = controller.showFeedback.value;
          final bool isCorrectOption = option == question.correctAnswer;

          Color borderColor = Colors.grey.withOpacity(0.3);
          Color bgColor = Colors.transparent;

          if (showFeedback) {
            if (isCorrectOption) {
              borderColor = Colors.green;
              bgColor = Colors.green.withOpacity(0.1);
            } else if (isSelected) {
              borderColor = Colors.red;
              bgColor = Colors.red.withOpacity(0.1);
            }
          } else if (isSelected) {
            borderColor = const Color(0xff5038ED);
            bgColor = const Color(0xff5038ED).withOpacity(0.05);
          }

          return GestureDetector(
            onTap: () => controller.checkAnswer(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor, width: 2),
                color: bgColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: showFeedback && isCorrectOption
                            ? Colors.green
                            : (showFeedback && isSelected ? Colors.red : null),
                      ),
                    ),
                  ),
                  if (showFeedback && isCorrectOption)
                    const Icon(Icons.check_circle, color: Colors.green),
                  if (showFeedback && isSelected && !isCorrectOption)
                    const Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
