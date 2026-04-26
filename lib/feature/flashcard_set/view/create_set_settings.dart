import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/flashcard_set/widget/setting_widget/select_language_dialog.dart';

import '../controller/create_flashcard_controller.dart';
import '../widget/setting_widget/privacy_dialog.dart';

class CreateSetSettings extends StatefulWidget {
  const CreateSetSettings({super.key});

  @override
  State<CreateSetSettings> createState() => _CreateSetSettingsState();
}

class _CreateSetSettingsState extends State<CreateSetSettings> {
  final CreateFlashcardController controller = Get.find<CreateFlashcardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xff130649)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 8,
        title: Text('Cài đặt tùy chọn'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xff2d17d3)
                  : Colors.grey.shade500,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 8.r,
                      ),
                      child: Text(
                        'Ngôn ngữ',
                        style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
                      ),
                    ),
                  ),
                  Obx(
                    () => SettingItem(
                      title: 'Thuật Ngữ',
                      selected:
                          controller.terminologyLanguage.value?.title ??
                          'Chọn ngôn ngữ',
                      onTap: () {
                        Get.bottomSheet(
                          const SelectLanguageDialog(
                            type: LanguageType.terminology,
                          ),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => SettingItem(
                      title: 'Định Nghĩa',
                      selected:
                          controller.definitionLanguage.value?.title ??
                          'Chọn ngôn ngữ',
                      onTap: () {
                        Get.bottomSheet(
                          const SelectLanguageDialog(
                            type: LanguageType.definition,
                          ),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xff2d17d3)
                  : Colors.grey.shade500,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 8.r,
                      ),
                      child: Text(
                        'Quyền riêng tư',
                        style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
                      ),
                    ),
                  ),
                  Obx(
                    () => SettingItem(
                      title: 'Ai có thể xem',
                      selected: controller.isPublic.value
                          ? 'Mọi người'
                          : 'Chỉ mình tôi',
                      onTap: () {
                        Get.bottomSheet(const PrivacyDialog());
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xff2d17d3)
                  : Colors.grey.shade500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                      'Tự đông gợi ý',
                      style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.isSwitched.value,
                      onChanged: controller.toggleSwitch,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatefulWidget {
  final String title;
  final String selected;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(16.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: GoogleFonts.beVietnamPro(fontSize: 16.sp)),
          TextButton(
            onPressed: widget.onTap,
            child: Text(
              widget.selected,
              style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
