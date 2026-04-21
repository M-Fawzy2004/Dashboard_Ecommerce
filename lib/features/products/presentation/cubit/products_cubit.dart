import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/products_remote_data_source.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({ProductsRepository? repository})
      : _repository = repository ??
            ProductsRepositoryImpl(ProductsRemoteDataSourceImpl()),
        super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, error: null));
    final result = await _repository.getProducts();
    result.fold(
      (failure) => emit(
        state.copyWith(status: ProductsStatus.failure, error: failure.message),
      ),
      (products) => emit(
        state.copyWith(status: ProductsStatus.success, items: products),
      ),
    );
  }

  Future<void> createProduct(ProductUpsertInput input) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.createProduct(input);
    result.fold(
      (failure) => emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (created) {
        final updated = [created, ...state.items];
        emit(state.copyWith(
          actionInProgress: false,
          items: updated,
          status: ProductsStatus.success,
        ));
      },
    );
  }

  Future<void> updateProduct(ProductUpsertInput input) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.updateProduct(input);
    result.fold(
      (failure) => emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (updatedProduct) {
        final updated = state.items
            .map((e) => e.id == updatedProduct.id ? updatedProduct : e)
            .toList();
        emit(state.copyWith(
          actionInProgress: false,
          items: updated,
          status: ProductsStatus.success,
        ));
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(state.copyWith(actionInProgress: true, error: null));
    final result = await _repository.deleteProduct(productId);
    result.fold(
      (failure) => emit(state.copyWith(actionInProgress: false, error: failure.message)),
      (_) {
        final updated = state.items.where((e) => e.id != productId).toList();
        emit(state.copyWith(
          actionInProgress: false,
          items: updated,
          status: ProductsStatus.success,
        ));
      },
    );
  }
}
