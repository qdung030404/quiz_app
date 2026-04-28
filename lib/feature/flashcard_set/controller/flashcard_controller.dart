import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_flashcard/learn_flashcard.dart';
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
      final cards = await _flashcardRepository.getCardsInSet(set.id!);
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


  void goToFlashcard(FlashCardSetModel selectedSet) => Get.to(
    () => LearnFlashcard(flashcardSet: selectedSet),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );
  void matchGame() => Get.to(
        () => StartScreen(),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );
  @override
  void onClose() {
    super.onClose();
  }
}

