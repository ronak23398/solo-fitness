// lib/app/modules/store/controllers/store_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solo_fitness/app/data/services/database_services/store_service.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_routes.dart';

class StoreController extends GetxController {
  final StoreService storeService;
  StoreController({required this.storeService});

  // Observables
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAdmin = false.obs; // To control admin features visibility
  
  // For product details view
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  
  // For add/edit product form
  final RxList<File> selectedImages = <File>[].obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final RxString selectedProductCategory = ProductCategories.tshirts.obs;
  final RxBool isFeatured = false.obs;
  final RxMap<String, dynamic> attributes = <String, dynamic>{}.obs;
  
  // For admin access (simplified for this example)
  final String adminPassword = 'hunter123'; // In a real app, use proper authentication
  
  @override
  void onInit() {
    super.onInit();
    loadAllProducts();
    
    // Initialize categories list
    selectedCategory.value = ''; // Empty means "All Categories"
  }
  
  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockQuantityController.dispose();
    super.onClose();
  }

  // Load all products from Firebase
  Future<void> loadAllProducts() async {
    try {
      isLoading.value = true;
      allProducts.value = await storeService.getAllProducts();
      filterProducts();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Filter products by selected category
  void filterProducts() {
    if (selectedCategory.value.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }
  }

  // Set selected category and filter products
  void setCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  // Navigate to product details
  void viewProductDetails(Product product) {
    selectedProduct.value = product;
    Get.toNamed(AppRoutes.PRODUCT_DETAIL);
  }

  // Admin login
  void adminLogin(String password) {
    if (password == adminPassword) {
      isAdmin.value = true;
      Get.back();
      Get.snackbar(
        'Success',
        'Admin access granted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Invalid admin password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick images for product
  Future<void> pickProductImages() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        for (var image in images) {
          selectedImages.add(File(image.path));
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove selected image
  void removeSelectedImage(int index) {
    if (index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Reset form fields
  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    stockQuantityController.clear();
    selectedProductCategory.value = ProductCategories.tshirts;
    selectedImages.clear();
    isFeatured.value = false;
    attributes.clear();
  }

  // Add or update product
  Future<void> saveProduct() async {
    try {
      if (nameController.text.isEmpty || 
          descriptionController.text.isEmpty ||
          priceController.text.isEmpty ||
          stockQuantityController.text.isEmpty) {
        throw Exception('Please fill all required fields');
      }

      isLoading.value = true;

      // Upload images to Supabase if any are selected
      List<String> imageUrls = [];
      if (selectedImages.isNotEmpty) {
        imageUrls = await storeService.uploadProductImages(selectedImages);
      }

      // Create product object
      final String productId = const Uuid().v4();
      final Product newProduct = Product(
        id: productId,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        category: selectedProductCategory.value,
        imageUrls: imageUrls,
        stockQuantity: int.parse(stockQuantityController.text),
        featured: isFeatured.value,
        attributes: attributes.isEmpty ? null : attributes,
      );

      // Save to Firebase
      await storeService.addProduct(newProduct);

      // Reset form and reload products
      resetForm();
      await loadAllProducts();
      
      isLoading.value = false;
      
      Get.back(); // Close the add/edit form
      Get.snackbar(
        'Success',
        'Product saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add attribute like size or color
  void addAttribute(String key, dynamic value) {
    attributes[key] = value;
    attributes.refresh();
  }

  // Remove attribute
  void removeAttribute(String key) {
    attributes.remove(key);
    attributes.refresh();
  }
}