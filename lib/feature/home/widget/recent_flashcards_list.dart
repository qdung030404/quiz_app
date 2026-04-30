import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/home/controller/home_controller.dart';


class RecentFlashcardsList extends StatelessWidget {
  const RecentFlashcardsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return  SizedBox(
      height: 180.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (controller.flashcardSets.isEmpty) {
          return _buildEmptySets();
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.flashcardSets.length,
          itemBuilder: (context, index) {
            final set = controller.flashcardSets[index];
            return _buildFlashcardSetCard(set, controller);
          },
        );
      }),
    );
  }
  Widget _buildEmptySets() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, size: 40.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chưa có bộ thẻ nào",
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hãy tạo bộ thẻ đầu tiên của bạn để bắt đầu học tập!",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFlashcardSetCard(dynamic set, HomeController controller) {
    return GestureDetector(
      onTap: () => controller.goToFlashcardDetail(set),
      child: Container(
        width: 140.w,
        margin: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.deepPurple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(
                      Icons.style,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    set.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${set.cardCount ?? 0} thuật ngữ",
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
