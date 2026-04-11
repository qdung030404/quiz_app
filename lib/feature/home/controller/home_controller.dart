import 'package:get/get.dart';
import 'package:quiz_app/data/repositories/profile_repository.dart';
import 'package:quiz_app/feature/profile/view/profile_screen.dart';

class HomeController extends GetxController {
  final _profileRepository = ProfileRepository();
  late Stream<List<Map<String, dynamic>>> profileStream;

  @override
  void onInit() {
    super.onInit();
    _profileRepository.updateStreak();
    profileStream = _profileRepository.watchCurrentUserProfile();
  }

  void goToProfile() => Get.to(() => const ProfileScreen());
}
