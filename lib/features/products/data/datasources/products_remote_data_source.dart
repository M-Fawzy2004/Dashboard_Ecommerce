import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductUpsertInput input);
  Future<ProductModel> updateProduct(ProductUpsertInput input);
  Future<void> deleteProduct(String productId);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;
  static const _imagesBucket = 'product-images';

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final rows = await _client
          .from('products')
          .select()
          .order('created_at', ascending: false);
      final List<dynamic> raw = rows as List<dynamic>;
      final result = <ProductModel>[];
      for (final item in raw) {
        final productMap = Map<String, dynamic>.from(item as Map);
        final productId = productMap['id'] as String;
        final imageUrls = await _loadProductImages(productId);
        final colorStocks = await _loadColorStocks(productId);
        result.add(ProductModel.fromMap(
          productMap,
          imageUrls: imageUrls,
          colorStocks: colorStocks,
        ));
      }
      return result;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<ProductModel> createProduct(ProductUpsertInput input) async {
    try {
      final inserted = await _client
          .from('products')
          .insert(_productMap(input))
          .select()
          .single();
      final productId = inserted['id'] as String;
      await _syncImages(productId, input.images);
      await _syncColorStocks(productId, input.colorStocks);
      return await _loadProductById(productId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductUpsertInput input) async {
    if (input.id == null) {
      throw ServerException('Product id is required for update.');
    }
    try {
      await _client.from('products').update(_productMap(input)).eq('id', input.id!);
      await _syncImages(input.id!, input.images);
      await _syncColorStocks(input.id!, input.colorStocks);
      return await _loadProductById(input.id!);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      final imageRows = await _client
          .from('product_images')
          .select('image_url')
          .eq('product_id', productId);
      final toDelete = <String>[];
      for (final row in (imageRows as List<dynamic>)) {
        final url = row['image_url'] as String?;
        if (url == null) continue;
        final marker = '/storage/v1/object/public/$_imagesBucket/';
        final idx = url.indexOf(marker);
        if (idx != -1) {
          toDelete.add(url.substring(idx + marker.length));
        }
      }
      if (toDelete.isNotEmpty) {
        await _client.storage.from(_imagesBucket).remove(toDelete);
      }
      await _client.from('product_images').delete().eq('product_id', productId);
      await _client.from('product_color_stocks').delete().eq('product_id', productId);
      await _client.from('products').delete().eq('id', productId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    }
  }

  Map<String, dynamic> _productMap(ProductUpsertInput input) {
    return {
      'name': input.name,
      'description': input.description,
      'category_id': input.categoryId,
      'category_name': input.categoryName,
      'price': input.price,
      'sale_price': input.salePrice,
      'currency': input.currency,
      'stock_qty': input.stockQty,
      'unlimited_stock': input.unlimitedStock,
      'stock_status': input.stockStatus,
      'sku': input.sku,
      'is_featured': input.isFeatured,
      'weight_kg': input.weightKg,
      'weight_unit': input.weightUnit,
      'length_cm': input.lengthCm,
      'width_cm': input.widthCm,
      'height_cm': input.heightCm,
      'dimension_unit': input.dimensionUnit,
      'specs': input.specs,
      'main_image_url': input.images.where((e) => e.isPrimary).isNotEmpty
          ? null
          : input.images.isNotEmpty
              ? input.images.first.externalUrl
              : null,
    };
  }

  Future<void> _syncImages(String productId, List<ProductImageInput> images) async {
    await _client.from('product_images').delete().eq('product_id', productId);
    if (images.isEmpty) return;

    final rows = <Map<String, dynamic>>[];
    String? mainImageUrl;
    for (var i = 0; i < images.length; i++) {
      final item = images[i];
      String? url = item.externalUrl;
      String sourceType = 'external';
      if (item.bytes != null) {
        final filePath =
            '$productId/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}.jpg';
        await _client.storage.from(_imagesBucket).uploadBinary(filePath, item.bytes!);
        url = _client.storage.from(_imagesBucket).getPublicUrl(filePath);
        sourceType = 'upload';
      }
      if (url == null) continue;
      if (mainImageUrl == null || item.isPrimary) {
        mainImageUrl = url;
      }
      rows.add({
        'product_id': productId,
        'image_url': url,
        'source_type': sourceType,
        'sort_order': i,
        'is_primary': item.isPrimary,
      });
    }
    if (rows.isNotEmpty) {
      await _client.from('product_images').insert(rows);
    }
    await _client
        .from('products')
        .update({'main_image_url': mainImageUrl}).eq('id', productId);
  }

  Future<void> _syncColorStocks(
    String productId,
    List<ProductColorStock> colorStocks,
  ) async {
    await _client.from('product_color_stocks').delete().eq('product_id', productId);
    if (colorStocks.isEmpty) return;
    final rows = colorStocks
        .map((e) => {
              'product_id': productId,
              'color_name': e.colorName,
              'color_hex': e.colorHex,
              'quantity': e.quantity,
              'unlimited': e.unlimited,
            })
        .toList();
    await _client.from('product_color_stocks').insert(rows);
  }

  Future<List<String>> _loadProductImages(String productId) async {
    final rows = await _client
        .from('product_images')
        .select('image_url')
        .eq('product_id', productId)
        .order('sort_order');
    return (rows as List<dynamic>)
        .map((e) => e['image_url'] as String?)
        .whereType<String>()
        .toList();
  }

  Future<List<ProductColorStock>> _loadColorStocks(String productId) async {
    final rows = await _client
        .from('product_color_stocks')
        .select()
        .eq('product_id', productId);
    return (rows as List<dynamic>).map((e) {
      return ProductColorStock(
        colorName: e['color_name'] as String,
        colorHex: e['color_hex'] as String?,
        quantity: e['quantity'] as int? ?? 0,
        unlimited: e['unlimited'] as bool? ?? false,
      );
    }).toList();
  }

  Future<ProductModel> _loadProductById(String productId) async {
    final row = await _client.from('products').select().eq('id', productId).single();
    final images = await _loadProductImages(productId);
    final colors = await _loadColorStocks(productId);
    return ProductModel.fromMap(Map<String, dynamic>.from(row),
        imageUrls: images, colorStocks: colors);
  }
}
