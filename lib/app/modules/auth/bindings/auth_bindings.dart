import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/database_service.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<DatabaseService>(() => DatabaseService(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    // Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    
    // Controllers
    Get.lazyPut<AuthController>(() => AuthController());
  }
}