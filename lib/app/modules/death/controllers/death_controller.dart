// death_controller.dart
import 'package:get/get.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/payment_service.dart';

class DeathController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final PaymentService _paymentService = Get.find<PaymentService>();
  
  final RxBool isProcessing = false.obs;
  
  Future<void> useBlackHeart() async {
    try {
      isProcessing.value = true;
      
      // // Process payment for black heart
      // bool paymentSuccess = await _paymentService.buyBlackHeart();
      
      // if (paymentSuccess) {
      //   // Revive user
      //   await _databaseService.reviveUser();
      //   Get.offAllNamed('/home');
      //   Get.snackbar('Success', 'You have been revived using a Black Heart!');
      // } else {
      //   Get.snackbar('Payment Failed', 'Unable to process your Black Heart purchase.');
      // }
      
      isProcessing.value = false;
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar('Error', 'Failed to use Black Heart: ${e.toString()}');
    }
  }
  
  Future<void> resetProgress() async {
    try {
      isProcessing.value = true;
      
      // Reset user to level 1
      // await _databaseService.resetUserProgress();
      
      Get.offAllNamed('/home');
      Get.snackbar('Reset Complete', 'Your journey begins anew, Hunter.');
      
      isProcessing.value = false;
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar('Error', 'Failed to reset progress: ${e.toString()}');
    }
  }
}