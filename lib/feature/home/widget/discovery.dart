import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/public_folder_model.dart';

import '../controller/home_controller.dart';

class Discovery extends StatelessWidget {
  final List<PublicFolderModel> publicFolder;
  const Discovery({super.key, required this.publicFolder});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: publicFolder.length,
          itemBuilder: (context, index) {
            final folder = publicFolder[index];
            return GestureDetector(
              onTap: () => controller.goToListSetInPublicFolder(folder),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.deepPurple.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      top: -10,
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: const Icon(
                              Icons.public,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Text(
                             folder.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${folder.setCount ?? 0} bộ',
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
