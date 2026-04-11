import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';
import 'package:quiz_app/feature/flashcard_set/widget/flashcard.dart';

class CreateFlashcardSetScreen extends StatelessWidget {
  const CreateFlashcardSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardController controller = Get.put(FlashcardController());

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
            'Tạo học phần',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : IconButton(
                      onPressed: () => controller.createFlashcardSet(),
                      icon: const Icon(Icons.check),
                    ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              // Phần nhập Tiêu đề học phần
              TextFormField(
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'TIÊU ĐỀ',
                  labelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Chủ đề của bộ thẻ...',
                  hintStyle: GoogleFonts.beVietnamPro(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Danh sách các thẻ bài
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.flashcardDrafts.length,
                    itemBuilder: (context, index) {
                      final draft = controller.flashcardDrafts[index];
                      return Flashcard(
                        terminologyController: draft.terminologyController,
                        definitionController: draft.definitionController,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.addEmptyCard(),
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.add,),
        ),
      ),
    );
  }
}
