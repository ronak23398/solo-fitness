// lib/app/data/services/store_service.dart

import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/product_model.dart';
import 'package:solo_fitness/app/data/services/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class StoreService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final SupabaseClient _supabase = SupabaseConfig.client;
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
  Future<List<String>> uploadProductImages(List<File> imageFiles) async {
  List<String> imageUrls = [];
  
  try {
    for (File file in imageFiles) {
      // Generate unique filename
      final String fileName = '${_uuid.v4()}${path.extension(file.path)}';
      
      // Detect mime type for proper content-type
      final String? mimeType = lookupMimeType(file.path);
      
      print('Uploading file: $fileName with mime type: $mimeType');
      
      // Read file as bytes for better upload stability
      final bytes = await file.readAsBytes();
      
      try {
        // Upload file to Supabase with metadata
        await _supabase.storage
            .from(_supabaseStorageBucket)
            .uploadBinary(
              fileName, 
              bytes,
              fileOptions: FileOptions(
                contentType: mimeType ?? 'application/octet-stream',
                cacheControl: '3600',
              ),
            );
        
        // Get the public URL for the uploaded file
        final String imageUrl = _supabase.storage
            .from(_supabaseStorageBucket)
            .getPublicUrl(fileName);
        
        imageUrls.add(imageUrl);
        print('Successfully uploaded: $fileName');
      } catch (uploadError) {
        print('Error uploading individual file: $uploadError');
        // Continue with other files instead of failing completely
      }
    }
    
    return imageUrls;
  } catch (e) {
    print('Upload error details: $e');
    throw Exception('Failed to upload product images: $e');
  }
}

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

  // Delete a product and its associated images
  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // First delete all product images from Supabase
      for (String imageUrl in imageUrls) {
        await deleteProductImage(imageUrl);
      }
      
      // Then delete the product from Firebase
      await _database.ref('$_productsPath/$productId').remove();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Delete product image from Supabase
  Future<void> deleteProductImage(String imageUrl) async {
    try {
      // Extract file name from the URL
      final Uri uri = Uri.parse(imageUrl);
      final String fileName = path.basename(uri.path);
      
      await _supabase.storage
          .from(_supabaseStorageBucket)
          .remove([fileName]);
    } catch (e) {
      throw Exception('Failed to delete product image: $e');
    }
  }
  
  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final DataSnapshot snapshot = await _database
          .ref(_productsPath)
          .orderByChild('featured')
          .equalTo(true)
          .get();
      
      if (snapshot.value == null) return [];
      
      final Map<dynamic, dynamic> productsMap = 
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      
      return productsMap.entries.map((entry) {
        return Product.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    } catch (e) {
      throw Exception('Failed to load featured products: $e');
    }
  }
}