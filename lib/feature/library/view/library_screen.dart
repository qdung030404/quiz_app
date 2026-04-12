import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/Create/controller/create_controller.dart';

import '../../../core/widgets/base_screen.dart';
import '../controller/library_controller.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final LibraryController controller = Get.put(LibraryController());
    final CreateController navcontroller = Get.put(CreateController());

    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.flashcardSet.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Text('Bạn chưa có bộ thẻ nào!'),
                  ElevatedButton(
                    onPressed: () {
                      navcontroller.createSet();
                    },
                    child: Text('Tạo bộ thẻ mới '),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.flashcardSet.length,
            separatorBuilder: (context, index) =>
                const Divider(indent: 20, endIndent: 20),
            itemBuilder: (BuildContext context, int index) {
              final set = controller.flashcardSet[index];
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
                    set.title,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Text(
                    '${set.cardCount} thẻ',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
