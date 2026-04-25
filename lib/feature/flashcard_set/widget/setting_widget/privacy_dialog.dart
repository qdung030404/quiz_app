import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/create_flashcard_controller.dart';

class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateFlashcardController controller = Get.find<CreateFlashcardController>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lựa chọn quyền riêng tư',
            style: GoogleFonts.beVietnamPro(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(
            () => PrivacyOption(
              icon: Icons.lock_outline,
              title: 'Chỉ mình tôi',
              subtitle: 'Học phần này chỉ hiển thị với bạn.',
              isSelected: !controller.isPublic.value,
              onTap: () {
                controller.isPublic.value = false;
                Get.back();
              },
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => PrivacyOption(
              icon: Icons.public,
              title: 'Mọi người',
              subtitle: 'Ai cũng có thể xem và tìm kiếm học phần này.',
              isSelected: controller.isPublic.value,
              onTap: () {
                controller.isPublic.value = true;
                Get.back();
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class PrivacyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PrivacyOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xff5038ED) : Colors.grey[300]!,
            width: 2.r,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? Color(0xff5038ED).withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xff5038ED) : Colors.grey[600],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Color(0xff5038ED)
                          : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xff9181F4),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xff5038ED)),
          ],
        ),
      ),
    );
  }
}
