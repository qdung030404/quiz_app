import 'package:get/get.dart';
import 'package:quiz_app/feature/flashcard_set/view/create_flashcard_set_screen.dart';
import 'package:quiz_app/feature/folder/view/create_folder_screen.dart';

class CreateController extends GetxController {
  void createSet() => Get.to(() => const CreateFlashcardSetScreen());

  void createFolder() => Get.to(() => const CreateFolderScreen());
}
