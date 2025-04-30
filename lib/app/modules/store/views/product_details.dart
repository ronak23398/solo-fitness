// lib/app/modules/store/views/product_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';

class ProductDetailView extends GetView<StoreController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final product = controller.selectedProduct.value;
        
        if (product == null) {
          return const Center(child: Text('Product not found'));
        }
        
        return Container(
          decoration: const BoxDecoration(
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
          child: CustomScrollView(
            slivers: [
              // App bar with image slider
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF1A1A2E),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageSlider(product.imageUrls),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  // Admin edit button
                  Obx(() => controller.isAdmin.value
                      ? IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // Edit product functionality would go here
                            Get.snackbar(
                              'Info',
                              'Edit product feature coming soon!',
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                        )
                      : const SizedBox.shrink()),
                ],
              ),
              
              // Product details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name and category
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F3460),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Featured badge
                          if (product.featured)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4D73FF),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4D73FF).withOpacity(0.5),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Featured',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Product name
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Product rating
                      if (product.rating > 0)
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < product.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '(${product.reviewCount} reviews)',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Product price
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '₹',
                              style: TextStyle(
                                color: Color(0xFF4D73FF),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.price.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Stock information
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.stockQuantity > 0
                                ? 'In Stock (${product.stockQuantity} available)'
                                : 'Out of Stock',
                            style: TextStyle(
                              color: product.stockQuantity > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description header
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Description content
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Product attributes if any
                      if (product.attributes != null && product.attributes!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Specifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Attribute table
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: product.attributes!.length,
                                separatorBuilder: (context, index) => const Divider(
                                  height: 1,
                                  color: Colors.white10,
                                ),
                                itemBuilder: (context, index) {
                                  final entry = product.attributes!.entries.elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            entry.value.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 80), // Space for the CTA button
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      
      // Add to cart button
      bottomNavigationBar: Obx(() {
        final product = controller.selectedProduct.value;
        
        if (product == null) return const SizedBox.shrink();
        
        return Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A2E),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CustomButton(
            text: 'Add to Cart - ₹${product.price.toStringAsFixed(2)}',
            icon: Icons.shopping_cart,
            onPressed: product.stockQuantity > 0
                ? () {
                    // Add to cart functionality would go here
                    Get.snackbar(
                      'Added to Cart',
                      '${product.name} added to your cart',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                : null,
          ),
        );
      }),
    );
  }

  // Image slider for product images
  Widget _buildImageSlider(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Icon(
            Icons.image,
            color: Colors.white54,
            size: 80,
          ),
        ),
      );
    }
    
    if (imageUrls.length == 1) {
      return Image.network(
        imageUrls.first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.white54,
                size: 80,
              ),
            ),
          );
        },
      );
    }
    
    return PageView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return Image.network(
          imageUrls[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 80,
                ),
              ),
            );
          },
        );
      },
    );
  }
}