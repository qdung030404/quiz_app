import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderMenuBottomSheet extends StatelessWidget {
  final VoidCallback onAddSet;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const FolderMenuBottomSheet({
    super.key,
    required this.onAddSet,
    required this.onEdit,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        MenuItem(
          icon: Icons.add_circle_outline,
          title: 'Thêm học phần',
          onTap: onAddSet,
        ),
        MenuItem(icon: Icons.edit_outlined, title: 'Sửa', onTap: onEdit),
        MenuItem(icon: Icons.share_outlined, title: 'Chia sẻ', onTap: onShare),
        MenuItem(
          icon: Icons.delete_outlined,
          title: 'xóa',
          onTap: onDelete,
          color: Colors.red,
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
