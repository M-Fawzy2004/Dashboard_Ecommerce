part of 'categories_cubit.dart';

class CategoriesState extends Equatable {
  final List<CategoryConfig> categories;
  final bool isLoading;
  final bool isActionInProgress;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.isActionInProgress = false,
    this.error,
  });

  CategoriesState copyWith({
    List<CategoryConfig>? categories,
    bool? isLoading,
    bool? isActionInProgress,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, isActionInProgress, error];
}
