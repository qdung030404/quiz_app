import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/feature/flashcard_set/view/create_set_settings.dart';
import 'package:quiz_app/feature/flashcard_set/view/learn_flashcard/learn_flashcard.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashCardDraft {
  final TextEditingController terminologyController;
  final TextEditingController definitionController;

  FlashCardDraft({
    TextEditingController? term,
    TextEditingController? definition,
  }) : terminologyController = term ?? TextEditingController(),
       definitionController = definition ?? TextEditingController();

  void dispose() {
    terminologyController.dispose();
    definitionController.dispose();
  }
}

class FlashcardController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();

  final TextEditingController titleController = TextEditingController();

  final RxList<FlashCardDraft> flashcardDrafts = <FlashCardDraft>[].obs;
  final Rx<FlashCardSetModel?> currentSet = Rx<FlashCardSetModel?>(null);

  final RxList<FlashCardModel> cardInSet = <FlashCardModel>[].obs;
  final RxList<FlashCardModel> learnCards = <FlashCardModel>[].obs;
  final RxList<FlashCardModel> wrongCards = <FlashCardModel>[].obs;

  // Key điều khiển AnimatedList
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final terminologyLanguage = Rxn<SelectLanguage>();
  final definitionLanguage = Rxn<SelectLanguage>();
  final RxBool isPublic = false.obs;

  var redCount = 0.obs;
  var greenCount = 0.obs;
  var totalCount = 1.obs;
  var percentComplete = 0.obs;
  var redRatio = 0.obs;
  var greenRatio = 0.obs;

  final RxBool loading = false.obs;
  final isLoading = false.obs;
  final Rx<Key> swiperKey = Rx<Key>(UniqueKey());
  final RxBool isReviewMode = false.obs;
  final RxInt sessionTotalCount = 0.obs;
  final RxList<FlashCardModel> sessionCards = <FlashCardModel>[].obs;
  final RxInt currentCardIndex = 0.obs;
  final FlutterTts tts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo 2 thẻ trống ban đầu
    flashcardDrafts.addAll([FlashCardDraft(), FlashCardDraft()]);
  }

  void addEmptyCard() {
    flashcardDrafts.add(FlashCardDraft());
    listKey.currentState?.insertItem(
      flashcardDrafts.length - 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  void removeCard(
    int index,
    Widget Function(BuildContext, Animation<double>) removedItemBuilder,
  ) {
    if (flashcardDrafts.length > 2) {
      final removedItem = flashcardDrafts[index];

      listKey.currentState?.removeItem(
        index,
        (context, animation) => removedItemBuilder(context, animation),
        duration: const Duration(milliseconds: 300),
      );

      flashcardDrafts.removeAt(index);
      Future.delayed(
        const Duration(milliseconds: 400),
        () => removedItem.dispose(),
      );
    } else {
      Get.snackbar('Thông báo', 'Bộ thẻ cần tối thiểu 2 thẻ bài');
    }
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
    } else {
      totalCount.value = sessionTotalCount.value;
    }

    if (cardInSet.isNotEmpty) {
      int totalSwiped = redCount.value + greenCount.value;
      percentComplete.value = ((greenCount.value / totalSwiped) * 100).toInt();

      if (totalSwiped > 0) {
        redRatio.value = ((redCount.value / totalSwiped) * 100).toInt();
        greenRatio.value = ((greenCount.value / totalSwiped) * 100).toInt();
      }
    }

    return true;
  }

  void shuffleCard() {
    learnCards.shuffle();
    learnCards.refresh();
  }

  void resetAll() {
    redCount.value = 0;
    greenCount.value = 0;
    totalCount.value = 1;
    percentComplete.value = 0;
    redRatio.value = 0;
    greenRatio.value = 0;
    wrongCards.clear();
    isReviewMode.value = false;
    currentCardIndex.value = 0;
    prepareSession();
    swiperKey.value = UniqueKey();
  }

  void prepareSession() {
    final cards = isReviewMode.value ? wrongCards : learnCards;
    sessionCards.assignAll(cards);
    sessionTotalCount.value = sessionCards.length;
    currentCardIndex.value = 0;
  }

  void speakCurrentCard() async {
    if (currentCardIndex.value < sessionCards.length) {
      final card = sessionCards[currentCardIndex.value];
      await tts.setLanguage(card.terminologyLanguage);
      await tts.speak(card.terminology);
    }
  }
  Future<void> createFlashcardSet() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Lỗi', 'Tiêu đề không được bỏ trống');
      return;
    }

    for (var draft in flashcardDrafts) {
      if (draft.terminologyController.text.trim().isEmpty ||
          draft.definitionController.text.trim().isEmpty) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng nhập đầy đủ thuật ngữ và định nghĩa cho tất cả các thẻ',
        );
        return;
      }
    }

    try {
      isLoading.value = true;
      final userId = _flashcardRepository.client.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Lỗi', 'Phiên đăng nhập hết hạn, vui lòng đăng nhập lại');
        return;
      }

      final newSet = await _flashcardRepository.createSet(
        title,
        isPublic: isPublic.value,
      );

      if (newSet != null && newSet.id != null) {
        final List<FlashCardModel> cardsToSave = flashcardDrafts.map((draft) {
          return FlashCardModel(
            setId: newSet.id!,
            userId: userId,
            terminology: draft.terminologyController.text.trim(),
            definition: draft.definitionController.text.trim(),
          );
        }).toList();

        final savedCards = await _flashcardRepository.addCards(cardsToSave);

        if (savedCards.isNotEmpty) {
          Get.back();
          Get.snackbar('Thành công', 'Đã tạo học phần thành công!');
        } else {
          Get.snackbar('Lỗi', 'Không thể lưu các thẻ bài');
        }
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCardInSet(FlashCardSetModel set) async {
    try {
      loading.value = true;
      cardInSet.clear();
      currentSet.value = set;
      final cards = await _flashcardRepository.getCardsInSet(set.id!);
      cardInSet.assignAll(cards);
      learnCards.assignAll(cards);
      sessionTotalCount.value = cards.length;
      resetAll();
    } catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      loading.value = false;
    }
  }

  void goToSetting() => Get.to(
    () => const CreateSetSettings(),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );

  void goToFlashcard(FlashCardSetModel selectedSet) => Get.to(
    () => LearnFlashcard(flashcardSet: selectedSet),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void onClose() {
    titleController.dispose();
    for (var draft in flashcardDrafts) {
      draft.dispose();
    }
    super.onClose();
  }
}

class SelectLanguage {
  final String id;
  final String title;

  SelectLanguage({required this.id, required this.title});

  static final List<SelectLanguage> selectLanguage = [
    SelectLanguage(id: 'vi', title: 'Tiếng Việt'),
    SelectLanguage(id: 'en', title: 'Tiếng Anh'),
    SelectLanguage(id: 'de', title: 'Tiếng Đức'),
  ];
}
