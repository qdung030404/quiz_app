import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';

class FlashCardDraft {
  final TextEditingController terminologyController;
  final TextEditingController definitionController;

  FlashCardDraft({
    TextEditingController? term,
    TextEditingController? definition,
  }) : terminologyController = term ?? TextEditingController(),
       definitionController = definition ?? TextEditingController();
  void dispose(){
    terminologyController.dispose();
    definitionController.dispose();
  }
}

class FlashcardController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();

  final TextEditingController titleController = TextEditingController();

  final RxList<FlashCardDraft> flashcardDrafts = <FlashCardDraft>[].obs;

  final isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    
    addEmptyCard();
    addEmptyCard();
  }

  void addEmptyCard() {
    flashcardDrafts.add(FlashCardDraft());
  }
  void removeCard(int index) {
    if (flashcardDrafts.length > 2) {
      flashcardDrafts[index].dispose();
      flashcardDrafts.removeAt(index);
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
    
    // Kiểm tra dữ liệu hợp lệ cho tất cả các thẻ
    for (var draft in flashcardDrafts) {
      if (draft.terminologyController.text.trim().isEmpty || 
          draft.definitionController.text.trim().isEmpty) {
        Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thuật ngữ và định nghĩa cho tất cả các thẻ');
        return;
      }
    }

    try {
      isLoading.value = true;

      // Lấy userId hiện tại
      final userId = _flashcardRepository.client.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar('Lỗi', 'Phiên đăng nhập hết hạn, vui lòng đăng nhập lại');
        return;
      }
      
      // 1. Tạo Bộ thẻ (Set)
      final newSet = await _flashcardRepository.createSet(title);
      
      if (newSet != null && newSet.id != null) {
        // 2. Chuyển đổi Draft sang Model và truyền userId vào từng thẻ
        final List<FlashCardModel> cardsToSave = flashcardDrafts.map((draft) {
          return FlashCardModel(
            setId: newSet.id!,
            userId: userId, // Đã thêm userId ở đây
            terminology: draft.terminologyController.text.trim(),
            definition: draft.definitionController.text.trim(),
          );
        }).toList();

        // 3. Lưu toàn bộ thẻ bài hàng loạt và nhận kết quả trả về
        final savedCards = await _flashcardRepository.addCards(cardsToSave);

        if (savedCards.isNotEmpty) {
          Get.back(); // Quay lại màn hình trước đó
          Get.snackbar('Thành công', 'Đã tạo học phần và ${savedCards.length} thẻ bài thành công!');
        } else {
          Get.snackbar('Lỗi', 'Không thể lưu các thẻ bài, vui lòng kiểm tra lại dữ liệu');
        }
      } else {
        Get.snackbar('Lỗi', 'Không thể tạo bộ thẻ, vui lòng thử lại');
      }
    } catch (e) {
      print('❌ Error in createFlashcardSet: $e');
      Get.snackbar('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại sau');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    for (var draft in flashcardDrafts) {
      draft.dispose();
    }
    super.onClose();
  }
}
