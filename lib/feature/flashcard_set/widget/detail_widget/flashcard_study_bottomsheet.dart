import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';

class FlashcardStudyBottomsheet extends StatelessWidget {
  const FlashcardStudyBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlashcardController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(
              width: 80.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.sp),
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Center(
            child: Text(
              'Tùy Chọn',
              style: GoogleFonts.beVietnamPro(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.sp),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  optionItem(
                    Icons.shuffle,
                    'Trộn thẻ',
                    controller.isShuffle.value
                        ? Color(0xff5438f4)
                        : Colors.grey,
                    () => controller.toggleShuffleCard(),
                  ),
                  optionItem(
                    Icons.volume_up,
                    'chuyển văn bản\nthành giọng nói',
                    !controller.isMute.value ? Color(0xff5438f4) : Colors.grey,
                    () => controller.isMute.value = !controller.isMute.value,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thiết lập thẻ ghi nhớ',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 2, color: Color(0xff7e62f4)),
            ),
            child: Obx(
              () => Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: controller.isTerm.value == false
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 40.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xff7e62f4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      setFontLanguageItem(
                        context,
                        'Tiếng Việt',
                        !controller.isTerm.value,
                        () => controller.changeLanguage(false),
                      ),
                      setFontLanguageItem(
                        context,
                        'Tiếng Anh',
                        controller.isTerm.value,
                        () => controller.changeLanguage(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          TextButton(
            onPressed: () {
              controller.resetAll();
              Get.back();
            },
            child: Text(
              'Đặt lại thẻ ghi nhớ',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16.sp,
                color: Color(0xff5438f4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onPress,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 2, color: Colors.grey),
          ),
          child: IconButton(
            onPressed: onPress,
            icon: Icon(icon, color: color, size: 28.sp),
          ),
        ),
        SizedBox(height: 8.sp),
        Text(title, style: GoogleFonts.beVietnamPro(fontSize: 12.sp)),
      ],
    );
  }

  Widget setFontLanguageItem(
    BuildContext context,
    String title,
    bool isSelected,
    VoidCallback onPress,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 40.sp,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPress,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: AnimatedDefaultTextStyle(
              // Hiệu ứng chuyển màu chữ mượt mà
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.beVietnamPro(
                color: isSelected ? Colors.white : const Color(0xff7e62f4),
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}
