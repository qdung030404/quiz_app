import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/feature/flashcard_set/widget/create_set_settings.dart';

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
  
  // Key điều khiển AnimatedList
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  
  final terminologyLanguage = Rxn<SelectLanguage>();
  final definitionLanguage = Rxn<SelectLanguage>();

  final RxBool loading = false.obs;
  final isLoading = false.obs;

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

  void removeCard(int index, Widget Function(BuildContext, Animation<double>) removedItemBuilder) {
    if (flashcardDrafts.length > 2) {
      final removedItem = flashcardDrafts[index];
      
      listKey.currentState?.removeItem(
        index,
        (context, animation) => removedItemBuilder(context, animation),
        duration: const Duration(milliseconds: 300),
      );

      flashcardDrafts.removeAt(index);
      Future.delayed(const Duration(milliseconds: 400), () => removedItem.dispose());
    } else {
      Get.snackbar('Thông báo', 'Bộ thẻ cần tối thiểu 2 thẻ bài');
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

      final newSet = await _flashcardRepository.createSet(title);

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

  Future<void> loadCardInSet(FlashCardSetModel set)async {
    try{
      loading.value = true;
      cardInSet.clear();
      currentSet.value = set;
      cardInSet.value = await _flashcardRepository.getCardsInSet(set.id!);
    }catch (e){
      Get.snackbar('lỗi', '$e');
    }finally{
      loading.value = false;
    }
  }
  void goToSetting() => Get.to(
        () => const CreateSetSettings(),
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
