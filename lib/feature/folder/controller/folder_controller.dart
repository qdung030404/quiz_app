import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/folder_repository.dart';
import 'package:quiz_app/feature/folder/view/add_flash_cards_set_screen.dart';

import '../../../data/models/folder_model.dart';

class FolderController extends GetxController{
  final FolderRepository _folderRepository = FolderRepository();
  final titleController = TextEditingController();

  final Rx<FolderModel?> currentFolder = Rx<FolderModel?>(null);
  final RxList<FlashCardSetModel> setsInFolder = <FlashCardSetModel>[].obs;
  final RxBool loading = false.obs;
  final isLoading = false.obs;
  var isTitleValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(updateTitleValidStatus);
    //
  }

  void updateTitleValidStatus() {
    isTitleValid.value = titleController.text.isNotEmpty;
  }
  Future<void> createFolder() async{
    final title = titleController.text.trim();
    try{
      isLoading.value = true;
      final userId = _folderRepository.client.auth.currentUser?.id;
      if(userId == null){
        Get.snackbar('Lỗi', 'Phiên đăng nhập hết hạn, vui lòng đăng nhập lại');
        return;
      }

      final newFolder = await _folderRepository.createFolder(title);
      if (newFolder != null) {
        titleController.clear();
        Get.back();
        Get.snackbar('Thành công', 'Đã tạo thư mục "$title"');

      } else {
        Get.snackbar('Lỗi', 'Không thể tạo thư mục, vui lòng thử lại');
      }
    }catch (e){
      Get.snackbar('lỗi', '$e');
    }finally{
      isLoading.value = false;
    }
  }
  Future<void> loadFolder(FolderModel folder,) async {
    try{
      loading.value = true;
      setsInFolder.clear(); // Xóa dữ liệu cũ của folder trước đó
      currentFolder.value = folder;
      setsInFolder.value = await _folderRepository.getSetInFolder(folder.id!);
      print('Sets in folder: ${setsInFolder.length}');
    }catch (e){
      Get.snackbar('lỗi', '$e');
    }finally{
      loading.value = false;
    }
  }
  Future<void> addSetsToFolder(List<String> setIds) async {
    final folderId = currentFolder.value?.id;
    if (folderId == null) return;

    try {
      loading.value = true;
      bool success = await _folderRepository.addSetsToFolder(folderId, setIds);
      if (success) {
        await loadFolder(currentFolder.value!);
        Get.back();
        Get.snackbar('Thành công', 'Đã thêm học phần vào thư mục');
      }
    } catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      loading.value = false;
    }
  }
  void goToAddScreen() => Get.to(
        () => const AddFlashCardsSetScreen(),
    transition: Transition.downToUp,
    duration: const Duration(milliseconds: 300),
  );
}