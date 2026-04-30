import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/public_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/data/repositories/profile_repository.dart';
import 'package:quiz_app/data/repositories/public_repository.dart';
import 'package:quiz_app/feature/bottom_navigation_bar/controller/nav_controller.dart';
import 'package:quiz_app/feature/library/view/library_screen.dart';
import 'package:quiz_app/feature/profile/view/profile_screen.dart';

import '../../flashcard_set/view/flashcard_set_detail_screen.dart';
import '../../library/controller/library_controller.dart';

class HomeController extends GetxController {
  final _profileRepository = ProfileRepository();
  final _flashcardRepository = FlashcardRepository();
  final _publicRepository = PublicRepository();
  final controller = Get.put(LibraryController());
  
  late Stream<List<Map<String, dynamic>>> profileStream;
  var flashcardSets = <FlashCardSetModel>[].obs;
  final RxList<PublicSetModel> publicSet = <PublicSetModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _profileRepository.updateStreak();
    profileStream = _profileRepository.watchCurrentUserProfile();
    fetchFlashcardSets();
    fetchPublicSets();
  }

  Future<void> fetchFlashcardSets() async {
    try {
      isLoading(true);
      final sets = await _flashcardRepository.getFlashCardSets();
      flashcardSets.assignAll(sets);
    } finally {
      isLoading(false);
    }
  }
  Future<void> fetchPublicSets() async {
    try {
      isLoading(true);
      final sets = await _publicRepository.getPublicSets();
      publicSet.assignAll(sets);
    } finally {
      isLoading(false);
    }
  }

  int get totalCards => controller.flashcardSet.fold(0, (sum, set) => sum + set.cardCount);
  int get totalSets => controller.flashcardSet.length;
  void goToProfile() => Get.to(() => const ProfileScreen());
  void navigateToLib() {
    Get.until((route) => route.isFirst);
    Get.find<NavController>().navIndex.value = 2;
    Get.find<LibraryController>().changeCategory(LibraryCategory.libraryCategories[0]);
  }
  void goToFlashcardDetail(FlashCardSetModel set) {
    Get.to(() => FlashcardSetDetailScreen(flashcardSet: set));
  }
}
