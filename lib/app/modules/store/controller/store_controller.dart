// store_controller.dart
import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/payment_service.dart';

class StoreController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final PaymentService _paymentService = Get.find<PaymentService>();
  
  final RxList<ProductModel> storeItems = <ProductModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadStoreItems();
  }
  
  Future<void> _loadStoreItems() async {
    try {
      isLoading.value = true;
      storeItems.value = await _databaseService.getStoreItems();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load store items: ${e.toString()}');
    }
  }
  
  void filterByCategory(String category) {
    selectedCategory.value = category;
  }
  
  List<ProductModel> get filteredItems {
    if (selectedCategory.value == 'All') {
      return storeItems;
    } else {
      return storeItems.where((item) => item.category == selectedCategory.value).toList();
    }
  }
  
  Future<void> purchaseItem(ProductModel item) async {
    try {
      // bool success = await _paymentService.processItemPurchase(item);
      
      // if (success) {
      //   Get.snackbar(
      //     'Purchase Successful',
      //     'Thank you for your purchase! Your order for ${item.name} has been placed.'
      //   );
      // } else {
      //   Get.snackbar(
      //     'Purchase Failed',
      //     'Unable to complete your purchase. Please try again.'
      //   );
      // }
    } catch (e) {
      Get.snackbar('Error', 'Failed to process purchase: ${e.toString()}');
    }
  }
  
  List<String> getAllCategories() {
    Set<String> categories = {'All'};
    for (var item in storeItems) {
      categories.add(item.category as String);
    }
    return categories.toList();
  }
  
  Future<void> refreshStore() async {
    await _loadStoreItems();
  }
}