import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/service/gemini_service.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/feature/flashcard_set/view/create_set_settings.dart';

class FlashCardDraft {
  final TextEditingController terminologyController;
  final TextEditingController definitionController;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isGenerating = false.obs;

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

class CreateFlashcardController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();
  final GeminiService _geminiService = GeminiService();

  final TextEditingController titleController = TextEditingController();
  final RxList<FlashCardDraft> flashcardDrafts = <FlashCardDraft>[].obs;

  // Key điều khiển AnimatedList
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final terminologyLanguage = Rxn<SelectLanguage>();
  final definitionLanguage = Rxn<SelectLanguage>();
  final RxBool isPublic = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSwitched = true.obs;
  Timer? _debounce;

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
  void toggleSwitch(bool value) {
    isSwitched.value = value;
  }
  void onTerminologyChanged(int index, String value) {
    if (!isSwitched.value || value.trim().isEmpty) return;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1500), () {
      autoFillDefinition(index);
    });
  }

  Future<void> autoFillDefinition(int index) async {
    final draft = flashcardDrafts[index];
    final term = draft.terminologyController.text.trim();
    if (term.isEmpty) return;

    try {
      draft.isGenerating.value = true;
      final termLang = terminologyLanguage.value?.title ?? 'English';
      final defLang = definitionLanguage.value?.title ?? 'Vietnamese';

      final result = await _geminiService.generateDefinitions(
        word: term,
        terminologyLanguage: termLang,
        definitionLanguage: defLang,
      );

      if (result != null) {
        String rawDefinitions = result.contains(':')
            ? result.split(':').last
            : result;

        List<String> parsedList = rawDefinitions
            .split(',')
            .map((e) => e.trim())
            .take(3)
            .toList();

        draft.suggestions.assignAll(parsedList);
      }
    } catch (e) {
      print('Error auto-filling definition: $e');
    } finally {
      draft.isGenerating.value = false;
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
            // Thêm ngôn ngữ nếu model hỗ trợ
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

  void goToSetting() => Get.to(
    () => const CreateSetSettings(),
    transition: Transition.fadeIn,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void onClose() {
    _debounce?.cancel();
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
