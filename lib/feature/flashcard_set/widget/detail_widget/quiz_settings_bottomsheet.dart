import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';

class QuizSettingsBottomSheet extends StatelessWidget {
  final FlashCardSetModel flashcardSet;
  const QuizSettingsBottomSheet({super.key, required this.flashcardSet});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    
    // Initialize settings
    controller.prepareQuiz(flashcardSet);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Thiết lập Quiz',
            style: GoogleFonts.beVietnamPro(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loại câu hỏi (Chọn ít nhất 1)',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() => Wrap(
            spacing: 8.w,
            children: [
              _typeChip(controller, QuestionType.multipleChoice, 'Trắc nghiệm'),
              _typeChip(controller, QuestionType.trueFalse, 'Đúng/Sai'),
              _typeChip(controller, QuestionType.writing, 'Viết'),
              _typeChip(controller, QuestionType.matching, 'Ghép thẻ'),
            ],
          )),
          SizedBox(height: 24.h),
          Text(
            'Số lượng câu hỏi',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(() => Column(
            children: [
              Slider(
                value: controller.quizQuestionCount.value.toDouble(),
                min: 1,
                max: controller.cardInSet.length.toDouble(),
                divisions: controller.cardInSet.length > 1 ? controller.cardInSet.length - 1 : 1,
                label: controller.quizQuestionCount.value.toString(),
                activeColor: const Color(0xff7e62f4),
                onChanged: (value) {
                  controller.quizQuestionCount.value = value.toInt();
                },
              ),
              Text(
                '${controller.quizQuestionCount.value} / ${controller.cardInSet.length} câu hỏi',
                style: GoogleFonts.beVietnamPro(fontSize: 14.sp),
              ),
            ],
          )),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if (controller.quizSelectedTypes.isEmpty) {
                  Get.snackbar('Thông báo', 'Vui lòng chọn ít nhất 1 loại câu hỏi');
                  return;
                }
                Get.back();
                controller.startQuiz(flashcardSet);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7e62f4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Bắt đầu Quiz',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _typeChip(QuizController controller, QuestionType type, String label) {
    bool isSelected = controller.quizSelectedTypes.contains(type);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          controller.quizSelectedTypes.add(type);
        } else {
          if (controller.quizSelectedTypes.length > 1) {
            controller.quizSelectedTypes.remove(type);
          }
        }
      },
      selectedColor: const Color(0xff7e62f4).withOpacity(0.2),
      checkmarkColor: const Color(0xff7e62f4),
      labelStyle: GoogleFonts.beVietnamPro(
        color: isSelected ? const Color(0xff7e62f4) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
