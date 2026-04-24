import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_color.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_flashcard/result_screen.dart';

import '../../../../data/models/flashcard_set_model.dart';
import '../../controller/flashcard_controller.dart';
import '../../widget/detail_widget/flash_card_item.dart';

class LearnFlashcard extends StatefulWidget {
  final FlashCardSetModel flashcardSet;

  const LearnFlashcard({super.key, required this.flashcardSet});

  @override
  State<LearnFlashcard> createState() => _LearnFlashcardState();
}

class _LearnFlashcardState extends State<LearnFlashcard> {
  final FlashcardController _controller = Get.put(FlashcardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCardInSet(widget.flashcardSet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        elevation: 8,
        leading: IconButton(
          onPressed: () {
            Get.back();
            _controller.resetAll();
          },
          icon: Icon(Icons.close),
        ),
        title: Obx(
          () => Text(
            '${_controller.totalCount.value}/${_controller.sessionTotalCount.value}',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20.r),
                  ),
                  border: Border.all(color: Colors.red),
                ),
                child: Center(
                  child: Obx(
                    () => Text(
                      '${_controller.redCount.value}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 70.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20.r),
                  ),
                  border: Border.all(color: Colors.green),
                ),
                child: Center(
                  child: Obx(
                    () => Text(
                      '${_controller.greenCount.value}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (_controller.cardInSet.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final int count = _controller.sessionCards.length;

              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: CardSwiper(
                  key: _controller.swiperKey.value,
                  cardsCount: count,
                  numberOfCardsDisplayed: count < 2 ? 1 : 2,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                        if (index >= _controller.sessionCards.length) {
                          return const SizedBox.shrink();
                        }
                        return FlashCardItem(
                          flashCardModel: _controller.sessionCards[index],
                          gradient: AppColor.primaryGradient,
                        );
                      },
                  onSwipe: _controller.onSwipe,
                  onEnd: () {
                    Get.to(() => ResultScreen());
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _controller.resetAll();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: AppColor.buttonColor(context),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.fillColor(context),
                    shape: CircleBorder(),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.speakCurrentCard();
                  },
                  icon: Icon(
                    Icons.volume_up,
                    color: AppColor.buttonColor(context),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.fillColor(context),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
