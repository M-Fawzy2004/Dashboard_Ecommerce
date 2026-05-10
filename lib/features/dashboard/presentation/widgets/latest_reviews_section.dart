import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_ecommerce/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'dashboard_section.dart';
import 'hover_row.dart';

class LatestReviewsSection extends StatelessWidget {
  const LatestReviewsSection({super.key, this.onViewAll});
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: 'Latest Reviews',
      actionLabel: 'View All',
      onActionTap: onViewAll ?? () {},
      child: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }
          if (state is ReviewsLoaded) {
            final recent = state.reviews.take(3).toList();
            if (recent.isEmpty) {
              return Text(
                'No reviews yet',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 13,
                ),
              );
            }
            return Column(
              children: recent.map((review) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: HoverRow(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                review.userName[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  review.comment,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 12,
                                  color: i < review.rating
                                      ? const Color(0xFFFBBF24)
                                      : Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
