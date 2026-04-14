import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/library/widget/flashcardSets_list.dart';
import 'package:quiz_app/feature/library/widget/folder_list.dart';
import 'package:quiz_app/feature/library/widget/library_categories.dart';

import '../../../core/widgets/base_screen.dart';
import '../controller/library_controller.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LibraryController());

    return BaseScreen(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'Thư viện',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LibraryCategories(),
              SizedBox(height: 16.h),
              Obx(() {
                // Hiển thị loading
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selectedId = controller.selectedCategory.value.id;

                // Hiển thị danh sách theo mục đang chọn
                if (selectedId == 'flashcard_set') {
                  if (controller.flashcardSet.isEmpty) {
                    return const Center(child: Text('Bạn chưa có bộ thẻ nào!'));
                  }
                  return FlashcardsetsList(
                    flashcardSets: controller.flashcardSet,
                    onTap: (set) {},
                  );
                } else {
                  if (controller.folder.isEmpty) {
                    return const Center(child: Text('Bạn chưa có thư mục nào!'));
                  }
                  return FolderList(
                    folders: controller.folder,
                    onTap: (folder) {},
                  );
                }
              }),
            ],
          ),
        )
      );
  }
}
