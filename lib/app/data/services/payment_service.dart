import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'auth_service.dart';

class PaymentService extends GetxService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final AuthService _authService = Get.find<AuthService>();
  
  RxBool isAvailable = false.obs;
  RxBool isPurchasePending = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    initStoreInfo();
    
    // Listen to purchase updates
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    purchaseUpdated.listen(_onPurchaseUpdate, onDone: () {
      print('Purchase stream done');
    }, onError: (error) {
      print('Error in purchase stream: $error');
    });
  }
  
  Future<void> initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    this.isAvailable.value = isAvailable;
    
    if (!isAvailable) {
      print('Store not available');
      return;
    }
    
    const ids = {
      'black_heart_1',
      'black_heart_3',
      'black_heart_5',
    };
    
    final ProductDetailsResponse response = 
        await _inAppPurchase.queryProductDetails(ids);
    
    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
    }
    
    if (response.productDetails.isEmpty) {
      print('No products found');
      return;
    }
    
    products.value = response.productDetails;
  }
  
  Future<void> buyBlackHeart(ProductDetails product) async {
    if (!isAvailable.value) {
      print('Store not available');
      return;
    }
    
    final userId = _authService.currentUser.value?.id;
    if (userId == null) {
      print('User not logged in');
      return;
    }
    
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
      applicationUserName: userId,
    );
    
    isPurchasePending.value = true;
    try {
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } catch (e) {
      print('Error buying product: $e');
      isPurchasePending.value = false;
    }
  }
  
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Purchase is pending
        isPurchasePending.value = true;
      } else {
        isPurchasePending.value = false;
        
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('Error purchasing: ${purchaseDetails.error?.message}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                  purchaseDetails.status == PurchaseStatus.restored) {
          // Purchase completed or restored
          await _deliverProduct(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          print('Purchase canceled');
        }
        
        // Complete the purchase regardless of the status
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
  
  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    // Extract product ID
    final productId = purchaseDetails.productID;
    
    // Add black hearts to user account based on product ID
    if (productId == 'black_heart_1') {
      await _authService.addBlackHeart(1);
    } else if (productId == 'black_heart_3') {
      await _authService.addBlackHeart(3);
    } else if (productId == 'black_heart_5') {
      await _authService.addBlackHeart(5);
    }
  }
  
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }
}