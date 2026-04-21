part of 'products_cubit.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.items = const [],
    this.actionInProgress = false,
    this.error,
  });

  final ProductsStatus status;
  final List<ProductEntity> items;
  final bool actionInProgress;
  final String? error;

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? items,
    bool? actionInProgress,
    String? error,
  }) {
    return ProductsState(
      status: status ?? this.status,
      items: items ?? this.items,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, actionInProgress, error];
}
