part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final bool isActionInProgress;
  final String? error;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.isActionInProgress = false,
    this.error,
  });

  OrdersState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    bool? isActionInProgress,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, isActionInProgress, error];
}
