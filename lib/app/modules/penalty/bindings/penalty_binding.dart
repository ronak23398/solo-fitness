// penalty_binding.dart
import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/penalty/controller/penalty_controller.dart';

class PenaltyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenaltyController>(() => PenaltyController());
  }
}