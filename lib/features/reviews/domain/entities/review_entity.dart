import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, productId, userId, userName, rating, comment, createdAt];
}

class ReviewSummaryEntity extends Equatable {
  final String productId;
  final int totalReviews;
  final double averageRating;
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  const ReviewSummaryEntity({
    required this.productId,
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  @override
  List<Object?> get props => [
        productId,
        totalReviews,
        averageRating,
        fiveStar,
        fourStar,
        threeStar,
        twoStar,
        oneStar,
      ];
}
