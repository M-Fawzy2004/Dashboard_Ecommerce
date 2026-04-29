import 'package:dashboard_ecommerce/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:dashboard_ecommerce/features/reviews/domain/entities/review_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}
class ReviewsLoading extends ReviewsState {}
class ReviewsLoaded extends ReviewsState {
  final List<ReviewEntity> reviews;
  final List<ReviewSummaryEntity> summaries;
  const ReviewsLoaded({required this.reviews, required this.summaries});
  @override
  List<Object?> get props => [reviews, summaries];
}
class ReviewsError extends ReviewsState {
  final String message;
  const ReviewsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRemoteDataSource _dataSource;

  ReviewsCubit(this._dataSource) : super(ReviewsInitial());

  Future<void> loadReviews() async {
    emit(ReviewsLoading());
    try {
      final reviews = await _dataSource.getReviews();
      final summaries = await _dataSource.getSummaries();
      emit(ReviewsLoaded(
        reviews: List<ReviewEntity>.from(reviews),
        summaries: List<ReviewSummaryEntity>.from(summaries),
      ));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> deleteReview(String id) async {
    try {
      await _dataSource.deleteReview(id);
      loadReviews(); // Refresh
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
