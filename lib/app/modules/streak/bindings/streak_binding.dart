// streak_binding.dart
import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/streak/controller/streak_controller.dart';

class StreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StreakController>(() => StreakController());
  }
}