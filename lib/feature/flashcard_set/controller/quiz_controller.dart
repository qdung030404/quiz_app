import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';
import 'package:quiz_app/feature/flashcard_set/view/quiz/quiz_result_screen.dart';
import 'package:quiz_app/feature/flashcard_set/view/quiz/quiz_screen.dart';

class QuizController extends GetxController {
  final FlashcardController _flashcardController = Get.find<FlashcardController>();
  List<FlashCardModel> get cardInSet => _flashcardController.cardInSet;

  // Quiz Mode State
  final RxList<QuestionType> quizSelectedTypes = <QuestionType>[
    QuestionType.multipleChoice,
    QuestionType.trueFalse,
    QuestionType.writing,
    QuestionType.matching
  ].obs;
  
  final RxInt quizQuestionCount = 0.obs;
  final RxList<LearnQuestion> quizQuestions = <LearnQuestion>[].obs;
  final RxInt currentQuizIndex = 0.obs;
  final RxInt correctQuizCount = 0.obs;
  final RxInt wrongQuizCount = 0.obs;
  final RxList<Map<String, dynamic>> quizDetails = <Map<String, dynamic>>[].obs;
  
  final RxBool showFeedback = false.obs;
  final RxBool isCorrect = false.obs;
  final RxString selectedAnswer = ''.obs;

  void prepareQuiz(FlashCardSetModel set) {
    quizQuestionCount.value = _flashcardController.cardInSet.length;
    // Default show types if not already set or whenever re-opening settings
    if (quizSelectedTypes.isEmpty) {
      quizSelectedTypes.assignAll([
        QuestionType.multipleChoice,
        QuestionType.trueFalse,
        QuestionType.writing,
        QuestionType.matching
      ]);
    }
  }

  void startQuiz(FlashCardSetModel set) {
    generateQuizQuestions();
    currentQuizIndex.value = 0;
    correctQuizCount.value = 0;
    wrongQuizCount.value = 0;
    showFeedback.value = false;
    selectedAnswer.value = '';
    quizDetails.clear();
    Get.to(() => QuizScreen(flashcardSet: set));
  }

  void generateQuizQuestions() {
    quizQuestions.clear();
    final allCards = List<FlashCardModel>.from(_flashcardController.cardInSet)..shuffle();
    final int count = quizQuestionCount.value.clamp(1, allCards.length);
    final selectedCards = allCards.take(count).toList();

    for (var card in selectedCards) {
      final availableTypes = quizSelectedTypes.toList();
      if (availableTypes.isEmpty) availableTypes.add(QuestionType.multipleChoice);
      
      final type = (availableTypes..shuffle()).first;

      switch (type) {
        case QuestionType.multipleChoice:
          quizQuestions.add(LearnQuestion(
            cardId: card.id ?? '',
            question: card.terminology,
            correctAnswer: card.definition,
            type: QuestionType.multipleChoice,
            options: _generateOptions(card, _flashcardController.cardInSet),
          ));
          break;
        case QuestionType.writing:
          quizQuestions.add(LearnQuestion(
            cardId: card.id ?? '',
            question: card.terminology,
            correctAnswer: card.definition,
            type: QuestionType.writing,
          ));
          break;
        case QuestionType.trueFalse:
          quizQuestions.add(_generateTrueFalseQuestion(card, _flashcardController.cardInSet));
          break;
        case QuestionType.matching:
          quizQuestions.add(LearnQuestion(
            cardId: card.id ?? '',
            question: card.terminology,
            correctAnswer: card.definition,
            type: QuestionType.matching,
            options: _generateOptions(card, _flashcardController.cardInSet),
          ));
          break;
      }
    }
  }

  List<String> _generateOptions(FlashCardModel correctCard, List<FlashCardModel> allCards) {
    List<String> options = [correctCard.definition];
    List<String> distractors = allCards
        .where((c) => c.id != correctCard.id)
        .map((c) => c.definition)
        .toSet()
        .toList();
    
    distractors.shuffle();
    options.addAll(distractors.take(3));
    options.shuffle();
    return options;
  }

  LearnQuestion _generateTrueFalseQuestion(FlashCardModel card, List<FlashCardModel> allCards) {
    final isTrue = (List.from([true, false])..shuffle()).first;
    String displayDefinition;
    String correctAnswer;

    if (isTrue) {
      displayDefinition = card.definition;
      correctAnswer = 'True';
    } else {
      final distractors = allCards.where((c) => c.id != card.id).toList();
      if (distractors.isNotEmpty) {
        distractors.shuffle();
        displayDefinition = distractors.first.definition;
      } else {
        displayDefinition = card.definition + " (wrong)";
      }
      correctAnswer = 'False';
    }

    return LearnQuestion(
      cardId: card.id ?? '',
      question: "${card.terminology} == $displayDefinition",
      correctAnswer: correctAnswer,
      type: QuestionType.trueFalse,
      options: ['True', 'False'],
    );
  }

  void checkQuizAnswer(String answer) {
    if (showFeedback.value) return;

    final currentQ = quizQuestions[currentQuizIndex.value];
    selectedAnswer.value = answer;
    
    bool correct = false;
    if (currentQ.type == QuestionType.writing) {
      final userAnswer = answer.trim().toLowerCase();
      final correctAnswers = currentQ.correctAnswer
          .replaceAll('(', ',').replaceAll(')', ',')
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();
      correct = correctAnswers.contains(userAnswer);
    } else {
      correct = answer == currentQ.correctAnswer;
    }

    isCorrect.value = correct;
    if (correct) {
      correctQuizCount.value++;
    } else {
      wrongQuizCount.value++;
    }

    quizDetails.add({
      'question': currentQ.question,
      'correctAnswer': currentQ.correctAnswer,
      'userAnswer': answer,
      'isCorrect': correct,
      'type': currentQ.type,
    });

    showFeedback.value = true;
  }

  void nextQuizQuestion() {
    if (currentQuizIndex.value < quizQuestions.length - 1) {
      currentQuizIndex.value++;
      showFeedback.value = false;
      selectedAnswer.value = '';
    } else {
      Get.off(() => const QuizResultScreen());
    }
  }
}
