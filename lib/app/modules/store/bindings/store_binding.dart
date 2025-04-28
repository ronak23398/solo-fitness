// store_binding.dart
import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(() => StoreController());
  }
}