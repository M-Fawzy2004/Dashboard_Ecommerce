import 'package:dashboard_ecommerce/features/reviews/domain/entities/review_entity.dart';


class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: (map['id'] ?? '').toString(),
      productId: (map['product_id'] ?? '').toString(),
      userId: (map['user_id'] ?? '').toString(),
      userName: (map['user_name'] ?? 'Anonymous').toString(),
      rating: (map['rating'] ?? 0) as int,
      comment: (map['comment'] ?? '').toString(),
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString()) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
    };
  }
}

class ReviewSummaryModel extends ReviewSummaryEntity {
  const ReviewSummaryModel({
    required super.productId,
    required super.totalReviews,
    required super.averageRating,
    required super.fiveStar,
    required super.fourStar,
    required super.threeStar,
    required super.twoStar,
    required super.oneStar,
  });

  factory ReviewSummaryModel.fromMap(Map<String, dynamic> map) {
    return ReviewSummaryModel(
      productId: (map['product_id'] ?? '').toString(),
      totalReviews: (map['total_reviews'] ?? 0) as int,
      averageRating: (map['average_rating'] ?? 0.0).toDouble(),
      fiveStar: (map['five_star'] ?? 0) as int,
      fourStar: (map['four_star'] ?? 0) as int,
      threeStar: (map['three_star'] ?? 0) as int,
      twoStar: (map['two_star'] ?? 0) as int,
      oneStar: (map['one_star'] ?? 0) as int,
    );
  }
}
