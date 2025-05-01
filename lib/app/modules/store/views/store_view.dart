// lib/app/modules/store/views/store_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';
import 'package:solo_fitness/app/routes/app_routes.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isAdmin.value
                    ? Icons.admin_panel_settings
                    : Icons.lock,
                color: controller.isAdmin.value ? Colors.green : null,
              ),
              onPressed: () {
                if (!controller.isAdmin.value) {
                  _showAdminLoginDialog();
                } else {
                  // Already admin, show admin actions
                  _showAdminActions();
                }
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadAllProducts,
        child: Column(
          children: [
            // Categories Horizontal Scroll
            _buildCategoryFilter(),

            // Products Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.selectedCategory.value.isEmpty
                              ? 'No products available'
                              : 'No products in ${controller.selectedCategory.value}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () =>
            controller.isAdmin.value
                ? FloatingActionButton(
                  onPressed: () {
                    controller.resetForm();
                    Get.toNamed(
                      AppRoutes.ADD_PRODUCT,
                    ); // Use the constant instead of the string
                  },
                  child: const Icon(Icons.add),
                )
                : const SizedBox(),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: [
            // All Categories option
            _buildCategoryChip('All', ''),
            const SizedBox(width: 8),
            // Specific Categories
            ...ProductCategories.getAll().map((category) {
              return Row(
                children: [
                  _buildCategoryChip(category, category),
                  const SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = controller.selectedCategory.value == value;

    return GestureDetector(
      onTap: () => controller.setCategory(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => controller.viewProductDetails(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      color: Colors.grey.shade100,
                    ),
                    child:
                        product.imageUrls.isNotEmpty
                            ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrls.first,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                    ),
                              ),
                            )
                            : Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                            ),
                  ),
                ),
                if (product.featured)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                if (product.stockQuantity <= 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.rating > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product.rating.floor()
                                  ? Icons.star
                                  : (index < product.rating.ceil() &&
                                      product.rating.floor() !=
                                          product.rating.ceil())
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminLoginDialog() {
    final TextEditingController passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Admin Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter admin password to access admin features.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              controller.adminLogin(passwordController.text);
            },
            child: const Text('LOGIN'),
          ),
        ],
      ),
    );
  }

  void _showAdminActions() {
    Get.bottomSheet(
      Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add New Product'),
            onTap: () {
              Get.back();
              controller.resetForm();
              Get.toNamed(AppRoutes.ADD_PRODUCT);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Exit Admin Mode'),
            onTap: () {
              Get.back();
              controller.isAdmin.value = false;
              Get.snackbar(
                'Success',
                'Exited admin mode',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
