import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';

class LibraryController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();

  final RxList<FlashCardSetModel> flashcardSet = <FlashCardSetModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFlashcardSet();
    //
  }

  Future<void> fetchFlashcardSet() async {
    try {
      isLoading.value = true;
      final result = await _flashcardRepository.getFlashCardSets();
      flashcardSet.assignAll(result);
    } catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      isLoading.value = false;
    }
  }
}
