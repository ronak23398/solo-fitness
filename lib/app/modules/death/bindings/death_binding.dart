// death_binding.dart
import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/death/controllers/death_controller.dart';

class DeathBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeathController>(() => DeathController());
  }
}