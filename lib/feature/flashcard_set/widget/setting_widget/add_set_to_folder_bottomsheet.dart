import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/Create/controller/create_controller.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';

import '../../../library/widget/folder_list.dart';

class AddSetToFolderBottomsheet extends StatelessWidget {
  const AddSetToFolderBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LibraryController());
    final navController = Get.put(CreateController());
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
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.1,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: GestureDetector(
            onTap: () => navController.createFolder(),
            child: Row(
              children: [
                Icon(Icons.add, size: 36),
                SizedBox(width: 16),
                Text(
                  'Thư mục mới',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Obx(() {
                // Hiển thị loading
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.folder.isEmpty) {
                  return const Center(child: Text('Bạn chưa có thư mục nào!'));
                }
                return FolderList(
                  folders: controller.folder,
                  onTap: (folder) {},
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
