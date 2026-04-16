import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 4.h,
        ),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: iconData,
        ),
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: count != null 
          ? Text(
              count!,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
              ),
            )
          : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
