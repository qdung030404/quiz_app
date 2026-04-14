import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/theme/app_color.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';

class LibraryCategories extends StatelessWidget {
  const LibraryCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = Get.find<LibraryController>();
    final categories = LibraryCategory.libraryCategories;

    return SizedBox(
      height: 40.h,
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
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.borderColor(context),
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected ? AppColor.fillColor(context) : Colors
                      .transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  item.title,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isSelected ? Colors.white : Colors.white70,
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

