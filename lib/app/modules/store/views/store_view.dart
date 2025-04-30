import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';
import '../../../data/models/product_model.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hunter\'s Equipment Shop'),
        backgroundColor: const Color(0xFF1A1A2E), // Deep blue background
        elevation: 0,
        centerTitle: true,
        actions: [
          // Admin panel icon
          Obx(() => controller.isAdmin.value
              ? IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add New Product',
                  onPressed: () => _showAddProductDialog(context),
                )
              : IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  tooltip: 'Admin Access',
                  onPressed: () => _showAdminLoginDialog(context),
                )),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Solo Leveling inspired gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E), // Deep blue
              Color(0xFF16213E), // Darkish blue
              Color(0xFF0F3460), // Purple-blue
            ],
          ),
        ),
        child: Column(
          children: [
            // Category tabs
            _buildCategorySelector(),
            
            // Main product grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4D73FF), // Blue glow color
                    ),
                  );
                }
                
                if (controller.filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No items available in this category',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                
                return _buildProductGrid();
              }),
            ),
          ],
        ),
      ),
      // Admin floating action button
      floatingActionButton: Obx(() => controller.isAdmin.value
          ? FloatingActionButton(
              onPressed: () => _showAddProductDialog(context),
              backgroundColor: const Color(0xFF4D73FF), // Blue glow color
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink()),
    );
  }

  // Category selector widget
  Widget _buildCategorySelector() {
    final List<String> allCategories = ['All', ...ProductCategories.getAll()];
    
    return Container(
      height: 50,
      color: const Color(0xFF16213E).withOpacity(0.7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final String category = allCategories[index];
          
          return Obx(() {
            // Move the computation of isSelected inside the Obx to properly react to changes
            final bool isSelected = (category == 'All' && controller.selectedCategory.value.isEmpty) || 
                                 (category == controller.selectedCategory.value);
                                 
            return GestureDetector(
              onTap: () {
                controller.setCategory(category == 'All' ? '' : category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected
                      ? const Color(0xFF4D73FF) // Blue glow when selected
                      : Colors.black12,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4D73FF).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // Product grid widget
  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final Product product = controller.filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  // Product card widget
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => controller.viewProductDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFF4D73FF),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
              ),
            ),
            
            // Product info
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Product price
                  Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF4D73FF), // Blue glow color
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Category and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      
                      // Rating
                      if (product.rating > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Admin login dialog
  void _showAdminLoginDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Admin Access',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter admin password',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4D73FF)),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.adminLogin(passwordController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4D73FF),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  // Add product dialog
  void _showAddProductDialog(BuildContext context) {
    controller.resetForm();
    
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF16213E),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Product name
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D73FF)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Product description
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D73FF)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Product price
                TextField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (₹)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D73FF)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Stock quantity
                TextField(
                  controller: controller.stockQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D73FF)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                
                const SizedBox(height: 12),
                
                // Category dropdown
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedProductCategory.value,
                  items: ProductCategories.getAll().map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedProductCategory.value = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4D73FF)),
                    ),
                  ),
                  dropdownColor: Colors.white,
                )),
                
                const SizedBox(height: 12),
                
                // Featured product checkbox
                Obx(() => CheckboxListTile(
                      title: const Text(
                        'Featured Product',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: controller.isFeatured.value,
                      onChanged: (value) {
                        controller.isFeatured.value = value ?? false;
                      },
                      checkColor: Colors.white,
                      activeColor: const Color(0xFF4D73FF),
                    )),
                
                const SizedBox(height: 12),
                
                // Image picker
                const Text(
                  'Product Images',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Obx(() => controller.selectedImages.isEmpty
                    ? CustomButton(
                        text: 'Select Images',
                        icon: Icons.add_photo_alternate,
                        onPressed: controller.pickProductImages,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.selectedImages.length + 1,
                              itemBuilder: (context, index) {
                                if (index == controller.selectedImages.length) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: IconButton(
                                      onPressed: controller.pickProductImages,
                                      icon: const Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white70,
                                        size: 30,
                                      ),
                                    ),
                                  );
                                }
                                
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(
                                              controller.selectedImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => controller
                                          .removeSelectedImage(index),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4D73FF),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save Product'),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}