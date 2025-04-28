enum ProductCategory { tshirt, shirt, hoodie, pajama, other }

class ProductModel {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  List<String> sizes;
  List<String> colors;
  ProductCategory category;
  bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.colors,
    required this.category,
    this.isAvailable = true,
  });

  // Convert Product to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'colors': colors,
      'category': category.toString().split('.').last,
      'isAvailable': isAvailable,
    };
  }

  // Create from Firebase map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'],
      sizes: List<String>.from(map['sizes']),
      colors: List<String>.from(map['colors']),
      category: _categoryFromString(map['category']),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  static ProductCategory _categoryFromString(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ProductCategory.other,
    );
  }
}

class OrderModel {
  String id;
  String userId;
  List<OrderItem> items;
  double totalAmount;
  String deliveryAddress;
  String contactNumber;
  DateTime orderDate;
  String status; // pending, confirmed, shipped, delivered

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.contactNumber,
    DateTime? orderDate,
    this.status = 'pending',
  }) : orderDate = orderDate ?? DateTime.now();

  // Convert Order to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'contactNumber': contactNumber,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'status': status,
    };
  }

  // Create from Firebase map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['userId'],
      items: (map['items'] as List).map((item) => OrderItem.fromMap(item)).toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      deliveryAddress: map['deliveryAddress'],
      contactNumber: map['contactNumber'],
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
      status: map['status'] ?? 'pending',
    );
  }
}

class OrderItem {
  String productId;
  String productName;
  double price;
  int quantity;
  String size;
  String color;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
  });

  // Convert OrderItem to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  // Create from Firebase map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      size: map['size'],
      color: map['color'],
    );
  }
}