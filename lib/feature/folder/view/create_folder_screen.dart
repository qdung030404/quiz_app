import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/folder/controller/folder_controller.dart';

import '../../../core/theme/app_color.dart';

class CreateFolderScreen extends StatefulWidget {
  const CreateFolderScreen({super.key});

  @override
  State<CreateFolderScreen> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final CreateFolderController _controller = CreateFolderController();

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
              onPressed: _controller.isLoading.value ? null : () => _controller.createFolder(),
              icon: _controller.isLoading.value 
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
    );
  }
}
