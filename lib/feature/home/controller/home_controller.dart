import 'package:get/get.dart';
import '../../intro/view/intro.dart';
import '../../../core/service/auth_service.dart';
import '../../../data/repositories/profile_repository.dart';

class HomeController extends GetxController {
  final _profileRepository = ProfileRepository();
  final _authService = AuthService();

  // Streams or Observables for profile data
  Stream<List<Map<String, dynamic>>> getProfileStream() {
    return _profileRepository.watchCurrentUserProfile();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAll(() => const Intro());
  }
}
