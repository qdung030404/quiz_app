import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/flashcard_set/widget/select_language_dialog.dart';

import '../controller/flashcard_controller.dart';

class CreateSetSettings extends StatefulWidget {
  const CreateSetSettings({super.key});

  @override
  State<CreateSetSettings> createState() => _CreateSetSettingsState();
}

class _CreateSetSettingsState extends State<CreateSetSettings> {
  final FlashcardController controller = Get.find<FlashcardController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 8,
        title: Text('Cài đặt tùy chọn'),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              alignment: Alignment.centerLeft,
              child: Text('Ngôn ngữ', style: GoogleFonts.beVietnamPro(fontSize: 16.sp),),
            ),
            Obx(
              () => SelectedLanguage(
                title: 'THUẬT NGỮ',
                selectedLanguage: controller.terminologyLanguage.value?.title ?? 'CHỌN NGÔN NGỮ',
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
              () => SelectedLanguage(
                title: 'ĐỊNH NGHĨA',
                selectedLanguage: controller.definitionLanguage.value?.title ?? 'CHỌN NGÔN NGỮ',
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
          ]
        )
      ),
    );
  }
}

class SelectedLanguage extends StatefulWidget {
  final String title;
  final String selectedLanguage;
  final VoidCallback onTap;

  const SelectedLanguage({
    super.key,
    required this.title,
    required this.selectedLanguage,
    required this.onTap,
  });

  @override
  State<SelectedLanguage> createState() => _SelectedLanguageState();
}

class _SelectedLanguageState extends State<SelectedLanguage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.1,
      padding: EdgeInsets.all(16.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title,style: GoogleFonts.beVietnamPro(fontSize: 16.sp)),
          TextButton(
            onPressed: widget.onTap,
            child: Text(
              widget.selectedLanguage,
              style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
