import 'package:get/get.dart';
import 'package:solo_fitness/app/modules/home/controller/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<HomeController>(() => HomeController());
  }
}