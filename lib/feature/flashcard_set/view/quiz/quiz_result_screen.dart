import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    final total = controller.quizQuestions.length;
    final correct = controller.correctQuizCount.value;
    final percentage = (correct / total * 100).toInt();

    return BaseScreen(
      appBar: AppBar(
        title: const Text('Kết quả Quiz'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildScoreHeader(correct, total, percentage),
          SizedBox(height: 20.h),
          const Divider(),
          Expanded(
            child: _buildDetailsList(controller),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildScoreHeader(int correct, int total, int percentage) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 120.w,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 80 ? Colors.green : (percentage >= 50 ? Colors.orange : Colors.red),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$percentage%',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$correct/$total',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            percentage >= 80 ? 'Tuyệt vời!' : (percentage >= 50 ? 'Khá tốt!' : 'Cần cố gắng thêm!'),
            style: GoogleFonts.beVietnamPro(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: percentage >= 80 ? Colors.green : (percentage >= 50 ? Colors.orange : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList( QuizController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.quizDetails.length,
      itemBuilder: (context, index) {
        final detail = controller.quizDetails[index];
        final bool isCorrect = detail['isCorrect'];

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Câu hỏi ${index + 1}',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Text(
                    _getTypeLabel(detail['type']),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                detail['question'],
                style: GoogleFonts.beVietnamPro(fontSize: 15.sp),
              ),
              SizedBox(height: 8.h),
              if (!isCorrect) ...[
                Text(
                  'Đáp án của bạn: ${detail['userAnswer']}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14.sp,
                    color: Colors.red[700],
                  ),
                ),
                Text(
                  'Đáp án đúng: ${detail['correctAnswer']}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14.sp,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                Text(
                  'Đáp án đúng: ${detail['correctAnswer']}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14.sp,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getTypeLabel(dynamic type) {
    // Note: type is QuestionType
    if (type.toString().contains('multipleChoice')) return 'Trắc nghiệm';
    if (type.toString().contains('trueFalse')) return 'Đúng/Sai';
    if (type.toString().contains('writing')) return 'Viết';
    if (type.toString().contains('matching')) return 'Ghép thẻ';
    return 'Khác';
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                side: const BorderSide(color: Color(0xff7e62f4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Quay lại',
                style: GoogleFonts.beVietnamPro(
                  color: const Color(0xff7e62f4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final quizController = Get.find<QuizController>();
                final flashcardController = Get.find<FlashcardController>();
                Get.back(); // Back to detail
                quizController.startQuiz(flashcardController.currentSet.value!); // Restart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7e62f4),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Làm lại',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
