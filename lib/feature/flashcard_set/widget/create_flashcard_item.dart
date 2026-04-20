import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/widget/select_language_dialog.dart';

import '../../../core/theme/app_color.dart';
import '../controller/flashcard_controller.dart';

class CreateFlashcardItem extends StatefulWidget {
  final TextEditingController terminologyController;
  final TextEditingController definitionController;
  final int index;

  const CreateFlashcardItem({
    super.key,
    required this.terminologyController,
    required this.definitionController,
    required this.index,
  });

  @override
  State<CreateFlashcardItem> createState() => _CreateFlashcardItemState();
}

class _CreateFlashcardItemState extends State<CreateFlashcardItem> {
  final FlashcardController controller = Get.find<FlashcardController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Column(
          children: [
            TextFormField(
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              controller: widget.terminologyController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.fillColor(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 3.0,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'THUẬT NGỮ',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.bottomSheet(
                      const SelectLanguageDialog(
                        type: LanguageType.terminology,
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Obx(
                    () => Text(
                      controller.terminologyLanguage.value?.title ??
                          'CHỌN NGÔN NGỮ',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              controller: widget.definitionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.fillColor(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 3.0,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ĐỊNH NGHĨA',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.bottomSheet(
                      const SelectLanguageDialog(type: LanguageType.definition),
                      isScrollControlled: true,
                    );
                  },
                  child: Obx(
                    () => Text(
                      controller.definitionLanguage.value?.title ??
                          'CHỌN NGÔN NGỮ',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  final termController = widget.terminologyController;
                  final defController = widget.definitionController;

                  controller.removeCard(widget.index, (context, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: CreateFlashcardItem(
                        index: widget.index,
                        terminologyController: termController,
                        definitionController: defController,
                      ),
                    );
                  });
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
