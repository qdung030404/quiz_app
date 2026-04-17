import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/theme/app_color.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/data/models/folder_model.dart';
import 'package:quiz_app/feature/folder/Widget/button.dart';
import 'package:quiz_app/feature/folder/controller/folder_controller.dart';
import 'package:quiz_app/feature/widget/item_card.dart';

import '../Widget/folder_menu_bottomsheet.dart';

class FolderDetailScreen extends StatelessWidget {
  final FolderModel folder;

  const FolderDetailScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FolderController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFolder(folder);
    });
    return BaseScreen(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.goToAddScreen();
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: FolderMenuBottomSheet(
                    onAddSet: () => controller.goToAddScreen(),
                    onEdit: () => controller.goToEditScreen(),
                    onShare: () {},
                    onDelete: () => controller.deleteFolder(),
                  ),
                ),
                backgroundColor: Color(0xFF211374),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Center(
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.folder_outlined, size: 40),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              folder.title,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() {
              if (controller.loading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (controller.setsInFolder.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 48.sp,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.fillColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt_outlined, size: 40),
                      Text(
                        'bắt đầu cây dựng thư mục \n của bạn',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.sp),
                      Button(
                        text: 'Thêm học phần',
                        backgroundColor: Color(0xff5038ED),
                        onPress: () {},
                      ),
                      SizedBox(height: 8.sp),
                      Button(
                        text: 'Tạo mới',
                        backgroundColor: Colors.grey.shade500,
                        onPress: () {},
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.r),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.setsInFolder.length,
                itemBuilder: (context, index) {
                  final set = controller.setsInFolder[index];
                  return ItemCard(
                    title: set.title,
                    count: '${set.cardCount} thẻ',
                    iconData: Icon(Icons.folder_outlined),
                    onTap: () {},
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
