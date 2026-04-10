import 'package:get/get.dart';

import 'package:quiz_app/data/repositories/profile_repository.dart';
import 'package:quiz_app/feature/setting/view/setting_screen.dart';

class ProfileController extends GetxController{
  final _profileRepository = ProfileRepository();

  // Streams or Observables for profile data
  Stream<List<Map<String, dynamic>>> getProfileStream() {
    return _profileRepository.watchCurrentUserProfile();
  }
  void goToSetting() => Get.to(() => const SettingScreen());
}