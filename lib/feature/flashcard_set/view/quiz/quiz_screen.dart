import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/quiz_controller.dart';
import 'package:quiz_app/feature/flashcard_set/widget/learn_widget/writing_question_widget.dart';
import 'package:quiz_app/feature/flashcard_set/widget/quiz_widget/quiz_feedback_widget.dart';
import 'package:quiz_app/feature/flashcard_set/widget/quiz_widget/quiz_multiple_choice_widget.dart';
import 'package:quiz_app/feature/flashcard_set/widget/quiz_widget/quiz_true_false_widget.dart';

class QuizScreen extends StatefulWidget {
  final FlashCardSetModel flashcardSet;

  const QuizScreen({super.key, required this.flashcardSet});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController _controller = Get.find<QuizController>();
  final TextEditingController _writingController = TextEditingController();

  @override
  void dispose() {
    _writingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => _showExitDialog(),
          icon: const Icon(Icons.close),
        ),
        title: Obx(() => Column(
              children: [
                Text(
                  'Quiz: ${widget.flashcardSet.title}',
                  style: GoogleFonts.beVietnamPro(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _controller.quizQuestions.isNotEmpty 
                        ? (_controller.currentQuizIndex.value + 1) / _controller.quizQuestions.length
                        : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff7e62f4)),
                    minHeight: 6.h,
                  ),
                ),
              ],
            )),
        centerTitle: true,
      ),
      child: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Obx(() {
          if (_controller.quizQuestions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final question = _controller.quizQuestions[_controller.currentQuizIndex.value];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Câu hỏi ${_controller.currentQuizIndex.value + 1}/${_controller.quizQuestions.length}',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: _buildQuestionContent(question),
                ),
              ),
              QuizFeedbackWidget(writingController: _writingController),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuestionContent(LearnQuestion question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.matching:
        return QuizMultipleChoiceWidget(question: question);
      case QuestionType.writing:
        return WritingQuestionWidget(textController: _writingController);
      case QuestionType.trueFalse:
        return QuizTrueFalseWidget(question: question);
    }
  }

  void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Thoát Quiz?'),
        content: const Text('Tiến trình của bạn sẽ không được lưu. Bạn có chắc chắn muốn thoát?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Thoát', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
