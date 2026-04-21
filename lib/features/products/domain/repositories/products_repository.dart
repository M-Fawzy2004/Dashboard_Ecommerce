import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> createProduct(ProductUpsertInput input);
  Future<Either<Failure, ProductEntity>> updateProduct(ProductUpsertInput input);
  Future<Either<Failure, Unit>> deleteProduct(String productId);
}
