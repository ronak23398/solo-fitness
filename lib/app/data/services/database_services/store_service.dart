// lib/app/data/services/store_service.dart

import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/product_model.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class StoreService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  // final SupabaseClient _supabase = Supabase.instance.client;
  final String _productsPath = 'products';
  final String _supabaseStorageBucket = 'product_images';
  final Uuid _uuid = Uuid();

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final DataSnapshot snapshot = await _database.ref(_productsPath).get();
      
      if (snapshot.value == null) return [];
      
      final Map<dynamic, dynamic> productsMap = 
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      
      return productsMap.entries.map((entry) {
        return Product.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final DataSnapshot snapshot = await _database
          .ref(_productsPath)
          .orderByChild('category')
          .equalTo(category)
          .get();
      
      if (snapshot.value == null) return [];
      
      final Map<dynamic, dynamic> productsMap = 
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      
      return productsMap.entries.map((entry) {
        return Product.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    } catch (e) {
      throw Exception('Failed to load products for category $category: $e');
    }
  }

  // Get a single product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      final DataSnapshot snapshot = 
          await _database.ref('$_productsPath/$productId').get();
      
      if (snapshot.value == null) return null;
      
      return Product.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>));
    } catch (e) {
      throw Exception('Failed to load product $productId: $e');
    }
  }

  // Upload product images to Supabase and return URLs
  // Future<List<String>> uploadProductImages(List<File> imageFiles) async {
  //   List<String> imageUrls = [];
    
  //   try {
  //     for (File file in imageFiles) {
  //       final String fileName = '${_uuid.v4()}${path.extension(file.path)}';
  //       final String filePath = '$_supabaseStorageBucket/$fileName';
        
  //       await _supabase.storage
  //           .from(_supabaseStorageBucket)
  //           .upload(fileName, file);
        
  //       final String imageUrl = _supabase.storage
  //           .from(_supabaseStorageBucket)
  //           .getPublicUrl(fileName);
        
  //       imageUrls.add(imageUrl);
  //     }
      
  //     return imageUrls;
  //   } catch (e) {
  //     throw Exception('Failed to upload product images: $e');
  //   }
  // }

  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      await _database
          .ref('$_productsPath/${product.id}')
          .set(product.toJson());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      await _database
          .ref('$_productsPath/${product.id}')
          .update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _database.ref('$_productsPath/$productId').remove();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Delete product image from Supabase
  // Future<void> deleteProductImage(String imageUrl) async {
  //   try {
  //     // Extract file name from the URL
  //     final Uri uri = Uri.parse(imageUrl);
  //     final String fileName = path.basename(uri.path);
      
  //     await _supabase.storage
  //         .from(_supabaseStorageBucket)
  //         .remove([fileName]);
  //   } catch (e) {
  //     throw Exception('Failed to delete product image: $e');
  //   }
  // }
}