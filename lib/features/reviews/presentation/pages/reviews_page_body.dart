import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../cubit/reviews_cubit.dart';
import '../../domain/entities/review_entity.dart';

import '../../../../../shared/utils/app_snack_bar.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/cubit/products_cubit.dart';

class ReviewsPageBody extends StatelessWidget {
  const ReviewsPageBody({super.key, this.onProductTap});
  final Function(ProductEntity)? onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Reviews',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        AppSpacing.v20,
        BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReviewsError) {
              return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
            }
            if (state is ReviewsLoaded) {
              return Column(
                children: [
                  _buildSummaryGrid(state.summaries),
                  AppSpacing.v25,
                  _buildReviewsList(context, state.reviews),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildSummaryGrid(List<ReviewSummaryEntity> summaries) {
    if (summaries.isEmpty) return const SizedBox();
    
    // Total stats across all products
    final totalReviews = summaries.fold(0, (sum, item) => sum + item.totalReviews);
    final avgRating = summaries.isEmpty ? 0.0 : summaries.fold(0.0, (sum, item) => sum + item.averageRating) / summaries.length;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryStat('Total Reviews', totalReviews.toString(), Icons.rate_review_outlined, Colors.blue),
          _buildSummaryStat('Average Rating', avgRating.toStringAsFixed(1), Icons.star_outline, Colors.orange),
          _buildSummaryStat('Active Products', summaries.length.toString(), Icons.inventory_2_outlined, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        AppSpacing.v10,
        Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildReviewsList(BuildContext context, List<ReviewEntity> reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => AppSpacing.v16,
      itemBuilder: (context, index) => _ReviewCard(
        review: reviews[index],
        onProductTap: onProductTap,
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, this.onProductTap});
  final ReviewEntity review;
  final Function(ProductEntity)? onProductTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(review.userName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review.userName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                    const Spacer(),
                    Text(DateFormat('MMM dd, yyyy').format(review.createdAt), style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.2))),
                  ],
                ),
                AppSpacing.v5,
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.orange,
                    size: 16,
                  )),
                ),
                AppSpacing.v10,
                InkWell(
                  onTap: () {
                    final productsState = context.read<ProductsCubit>().state;
                    try {
                      final product = productsState.items.firstWhere((p) => p.id == review.productId);
                      onProductTap?.call(product);
                    } catch (_) {
                      AppSnackBar.showError(context, 'Product details not found or loaded');
                    }
                  },
                  child: Text(
                    'Product ID: ${review.productId}',
                    style: TextStyle(
                      fontSize: 11.sp, 
                      color: AppColors.primary, 
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                AppSpacing.v10,
                Text(
                  review.comment,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700, height: 1.5),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<ReviewsCubit>().deleteReview(review.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
