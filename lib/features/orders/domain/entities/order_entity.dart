import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String orderCode;
  final String? userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String? shippingAddress;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.orderCode,
    this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.shippingAddress,
    this.phone,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderCode,
        userId,
        items,
        totalAmount,
        status,
        paymentMethod,
        shippingAddress,
        phone,
        latitude,
        longitude,
        createdAt,
      ];
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String? productIcon;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    this.productIcon,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, productName, productIcon, quantity, price];
}
