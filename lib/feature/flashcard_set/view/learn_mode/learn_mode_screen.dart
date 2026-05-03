import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';
import 'package:quiz_app/feature/flashcard_set/widget/learn_widget/learn_feedback_widget.dart';
import 'package:quiz_app/feature/flashcard_set/widget/learn_widget/multiple_choice_question_widget.dart';
import 'package:quiz_app/feature/flashcard_set/widget/learn_widget/writing_question_widget.dart';

class LearnModeScreen extends StatefulWidget {
  final FlashCardSetModel flashcardSet;

  const LearnModeScreen({super.key, required this.flashcardSet});

  @override
  State<LearnModeScreen> createState() => _LearnModeScreenState();
}

class _LearnModeScreenState extends State<LearnModeScreen> {
  final FlashcardController _controller = Get.find<FlashcardController>();
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
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
        title: Obx(() => Column(
              children: [
                Text(
                  'Học: ${widget.flashcardSet.title}',
                  style: GoogleFonts.beVietnamPro(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _controller.learnQuestions.isNotEmpty 
                        ? (_controller.currentQuestionIndex.value + 1) / _controller.learnQuestions.length
                        : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff5038ED)),
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
          if (_controller.learnQuestions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final question = _controller.learnQuestions[_controller.currentQuestionIndex.value];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Câu hỏi ${_controller.currentQuestionIndex.value + 1}/${_controller.learnQuestions.length}',
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
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: question.type == QuestionType.multipleChoice
                      ? MultipleChoiceQuestionWidget(question: question)
                      : WritingQuestionWidget(textController: _writingController),
                ),
              ),
              LearnFeedbackWidget(
                onContinue: () => _writingController.clear(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
