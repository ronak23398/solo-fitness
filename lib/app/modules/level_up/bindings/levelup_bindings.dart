// levelup_binding.dart
import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/level_up/controllers/levelup_controller.dart';

class LevelupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LevelupController>(() => LevelupController());
  }
}