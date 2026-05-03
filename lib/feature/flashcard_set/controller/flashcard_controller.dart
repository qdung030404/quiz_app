import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/learn_question.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_mode/learn_mode_screen.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_mode/learn_result_screen.dart';
import 'package:quiz_app/feature/flashcard_set/view/study_flashcard/study_flashcard_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quiz_app/feature/match/view/start_screen.dart';


class FlashcardController extends GetxController {
  final FlashcardRepository _flashcardRepository;

  FlashcardController({FlashcardRepository? repository})
      : _flashcardRepository = repository ?? FlashcardRepository();

  final Rx<FlashCardSetModel?> currentSet = Rx<FlashCardSetModel?>(null);

  final RxList<FlashCardModel> cardInSet = <FlashCardModel>[].obs;
  final RxList<FlashCardModel> learnCards = <FlashCardModel>[].obs;
  final RxList<FlashCardModel> wrongCards = <FlashCardModel>[].obs;

  final RxBool isPublic = false.obs;
  final RxBool isMute = true.obs;
  final RxBool isShuffle = false.obs;
  final RxBool isTerm = true.obs;


  var redCount = 0.obs;
  var greenCount = 0.obs;
  var totalCount = 1.obs;
  var percentComplete = 0.obs;
  var redRatio = 0.obs;
  var greenRatio = 0.obs;

  final RxBool loading = false.obs;
  final Rx<Key> swiperKey = Rx<Key>(UniqueKey());
  final RxBool isReviewMode = false.obs;
  final RxInt sessionTotalCount = 0.obs;
  final RxList<FlashCardModel> sessionCards = <FlashCardModel>[].obs;
  final RxInt currentCardIndex = 0.obs;
  final FlutterTts tts = FlutterTts();

  // Learn Mode State
  final RxList<LearnQuestion> learnQuestions = <LearnQuestion>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxBool showFeedback = false.obs;
  final RxBool isCorrect = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt correctLearnCount = 0.obs;
  final RxInt wrongLearnCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
  void changeLanguage(bool value) {
    if (isTerm.value == value) return; // Không làm gì nếu đã chọn rồi
    isTerm.value = value;
  }

  bool onSwipe(int index, int? currentIndex, CardSwiperDirection direction) {
    final swipedCard = sessionCards[index];
    if (direction == CardSwiperDirection.left) {
      redCount.value++;
      if (!wrongCards.contains(swipedCard)) {
        wrongCards.add(swipedCard);
      }
    } else if (direction == CardSwiperDirection.right) {
      greenCount.value++;
      wrongCards.remove(swipedCard);
    }

    if (currentIndex != null) {
      currentCardIndex.value = currentIndex;
      totalCount.value = currentIndex + 1;
      if (!isMute.value) {
        speakCurrentCard();
      }
    } else {
      totalCount.value = sessionTotalCount.value;
      isMute.value = false;
    }

    if (cardInSet.isNotEmpty) {
      int totalSwiped = redCount.value + greenCount.value;

      if (totalSwiped > 0) {
        percentComplete.value = ((greenCount.value / totalSwiped) * 100).toInt();
        redRatio.value = ((redCount.value / totalSwiped) * 100).toInt();
        greenRatio.value = ((greenCount.value / totalSwiped) * 100).toInt();
      }
    }

    return true;
  }

  void toggleShuffleCard() {
    isShuffle.value = !isShuffle.value;
    prepareSession();
    swiperKey.value = UniqueKey();
  }



  void resetAll() {
    redCount.value = 0;
    greenCount.value = 0;
    percentComplete.value = 0;
    redRatio.value = 0;
    greenRatio.value = 0;
    wrongCards.clear();
    isReviewMode.value = false;

    prepareSession();

    if (sessionCards.isNotEmpty) {
      totalCount.value = 1;
      currentCardIndex.value = 0;
      if (!isMute.value) {
        speakCurrentCard();
      }
    } else {
      totalCount.value = 0;
      currentCardIndex.value = 0;
    }

    swiperKey.value = UniqueKey();
  }

  void prepareSession() {
    if (!isReviewMode.value && isShuffle.value) {
      learnCards.shuffle();
    } else if (!isReviewMode.value && !isShuffle.value) {
      learnCards.value = List.from(cardInSet);
    }
    final cards = isReviewMode.value ? wrongCards : learnCards;
    sessionCards.value = List.from(cards);
    sessionTotalCount.value = sessionCards.length;
    currentCardIndex.value = 0;
  }

  void speakCurrentCard() async {
    if (!isMute.value && currentCardIndex.value < sessionCards.length) {
      final card = sessionCards[currentCardIndex.value];
      await tts.setLanguage(card.terminologyLanguage);
      await tts.speak(card.terminology);
    }
  }

  Future<void> loadCardInSet(FlashCardSetModel set) async {
    try {
      loading.value = true;
      cardInSet.clear();
      currentSet.value = set;
      isPublic.value = set.isPublic;
      final cards = await _flashcardRepository.getCardsInSet(set.id!, isPublic: set.isPublic);
      cardInSet.value = List.from(cards);
      isShuffle.value = false;
      learnCards.value = List.from(cards);
      sessionTotalCount.value = cards.length;
      resetAll();
    } catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      loading.value = false;
    }
  }


  void goToStudyFlashcard(FlashCardSetModel selectedSet) => Get.to(
    () => StudyFlashcardView(flashcardSet: selectedSet),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );
  void matchGame() => Get.to(
        () => StartScreen(),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );

  //Learn Mode Methods

  void goToLearnMode(FlashCardSetModel set) {
    generateLearnQuestions();
    Get.to(() => LearnModeScreen(flashcardSet: set)); 
  }

  void generateLearnQuestions() {
    learnQuestions.clear();
    correctLearnCount.value = 0;
    wrongLearnCount.value = 0;
    currentQuestionIndex.value = 0;
    showFeedback.value = false;

    final allCards = List<FlashCardModel>.from(cardInSet);
    
    for (var card in allCards) {
      // 1. Multiple Choice Question
      final options = _generateOptions(card, allCards);
      learnQuestions.add(LearnQuestion(
        cardId: card.id ?? '',
        question: card.terminology,
        correctAnswer: card.definition,
        type: QuestionType.multipleChoice,
        options: options,
      ));

      // 2. Writing Question
      learnQuestions.add(LearnQuestion(
        cardId: card.id ?? '',
        question: card.terminology,
        correctAnswer: card.definition,
        type: QuestionType.writing,
      ));
    }

    learnQuestions.shuffle();
  }

  List<String> _generateOptions(FlashCardModel correctCard, List<FlashCardModel> allCards) {
    List<String> options = [correctCard.definition];
    
    // Get distractors (other definitions)
    List<String> distractors = allCards
        .where((c) => c.id != correctCard.id)
        .map((c) => c.definition)
        .toSet() // Unique definitions
        .toList();
    
    distractors.shuffle();
    
    // Add up to 3 distractors
    options.addAll(distractors.take(3));
    
    // If not enough distractors from the set, maybe add some fillers (though usually we have enough)
    
    options.shuffle();
    return options;
  }

  void checkAnswer(String answer) {
    if (showFeedback.value) return;

    final currentQ = learnQuestions[currentQuestionIndex.value];
    selectedAnswer.value = answer;
    
    // Normalize for writing
    bool correct = false;
    if (currentQ.type == QuestionType.writing) {
      final userAnswer = answer.trim().toLowerCase();
      
      // Smart split: split by comma, and also handle text in parentheses
      // Example: "考慮 (こうりょ) (Kouryo)" -> ["考慮", "こうりょ", "Kouryo"]
      final correctAnswers = currentQ.correctAnswer
          .replaceAll('(', ',')
          .replaceAll(')', ',')
          .replaceAll('（', ',')
          .replaceAll('）', ',')
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
      correctLearnCount.value++;
    } else {
      wrongLearnCount.value++;
    }

    showFeedback.value = true;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < learnQuestions.length - 1) {
      currentQuestionIndex.value++;
      showFeedback.value = false;
      selectedAnswer.value = '';
    } else {
      // End of session
      Get.to(() => LearnResultScreen());
    }
  }
}

