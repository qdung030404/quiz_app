import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/folder_model.dart';

class FolderList extends StatelessWidget {
  final List<FolderModel> folders; // Tên biến rõ ràng là 'folders'
  final Function(FolderModel) onTap;

  const FolderList({
    super.key,
    required this.folders,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length, // Sử dụng folders.length
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final folder = folders[index];
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
              child: const Icon(Icons.quiz_outlined),
            ),
            title: Text(
              folder.title,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            subtitle: Text(
              '${folder.setCount} bộ thẻ',
              style: TextStyle(fontSize: 13.sp),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
    );
  }
}
