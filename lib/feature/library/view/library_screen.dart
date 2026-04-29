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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Thư viện',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LibraryCategories(),
              SizedBox(height: 24.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator(color: Colors.white70)),
                  );
                }

                final selectedId = controller.selectedCategory.value.id;

                if (selectedId == 'flashcard_set') {
                  if (controller.flashcardSet.isEmpty) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          'Bạn chưa có bộ thẻ nào!',
                          style: GoogleFonts.inter(color: Colors.white54),
                        ),
                      ),
                    );
                  }
                  return FlashcardsetsList(
                    flashcardSets: controller.flashcardSet,
                    onTap: (set) {},
                  );
                } else {
                  if (controller.folder.isEmpty) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          'Bạn chưa có thư mục nào!',
                          style: GoogleFonts.inter(color: Colors.white54),
                        ),
                      ),
                    );
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
