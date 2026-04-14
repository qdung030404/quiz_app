import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/folder_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/data/repositories/folder_repository.dart';
import 'package:quiz_app/feature/folder/view/folder_detail_screen.dart';

class LibraryController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();
  final FolderRepository _folderRepository = FolderRepository();

  final RxList<FlashCardSetModel> flashcardSet = <FlashCardSetModel>[].obs;

  final RxList<FolderModel> folder = <FolderModel>[].obs;

  final selectedCategory = LibraryCategory.libraryCategories[0].obs;

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

  Future<void> fetchFolder() async {
    try {
      isLoading.value = true;
      final result = await _folderRepository.getFolder();
      folder.assignAll(result);
    } catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(LibraryCategory category) {
    // Kiểm tra trước khi gán để tránh return sớm
    if (selectedCategory.value.id == category.id) return;

    selectedCategory.value = category;

    if (category.id == 'flashcard_set') {
      fetchFlashcardSet();
    } else if (category.id == 'folder') {
      fetchFolder();
    }
  }
  void goToFolderDetail(FolderModel selectedFolder) => Get.to(() => FolderDetailScreen(folder: selectedFolder));
}

class LibraryCategory {
  final String id;
  final String title;

  LibraryCategory({required this.id, required this.title});

  static final List<LibraryCategory> libraryCategories = [
    LibraryCategory(id: 'flashcard_set', title: 'Học phần'),
    LibraryCategory(id: 'folder', title: 'Thư mục'),
  ];
}
