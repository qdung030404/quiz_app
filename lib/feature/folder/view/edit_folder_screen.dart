import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/widgets/base_screen.dart';
import '../controller/folder_controller.dart';

class EditFolderScreen extends StatefulWidget {
  const EditFolderScreen({super.key});

  @override
  State<EditFolderScreen> createState() => _EditFolderScreenState();
}

class _EditFolderScreenState extends State<EditFolderScreen> {
  final FolderController _controller = Get.find<FolderController>();
  
  @override
  void initState() {
    super.initState();
    // Bỏ tên folder cũ vào ô TextField
    if (_controller.currentFolder.value != null) {
      _controller.titleController.text = _controller.currentFolder.value!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
          actions: [
            Obx(() => IconButton(
              onPressed: () => _controller.editFolder(),
              icon: _controller.loading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.check),
            )),
          ],

        ),
        body: Column(
          children: [
            SizedBox(height: 50.sp),
            Center(child: Icon(Icons.folder_outlined, size: 100)),
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: TextFormField(
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
                controller: _controller.titleController,
                decoration: InputDecoration(
                  hintText: 'Thư mục chưa đặt tên',
                  hintStyle: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.borderColor(context),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.borderColor(context),
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
