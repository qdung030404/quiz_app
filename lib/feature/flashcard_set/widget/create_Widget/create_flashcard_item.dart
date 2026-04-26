import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/widget/setting_widget/select_language_dialog.dart';

import '../../../../core/theme/app_color.dart';
import '../../controller/create_flashcard_controller.dart';

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
  final CreateFlashcardController controller = Get.find<CreateFlashcardController>();

  final FocusNode _termFocus = FocusNode();
  final FocusNode _defFocus = FocusNode();
  final RxBool _isTermFocused = false.obs;
  final RxBool _isDefFocused = false.obs;
  late final draft = controller.flashcardDrafts[widget.index];

  @override
  void initState() {
    super.initState();
    _termFocus.addListener(() => _isTermFocused.value = _termFocus.hasFocus);
    _defFocus.addListener(() => _isDefFocused.value = _defFocus.hasFocus);
  }

  @override
  void dispose() {
    _termFocus.dispose();
    _defFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xff2d17d3).withOpacity(0.5)
              : Colors.white,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xff5038ED).withOpacity(0.3)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (Theme.of(context).brightness != Brightness.dark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            // Header: Số thứ tự và Nút xóa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thẻ số ${widget.index + 1}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
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
                    size: 20.r,
                    color: Colors.red[400],
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Divider(height: 1.h, color: Colors.grey.withOpacity(0.2)),
            SizedBox(height: 12.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'THUẬT NGỮ',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: _isTermFocused.value,
                        child: TextButton(
                          onPressed: () {
                            Get.bottomSheet(
                              const SelectLanguageDialog(
                                type: LanguageType.terminology,
                              ),
                              isScrollControlled: true,
                            );
                          },
                          child: Text(
                            controller.terminologyLanguage.value?.title ??
                                'CHỌN NGÔN NGỮ',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: const Color(0xff5038ED),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _termFocus,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  controller: widget.terminologyController,
                  onChanged: (value) =>
                      controller.onTerminologyChanged(widget.index, value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.fillColor(context),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xff5038ED),
                        width: 2.0,
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
                Obx(() {
                  if (draft.isGenerating.value) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: const LinearProgressIndicator(minHeight: 2),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ĐỊNH NGHĨA',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: _isDefFocused.value,
                        child: TextButton(
                          onPressed: () {
                            Get.bottomSheet(
                              const SelectLanguageDialog(
                                type: LanguageType.definition,
                              ),
                              isScrollControlled: true,
                            );
                          },
                          child: Text(
                            controller.definitionLanguage.value?.title ??
                                'CHỌN NGÔN NGỮ',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: const Color(0xff5038ED),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _defFocus,
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
                        color: const Color(0xff5038ED),
                        width: 2.0,
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
                SizedBox(height: 8.h),
                Obx(() {
                  if (draft.suggestions.isEmpty) return const SizedBox.shrink();
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: draft.suggestions.map((sug) {
                      return ActionChip(
                        label: Text(
                          sug,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12.sp,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        backgroundColor: const Color(0xff5038ED).withOpacity(0.1),
                        onPressed: () {
                          widget.definitionController.text = sug;
                          draft.suggestions.clear();
                        },
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
