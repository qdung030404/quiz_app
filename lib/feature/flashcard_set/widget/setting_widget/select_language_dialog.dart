import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/create_flashcard_controller.dart';

enum LanguageType { terminology, definition }

class SelectLanguageDialog extends StatelessWidget {
  final LanguageType type;

  const SelectLanguageDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final CreateFlashcardController controller = Get.find<CreateFlashcardController>();
    final languages = SelectLanguage.selectLanguage;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // Màu nền tối đồng bộ với app
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Để BottomSheet co giãn theo nội dung
        children: [
          Text(
            type == LanguageType.terminology
                ? 'Chọn ngôn ngữ thuật ngữ'
                : 'Chọn ngôn ngữ định nghĩa',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true, // Quan trọng khi nằm trong Column/BottomSheet
            physics: const NeverScrollableScrollPhysics(),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final item = languages[index];

              return Obx(() {
                final currentLanguage = type == LanguageType.terminology
                    ? controller.terminologyLanguage.value
                    : controller.definitionLanguage.value;

                final isSelected = currentLanguage?.id == item.id;

                return GestureDetector(
                  onTap: () {
                    if (type == LanguageType.terminology) {
                      controller.terminologyLanguage.value = item;
                    } else {
                      controller.definitionLanguage.value = item;
                    }
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurpleAccent.withOpacity(0.2)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16.sp,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.deepPurpleAccent,
                          ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
