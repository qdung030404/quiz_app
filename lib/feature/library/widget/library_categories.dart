import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/theme/app_color.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LibraryCategories extends StatelessWidget {
  const LibraryCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.find<LibraryController>();
    final categories = LibraryCategory.libraryCategories;

    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Obx(() {
        controller.selectedCategory.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            bool isSelected = item.id == controller.selectedCategory.value.id;

            return GestureDetector(
              onTap: () => controller.changeCategory(item),
              child: AnimatedContainer(
                duration: 300.ms,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff9181F4).withOpacity(0.8)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xff9181F4).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  item.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

