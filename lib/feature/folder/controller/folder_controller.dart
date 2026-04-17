import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/repositories/folder_repository.dart';
import 'package:quiz_app/feature/folder/view/add_flash_cards_set_screen.dart';
import 'package:quiz_app/feature/folder/view/edit_folder_screen.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';

import '../../../data/models/folder_model.dart';

class FolderController extends GetxController{
  final FolderRepository _folderRepository = FolderRepository();
  final titleController = TextEditingController();

  final Rx<FolderModel?> currentFolder = Rx<FolderModel?>(null);
  final RxList<FlashCardSetModel> setsInFolder = <FlashCardSetModel>[].obs;
  final RxBool loading = false.obs;
  final isLoading = false.obs;
  var isTitleValid = false.obs;
  late final _folderId = currentFolder.value?.id;

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

    if (_folderId == null) return;

    try {
      loading.value = true;
      bool success = await _folderRepository.addSetsToFolder(_folderId, setIds);
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
  Future<void> deleteFolder() async{
    if(_folderId == null) return;
    try{
      loading.value = true;
      bool success = await _folderRepository.removeFolder(_folderId);
      if (success) {
        if(Get.isRegistered<LibraryController>()){
          Get.find<LibraryController>().fetchFolder();
        }
        Get.back();
        Get.back();
        Get.snackbar('Thành công', 'Đã xóa thư mục ${currentFolder.value?.title}');
      }
    }catch (e) {
      Get.snackbar('lỗi', '$e');
    } finally {
      loading.value = false;
    }
  }
  Future<void> editFolder() async{
    final folderId = currentFolder.value?.id;
    if(folderId == null) return;
    
    final title = titleController.text.trim();
    if(title.isEmpty) return;
    
    try{
      loading.value = true;
      final editedFolder = await _folderRepository.updateFolder(folderId, title);
      
      if(editedFolder != null){
        currentFolder.value = editedFolder;

        if(Get.isRegistered<LibraryController>()){
          Get.find<LibraryController>().fetchFolder();
        }
        
        Get.back();
        Get.back();
        Get.snackbar('Thành công', 'Tên thư mục đổi thành: $title');
      } else {
        Get.snackbar('Lỗi', 'Không thể đổi tên thư mục. Vui lòng thử lại.');
      }
    } catch (e) {
      Get.snackbar('Lỗi', '$e');
    } finally {
      loading.value = false;
    }
  }
  void goToAddScreen() => Get.to(
        () => const AddFlashCardsSetScreen(),
    transition: Transition.downToUp,
    duration: const Duration(milliseconds: 300),
  );
  void goToEditScreen() => Get.to(
        () => const EditFolderScreen(),
    transition: Transition.leftToRight,
    duration: const Duration(milliseconds: 300),
  );
}