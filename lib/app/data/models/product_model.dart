// lib/app/data/models/product_model.dart

class Product {
  final String id;
  final String name;
  final String description;
  final double price; // in Indian Rupees
  final String category; // e.g. "T-Shirts", "Energy Bars", "Weights", etc.
  final List<String> imageUrls; // URLs from Supabase
  final int stockQuantity;
  final double rating; // Average rating (1-5)
  final int reviewCount; // Number of reviews
  final bool featured; // Featured products to show on top
  final Map<String, dynamic>? attributes; // For size, color, weight options etc.

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.stockQuantity,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.featured = false,
    this.attributes,
  });

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'featured': featured,
      'attributes': attributes,
    };
  }

  // Create Product object from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrls: List<String>.from(json['imageUrls']),
      stockQuantity: json['stockQuantity'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      featured: json['featured'] ?? false,
      attributes: json['attributes'],
    );
  }

  // Create a copy of Product with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    bool? featured,
    Map<String, dynamic>? attributes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      featured: featured ?? this.featured,
      attributes: attributes ?? this.attributes,
    );
  }
}

// Product categories
class ProductCategories {
  static const String tshirts = "T-Shirts";
  static const String energyBars = "Energy Bars";
  static const String weights = "Weights";
  static const String equipment = "Equipment";
  static const String supplements = "Supplements";
  static const String accessories = "Accessories";

  static List<String> getAll() {
    return [tshirts, energyBars, weights, equipment, supplements, accessories];
  }
}