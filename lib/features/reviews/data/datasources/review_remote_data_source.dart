import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_config.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews();
  Future<List<ReviewSummaryModel>> getSummaries();
  Future<void> deleteReview(String id);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final SupabaseClient _client;

  ReviewRemoteDataSourceImpl({SupabaseClient? client})
    : _client = client ?? SupabaseConfig.client;

  @override
  Future<List<ReviewModel>> getReviews() async {
    final response = await _client
        .from('product_reviews')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((e) => ReviewModel.fromMap(e)).toList();
  }

  @override
  Future<List<ReviewSummaryModel>> getSummaries() async {
    final response = await _client.from('product_rating_summary').select();
    return (response as List)
        .map((e) => ReviewSummaryModel.fromMap(e))
        .toList();
  }

  @override
  Future<void> deleteReview(String id) async {
    await _client.from('product_reviews').delete().match({'id': id});
  }
}
