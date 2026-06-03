import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/feature/flashcard_set/widget/detail_widget/flashcard_set_menu_bottomsheet.dart';
import 'package:quiz_app/feature/flashcard_set/widget/setting_widget/add_set_to_folder_bottomsheet.dart';

import '../controller/flashcard_controller.dart';
import '../controller/quiz_controller.dart';
import '../widget/detail_widget/flash_card_item.dart';
import '../widget/detail_widget/quiz_settings_bottomsheet.dart';

class FlashcardSetDetailScreen extends StatefulWidget {
  final FlashCardSetModel flashcardSet;

  const FlashcardSetDetailScreen({super.key, required this.flashcardSet});

  @override
  State<FlashcardSetDetailScreen> createState() =>
      _FlashcardSetDetailScreenState();
}

class _FlashcardSetDetailScreenState extends State<FlashcardSetDetailScreen> {
  final FlashcardController _controller = Get.put(FlashcardController());
  final QuizController _quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    // Sử dụng loadCardInSet khi màn hình được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCardInSet(widget.flashcardSet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: AddSetToFolderBottomsheet(),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xff9181F4)
                    : Colors.grey[400],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                isScrollControlled: true,
              );
            },
            icon: const Icon(Icons.bookmark_outline),
          ),
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: FlashcardSetMenuBottomSheet(),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xff9181F4)
                    : Colors.grey[400],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (_controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: _controller.cardInSet.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FlashCardItem(
                            flashCardModel: _controller.cardInSet[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 28.h),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.flashcardSet.title,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                  Obx(
                        () => Text(
                      '${_controller.cardInSet.length} thẻ',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Column(
              children: [
                FeatureItem(
                  title: 'Flashcards',
                  icon: Image.asset('assets/image/flashcards.png'),
                  onTap: () => _controller.goToStudyFlashcard(widget.flashcardSet),
                ),
                SizedBox(height: 12.h),
                FeatureItem(
                  title: 'Learn',
                  icon: Image.asset('assets/image/learn.png'),
                  onTap: () => _controller.goToLearnMode(widget.flashcardSet),
                ),
                SizedBox(height: 12.h),
                FeatureItem(
                  title: 'Quiz',
                  icon: Image.asset('assets/image/quiz.png'),
                  onTap: () {
                    Get.bottomSheet(
                      QuizSettingsBottomSheet(flashcardSet: widget.flashcardSet),
                      isScrollControlled: true,
                    );
                  },
                ),
                SizedBox(height: 12.h),
                FeatureItem(
                  title: 'Match',
                  icon: Image.asset('assets/image/match.png'),
                  onTap: () => _controller.matchGame() ,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.07,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Row(
            children: [
              SizedBox(width: 28, height: 28, child: icon),
              SizedBox(width: 16.h),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
