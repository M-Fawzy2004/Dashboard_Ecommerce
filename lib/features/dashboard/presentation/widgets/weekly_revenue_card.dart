import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyRevenueCard extends StatelessWidget {
  const WeeklyRevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final orders = state.orders;
        
        // Calculate real stats
        final totalSales = orders.fold(0.0, (sum, o) => sum + o.totalAmount);
        final orderCount = orders.length;
        final estimatedProfit = totalSales * 0.25; // 25% mock profit margin

        // Group last 7 days revenue
        final now = DateTime.now();
        final Map<int, double> dailyRevenue = {};
        for (int i = 0; i < 7; i++) {
          final date = now.subtract(Duration(days: i));
          dailyRevenue[date.weekday] = 0.0;
        }

        for (var order in orders) {
          final orderDate = order.createdAt;
          if (now.difference(orderDate).inDays < 7) {
            dailyRevenue[orderDate.weekday] = (dailyRevenue[orderDate.weekday] ?? 0.0) + order.totalAmount;
          }
        }

        // Map to spots (Mon=0, Tue=1, ..., Sun=6)
        // Adjust fl_chart spots based on weekday index (Mon=1 in Dart)
        final List<FlSpot> spots = [];
        final weekdays = [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday, DateTime.saturday, DateTime.sunday];
        double maxY = 100;
        
        for (int i = 0; i < weekdays.length; i++) {
          final rev = dailyRevenue[weekdays[i]] ?? 0.0;
          spots.add(FlSpot(i.toDouble(), rev / 1000)); // Divide by 1000 for 'k' scale
          if (rev / 1000 > maxY) maxY = (rev / 1000) * 1.2;
        }

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sales Analytics', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900)),
                      Text('Revenue report for this week', style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500)),
                    ],
                  ),
                  const _ToggleBtn(label: 'Weekly', active: true),
                ],
              ),
              AppSpacing.v25,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(label: 'Total Sales', value: '\$${totalSales.toStringAsFixed(0)}', color: Colors.indigo),
                  _StatItem(label: 'Profit (Est)', value: '\$${estimatedProfit.toStringAsFixed(0)}', color: Colors.green),
                  _StatItem(label: 'Orders', value: '$orderCount', color: Colors.orange),
                ],
              ),
              AppSpacing.v30,
              SizedBox(
                height: 240.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade100,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}k',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                          reservedSize: 35.w,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Text(days[value.toInt()], style: TextStyle(color: Colors.grey.shade500, fontSize: 11.sp, fontWeight: FontWeight.w600)),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0, maxX: 6, minY: 0, maxY: maxY < 10 ? 10 : maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.indigo,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.indigo,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.withValues(alpha: 0.2),
                              Colors.indigo.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: active ? AppColors.primary : AppColors.divider),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: active ? AppColors.primary : AppColors.textSecondary,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
