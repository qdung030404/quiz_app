import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/theme/app_color.dart';
import 'package:quiz_app/feature/home/widget/build_stat_card.dart';
import 'package:quiz_app/feature/home/widget/discovery.dart';
import 'package:quiz_app/feature/home/widget/recent_flashcards_list.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';

import '../../../core/widgets/base_screen.dart';
import '../controller/home_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return BaseScreen(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom Top Bar with Greeting and Streak
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.profileStream,
                builder: (context, snapshot) {
                  final profile =
                      (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? snapshot.data!.first
                      : null;
                  final name = profile?['username'] ?? 'Bạn';
                  final streak = profile?['streak_count'] ?? 0;

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chào ngày mới,",
                              style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
                            ),
                            Text(
                              name,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStreakBadge(streak),
                      SizedBox(width: 15.w),
                      _buildAvatar(profile?['avatar_url'], controller),
                    ],
                  );
                },
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: _buildSearchBar(context),
            ),
          ),

          SliverToBoxAdapter(
            child: BuildStatCard(),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bộ thẻ gần đây",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.navigateToLib,
                    child: Text(
                      "Xem tất cả",
                      style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: RecentFlashcardsList(),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 10.h),
              child: Text(
                "Khám phá",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.publicFolder.isEmpty) {
                return SizedBox(
                  height: 150.h,
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.white70)),
                );
              }
              return Discovery(publicFolder: controller.publicFolder);
            }),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100,),)
        ],
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orangeAccent,
            size: 20,
          ),
          SizedBox(width: 4.w),
          Text(
            "$streak",
            style: GoogleFonts.beVietnamPro(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? url, HomeController controller) {
    return GestureDetector(
      onTap: () => controller.goToProfile(),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: url != null && url.isNotEmpty
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultAvatar(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              : _buildDefaultAvatar(),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.deepPurple,
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColor.borderColor(context)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Icon(Icons.search, color: AppColor.fillColor(context), size: 20),
              SizedBox(width: 10.w),
              Text(
                "Tìm kiếm bộ thẻ, từ vựng...",
                style: GoogleFonts.beVietnamPro(fontSize: 14.sp),
              ),
              const Spacer(),
              Icon(Icons.tune, color: AppColor.fillColor(context), size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
