// lib/app/modules/store/bindings/store_binding.dart

import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/database_services/store_service.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    // Inject the StoreService
    Get.lazyPut<StoreService>(() => StoreService());
    
    // Inject the StoreController with StoreService dependency
    Get.lazyPut<StoreController>(
      () => StoreController(storeService: Get.find<StoreService>()),
    );
  }
}