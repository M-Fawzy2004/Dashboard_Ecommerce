import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../../products/presentation/model/category_config.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryConfig>> getCategories();
  Future<CategoryConfig> createCategory(CategoryConfig category);
  Future<void> deleteCategory(String categoryId);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  CategoriesRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  @override
  Future<List<CategoryConfig>> getCategories() async {
    try {
      final rows = await _client
          .from('product_categories')
          .select()
          .order('created_at', ascending: true);
      
      return (rows as List).map((row) => CategoryConfig.fromMap(row)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<CategoryConfig> createCategory(CategoryConfig category) async {
    try {
      final row = await _client
          .from('product_categories')
          .insert(category.toMap())
          .select()
          .single();
      
      return CategoryConfig.fromMap(row);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _client.from('product_categories').delete().eq('key', categoryId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}
