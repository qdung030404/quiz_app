import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';

class WritingQuestionWidget extends StatelessWidget {
  final TextEditingController textController;

  const WritingQuestionWidget({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlashcardController>();

    return Column(
      children: [
        Obx(() => TextField(
          controller: textController,
          enabled: !controller.showFeedback.value,
          decoration: InputDecoration(
            hintText: 'Nhập định nghĩa...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xff5038ED), width: 2),
            ),
          ),
          style: GoogleFonts.beVietnamPro(),
          onSubmitted: (value) => controller.checkAnswer(value),
        )),
        Obx(() {
          if (!controller.showFeedback.value) {
            return Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.checkAnswer(textController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5038ED),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Kiểm tra',
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
