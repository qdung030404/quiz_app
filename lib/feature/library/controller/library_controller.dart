import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/folder_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/data/repositories/folder_repository.dart';
import 'package:quiz_app/feature/flashcard_set/view/flashcard_set_detail_screen.dart';
import 'package:quiz_app/feature/folder/view/folder_detail_screen.dart';

class LibraryController extends GetxController {
  final FlashcardRepository _flashcardRepository = FlashcardRepository();
  final FolderRepository _folderRepository = FolderRepository();

  final RxList<FlashCardSetModel> flashcardSet = <FlashCardSetModel>[].obs;

  final RxList<FolderModel> folder = <FolderModel>[].obs;

  final selectedCategory = LibraryCategory.libraryCategories[0].obs;

  final isLoading = false.obs;

  int get totalCards => flashcardSet.fold(0, (sum, set) => sum + set.cardCount);

  @override
  void onInit() {
    super.onInit();
    fetchFlashcardSet();
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
  Future<void> removeFlashcardSet(int index) async {
    final deletedSet = flashcardSet[index];
    var isUndone = false;
    try {
      // Xóa tạm trên UI
      flashcardSet.removeAt(index);
      Get.snackbar(
        'Thông báo',
        'Đã xóa học phần ${deletedSet.title}',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () {
            isUndone = true;
            flashcardSet.insert(index, deletedSet);
            if (Get.isSnackbarOpen) Get.back();
          },
          child: const Text('Hoàn tác'),
        ),
        duration: const Duration(seconds: 4),
        snackbarStatus: (status) async {
          // Chỉ xóa trong DB khi Snackbar đóng hẳn và KHÔNG bấm hoàn tác
          if (status == SnackbarStatus.CLOSED && !isUndone) {
            final success = await _flashcardRepository.deleteSet(deletedSet.id!);
            if (!success) {
              // Nếu xóa trong DB thất bại, tự động khôi phục trên UI và báo lỗi
              flashcardSet.insert(index, deletedSet);
              Get.snackbar('Lỗi', 'Không thể xóa học phần khỏi máy chủ');
            }
          }
        },
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
    }
  }

  Future<void> removeFolder(int index) async {
    final deletedFolder = folder[index];
    bool isUndone = false;

    try {
      folder.removeAt(index);
      Get.snackbar(
        'Thông báo',
        'Đã xóa thư mục ${deletedFolder.title}',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () {
            isUndone = true;
            folder.insert(index, deletedFolder);
            if (Get.isSnackbarOpen) Get.back();
          },
          child: const Text('Hoàn tác'),
        ),
        duration: const Duration(seconds: 4),
        snackbarStatus: (status) async {
          if (status == SnackbarStatus.CLOSED && !isUndone) {
            final success = await _folderRepository.removeFolder(deletedFolder.id!);
            if (!success) {
              folder.insert(index, deletedFolder);
              Get.snackbar('Lỗi', 'Không thể xóa thư mục khỏi máy chủ');
            }
          }
        },
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
    }
  }

  void goToFolderDetail(FolderModel selectedFolder) => Get.to(() => FolderDetailScreen(folder: selectedFolder));
  void goToSetDetail(FlashCardSetModel selectedSet) => Get.to(() => FlashcardSetDetailScreen(flashcardSet: selectedSet));
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
