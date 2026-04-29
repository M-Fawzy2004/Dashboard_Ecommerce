import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/presentation/model/category_config.dart';
import '../../data/datasources/categories_remote_data_source.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRemoteDataSource _dataSource;

  CategoriesCubit(this._dataSource) : super(const CategoriesState());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final categories = await _dataSource.getCategories();
      CategoryConfig.all = categories; // Sync global list for convenience
      emit(state.copyWith(isLoading: false, categories: categories));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addCategory(CategoryConfig category) async {
    emit(state.copyWith(isActionInProgress: true, error: null));
    try {
      final newCategory = await _dataSource.createCategory(category);
      final updatedList = List<CategoryConfig>.from(state.categories)..add(newCategory);
      CategoryConfig.all = updatedList;
      emit(state.copyWith(isActionInProgress: false, categories: updatedList));
    } catch (e) {
      emit(state.copyWith(isActionInProgress: false, error: e.toString()));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    emit(state.copyWith(isActionInProgress: true, error: null));
    try {
      await _dataSource.deleteCategory(categoryId);
      final updatedList = List<CategoryConfig>.from(state.categories)
        ..removeWhere((c) => c.id == categoryId);
      CategoryConfig.all = updatedList;
      emit(state.copyWith(isActionInProgress: false, categories: updatedList));
    } catch (e) {
      emit(state.copyWith(isActionInProgress: false, error: e.toString()));
    }
  }
}
