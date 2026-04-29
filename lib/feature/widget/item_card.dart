import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_app/core/theme/app_color.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String? count;
  final VoidCallback onTap;
  final Icon iconData;

  const ItemCard({
    super.key,
    required this.title,
    this.count,
    required this.onTap,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColor.borderColor(context),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: onTap,
                contentPadding: EdgeInsets.all(16.r),
                leading: Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ?
                    Colors.white.withOpacity(0.1) : Color(0xff9181F4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    iconData.icon,
                    size: 24.r,
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                subtitle: count != null
                    ? Text(
                        count!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ).paddingOnly(top: 4.h)
                    : null,
                trailing: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColor.fillColor(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
