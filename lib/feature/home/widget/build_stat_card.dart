import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/home/controller/home_controller.dart';

import '../../../core/theme/app_color.dart';

class BuildStatCard extends StatelessWidget {


  const BuildStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Obx(
            () => Row(
          children: [
            Expanded(child: _buildStatCard(
              context,
              "Học phần",
              '${controller.totalSets}',
              Icons.check_circle_outline,
              Colors.greenAccent,
            ),),
            Expanded(child: _buildStatCard(
              context,
              "Thẻ học",
              '${controller.totalCards}',
              Icons.style_outlined,
              Colors.orangeAccent,
            ),)
          ],
        ),
      ),
    );
  }
  Widget _buildStatCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.fillColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: GoogleFonts.beVietnamPro(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
