import 'package:get/get.dart';
import 'package:quiz_app/feature/flashcard_set/view/create_flashcard_set_screen.dart';

class CreateController extends GetxController{
  void createSet() => Get.to(() => const CreateFlashcardSetScreen());
}