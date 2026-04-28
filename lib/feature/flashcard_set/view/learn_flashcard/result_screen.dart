import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';

import '../../controller/flashcard_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardController controller = Get.find<FlashcardController>();

    return BaseScreen(
      appBar: AppBar(
        elevation: 8,
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Kết quả'),
        centerTitle: true,
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                final double chartSize =
                    MediaQuery.of(context).size.width * 0.4;
                final double greenVal = controller.greenRatio.value / 100.0;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: chartSize,
                      width: chartSize,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        color: Colors.orange,
                        strokeWidth: 12,
                      ),
                    ),
                    SizedBox(
                      height: chartSize,
                      width: chartSize,
                      child: CircularProgressIndicator(
                        value: greenVal,
                        color: Colors.green,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 12,
                      ),
                    ),
                    Text(
                      '${controller.percentComplete.value}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          _buildResultBar(
            context,
            Colors.green,
            'Đúng',
            '${controller.greenCount.value}',
          ),
          _buildResultBar(
            context,
            Colors.orange,
            'Sai',
            '${controller.redCount.value}',
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                Obx(
                      () => controller.wrongCards.isNotEmpty
                      ? _buildButton(
                    context,
                    Color(0xff5038ED),
                    'Tiếp tục ôn thuật ngữ',
                        () {
                      controller.redCount.value = 0;
                      controller.greenCount.value = 0;
                      controller.isReviewMode.value = true;
                      controller.prepareSession();
                      controller.swiperKey.value = UniqueKey();
                      Get.back();
                    },
                  )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                _buildButton(context, Colors.transparent, 'Đặt lại thẻ ghi nhớ', () {
                  controller.resetAll();
                  Get.back();
                  controller.isTerm.value = true;
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultBar(
    BuildContext context,
    Color color,
    String label,
    String data,
  ) {
    return Container(
      width: double.infinity,
      height: 40.sp,
      margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(
            data,
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    Color color,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50.sp,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
