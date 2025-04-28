import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}