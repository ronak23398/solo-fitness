// lib/app/modules/store/views/add_product_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/models/product_model.dart';
import 'package:solo_fitness/app/data/widgets/image_upload_preview.dart';
import 'package:solo_fitness/app/modules/store/controller/store_controller.dart';

class AddProductView extends GetView<StoreController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              ImageUploadPreview(
                selectedImages: controller.selectedImages,
                onAddImages: controller.pickProductImages,
                onRemoveImage: controller.removeSelectedImage,
                isLoading: controller.isLoading.value,
              ),
              const SizedBox(height: 24),

              // Product Name
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name*',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Product Description
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description*',
                  hintText: 'Enter product description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Price and Stock Quantity (Row)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (₹)*',
                        hintText: '599.99',
                        border: OutlineInputBorder(),
                        prefixText: '₹',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: controller.stockQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'Stock Quantity*',
                        hintText: '100',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              const Text(
                'Category*',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Obx(
                  () => DropdownButton<String>(
                    value: controller.selectedProductCategory.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedProductCategory.value = value;
                      }
                    },
                    items: ProductCategories.getAll()
                        .map<DropdownMenuItem<String>>(
                      (String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    underline: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Featured Product Toggle
              Row(
                children: [
                  const Text('Featured Product'),
                  const Spacer(),
                  Switch(
                    value: controller.isFeatured.value,
                    onChanged: (value) {
                      controller.isFeatured.value = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Attributes Section
              const Text(
                'Product Attributes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Column(
                  children: [
                    // Display existing attributes
                    if (controller.attributes.isNotEmpty)
                      ...controller.attributes.entries.map(
                        (entry) => ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value.toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                controller.removeAttribute(entry.key),
                          ),
                        ),
                      ),
                    // Add new attribute button
                    ElevatedButton.icon(
                      onPressed: () => _showAddAttributeDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Attribute'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveProduct,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('SAVE PRODUCT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAttributeDialog(BuildContext context) {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController valueController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Attribute'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Attribute Name',
                hintText: 'Size, Color, Material, etc.',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Attribute Value',
                hintText: 'S,M,L or Red,Blue, etc.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                controller.addAttribute(
                    keyController.text, valueController.text);
                Get.back();
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}