import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/database_service.dart';
import 'user_service.dart';
import 'task_service.dart';
import 'streak_service.dart';
import 'store_service.dart';
import 'firebase_task_upload_service.dart';

/// Service binding for initializing all services
class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Register main database service
    Get.put<DatabaseService>(DatabaseService(), permanent: true);
    
    // For direct access to individual services if needed
    Get.put<UserService>(Get.find<DatabaseService>().userService, permanent: true);
    Get.put<TaskService>(Get.find<DatabaseService>().taskService, permanent: true);
    Get.put<StreakService>(Get.find<DatabaseService>().streakService, permanent: true);
    Get.put<StoreService>(Get.find<DatabaseService>().storeService, permanent: true);
    
    // Register task upload service
    Get.put<FirebaseTaskUploadService>(FirebaseTaskUploadService(), permanent: true);
  }
}