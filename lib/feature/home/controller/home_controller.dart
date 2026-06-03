import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/data/models/public_folder_model.dart';
import 'package:quiz_app/data/models/public_set_model.dart';
import 'package:quiz_app/data/repositories/flashcard_repository.dart';
import 'package:quiz_app/data/repositories/profile_repository.dart';
import 'package:quiz_app/data/repositories/public_repository.dart';
import 'package:quiz_app/feature/bottom_navigation_bar/controller/nav_controller.dart';
import 'package:quiz_app/feature/home/view/public_flashcard_set_list.dart';
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
  final RxList<PublicFolderModel> publicFolder = <PublicFolderModel>[].obs;
  final RxList<PublicSetModel> publicSet = <PublicSetModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _profileRepository.updateStreak();
    profileStream = _profileRepository.watchCurrentUserProfile();
    fetchFlashcardSets();
    fetchPublicFolders();
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
  Future<void> fetchPublicFolders() async {
    try {
      isLoading(true);
      final folders = await _publicRepository.getPublicFolders();
      publicFolder.assignAll(folders);
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

  void goToFlashcardDetailFromPublic(PublicSetModel publicSet) {
    print('DEBUG: Public Set "${publicSet.title}" có ${publicSet.totalCards} thẻ.');
    if (publicSet.cards != null) {
      print('DEBUG: Danh sách cards thực tế: ${publicSet.cards!.length}');
    }

    final set = FlashCardSetModel(
      id: publicSet.id,
      title: publicSet.title,
      cardCount: publicSet.totalCards,
      isPublic: true,
    );
    Get.to(() => FlashcardSetDetailScreen(flashcardSet: set));
  }

  void goToListSetInPublicFolder(PublicFolderModel folder) {
    Get.to(() => PublicFlashcardSetList(
          folders: [folder],
          sets: publicSet.where((s) => s.publicFolderId == folder.id).toList(),
        ));
  }
}
