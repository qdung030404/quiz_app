import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/profile/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
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
            'Hồ sơ',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: controller.getProfileStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final profile = snapshot.data!.first;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80.sp,
                          height: 80.sp,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              profile['avatar_url'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                  size: 40.sp,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['username'] ?? 'Người dùng',
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                profile['email'] ?? '',
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.sp),
                    GestureDetector(
                      onTap: () => controller.goToSetting(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70.sp,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),

                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.settings_outlined, size: 24.w),
                              SizedBox(width: 12.w),
                              Text(
                                'Cài Đặt',
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.sp),
                    Text(
                      'Thành tựu',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 2, color: Colors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Chuỗi ${profile['streak_count'] ?? 1} ngày',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 16.sp),
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.trophy,
                                  size: 100,
                                  color: Colors.yellow,
                                ),
                                Positioned(
                                  top: 20.sp,
                                  child: FaIcon(
                                    FontAwesomeIcons.certificate,
                                    size: 40,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  child: Text(
                                    "${profile['streak_count'] ?? 1}",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.sp),
                            Text(
                              'Hãy học tập vào ngày mai\n để duy trì chuỗi của bạn!',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
