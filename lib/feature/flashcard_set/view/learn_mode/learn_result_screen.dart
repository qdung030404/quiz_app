import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';

class LearnResultScreen extends StatelessWidget {
  const LearnResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardController controller = Get.find<FlashcardController>();
    final int total = controller.learnQuestions.length;
    final int correct = controller.correctLearnCount.value;
    final double percentage = total > 0 ? (correct / total) * 100 : 0;

    return BaseScreen(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back(); // Back to Learn Screen
            Get.back(); // Back to Detail Screen
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Kết quả học tập'),
        centerTitle: true,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 48.h),
            _buildScoreCircle(context, percentage),
            SizedBox(height: 32.h),
            Text(
              percentage >= 80
                  ? 'Tuyệt vời!'
                  : (percentage >= 50 ? 'Khá tốt!' : 'Cần cố gắng thêm'),
              style: GoogleFonts.beVietnamPro(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: percentage >= 80
                    ? Colors.green
                    : (percentage >= 50 ? Colors.orange : Colors.red),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Bạn đã hoàn thành ${controller.learnQuestions.length} câu hỏi',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40.h),
            _buildStatRow(
              'Đúng',
              controller.correctLearnCount.value,
              Colors.green,
            ),
            _buildStatRow('Sai', controller.wrongLearnCount.value, Colors.red),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.all(24.sp),
              child: TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text(
                  'Quay lại màn hình chính',
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xff5038ED),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context, double percentage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 180.sp,
          width: 180.sp,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            color: Colors.grey[200],
          ),
        ),
        SizedBox(
          height: 180.sp,
          width: 180.sp,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 12,
            color: percentage >= 80
                ? Colors.green
                : (percentage >= 50 ? Colors.orange : Colors.red),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          children: [
            Text(
              '${percentage.toInt()}%',
              style: GoogleFonts.beVietnamPro(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Độ chính xác',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              count.toString(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
