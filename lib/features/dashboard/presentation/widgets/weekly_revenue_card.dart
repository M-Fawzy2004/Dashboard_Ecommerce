import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyRevenueCard extends StatelessWidget {
  const WeeklyRevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final orders = state.orders;

        final totalSales = orders.fold(0.0, (sum, o) => sum + o.totalAmount);
        final orderCount = orders.length;
        final estimatedProfit = totalSales * 0.25;

        final now = DateTime.now();
        final Map<int, double> dailyRevenue = {};
        for (int i = 0; i < 7; i++) {
          final date = now.subtract(Duration(days: i));
          dailyRevenue[date.weekday] = 0.0;
        }

        for (var order in orders) {
          final orderDate = order.createdAt;
          if (now.difference(orderDate).inDays < 7) {
            dailyRevenue[orderDate.weekday] =
                (dailyRevenue[orderDate.weekday] ?? 0.0) + order.totalAmount;
          }
        }

        final weekdays = [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday,
        ];
        double maxY = 100;
        final List<FlSpot> spots = [];

        for (int i = 0; i < weekdays.length; i++) {
          final rev = dailyRevenue[weekdays[i]] ?? 0.0;
          spots.add(FlSpot(i.toDouble(), rev / 1000));
          if (rev / 1000 > maxY) maxY = (rev / 1000) * 1.2;
        }

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Revenue report for this week',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ],
                  ),
                  const _ToggleBtn(label: 'Weekly', active: true),
                ],
              ),

              SizedBox(height: 20.h),
              Divider(color: Colors.white.withOpacity(0.06)),
              SizedBox(height: 20.h),

              // ── Stats Row ──
              Row(
                children: [
                  _StatItem(
                    label: 'Total Sales',
                    value: '\$${totalSales.toStringAsFixed(0)}',
                    color: const Color(0xFF818CF8),
                  ),
                  SizedBox(width: 32.w),
                  _StatItem(
                    label: 'Est. Profit',
                    value: '\$${estimatedProfit.toStringAsFixed(0)}',
                    color: const Color(0xFF34D399),
                  ),
                  SizedBox(width: 32.w),
                  _StatItem(
                    label: 'Orders',
                    value: '$orderCount',
                    color: const Color(0xFFFBBF24),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // ── Chart ──
              SizedBox(
                height: 220.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}k',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          reservedSize: 32.w,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < days.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Text(
                                  days[value.toInt()],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.25),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: maxY < 10 ? 10 : maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: const Color(0xFF818CF8),
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 3,
                                color: const Color(0xFF0A0A0F),
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF818CF8),
                              ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF818CF8).withOpacity(0.15),
                              const Color(0xFF818CF8).withOpacity(0.0),
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

// ─── Toggle Button ────────────────────────────────────────────────────────────

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(0.07) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: active
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: active
              ? Colors.white.withOpacity(0.7)
              : Colors.white.withOpacity(0.25),
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ─── Stat Item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white.withOpacity(0.25),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
