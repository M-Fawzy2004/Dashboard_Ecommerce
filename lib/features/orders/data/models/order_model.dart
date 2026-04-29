import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderCode,
    super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.paymentMethod,
    super.shippingAddress,
    super.phone,
    super.latitude,
    super.longitude,
    required super.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['id'] ?? '').toString(),
      orderCode: (map['order_code'] ?? 'N/A').toString(),
      userId: map['user_id']?.toString(),
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (map['total_amount'] ?? 0).toDouble(),
      status: (map['status'] ?? 'pending').toString(),
      paymentMethod: (map['payment_method'] ?? 'cash').toString(),
      shippingAddress: map['shipping_address']?.toString(),
      phone: map['phone']?.toString(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString()) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'items': items.map((e) => (e as OrderItemModel).toMap()).toList(),
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    super.productIcon,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: (map['product_id'] ?? map['id'] ?? '').toString(),
      productName: (map['product_name'] ?? map['name'] ?? 'Unknown Product').toString(),
      productIcon: map['product_icon']?.toString(),
      quantity: (map['quantity'] ?? 1) as int,
      price: (map['price'] ?? map['total_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_icon': productIcon,
      'quantity': quantity,
      'price': price,
    };
  }
}
