import 'package:dashboard_ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

import 'package:url_launcher/url_launcher.dart';

class OrdersTable extends StatefulWidget {
  const OrdersTable({super.key});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}
// ... existing state class ...

class _OrdersTableState extends State<OrdersTable> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isLoading && state.orders.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(100.r),
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final filteredOrders = _selectedStatus == 'All'
            ? state.orders
            : _selectedStatus == 'New'
            ? state.orders
                  .where(
                    (o) =>
                        o.status.toLowerCase() == 'pending' ||
                        o.status.toLowerCase() == 'confirmed',
                  )
                  .toList()
            : _selectedStatus == 'Completed'
            ? state.orders
                  .where((o) => o.status.toLowerCase() == 'delivered')
                  .toList()
            : state.orders
                  .where(
                    (o) =>
                        o.status.toLowerCase() == _selectedStatus.toLowerCase(),
                  )
                  .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Premium Header & Filtering ───────────────────────────
            _buildPremiumFilterBar(state),
            AppSpacing.v25,

            if (filteredOrders.isEmpty)
              _buildEmptyState()
            else
              // ── Orders List ──────────────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => AppSpacing.v16,
                itemBuilder: (context, index) => _PremiumOrderCard(
                  order: filteredOrders[index],
                  index: index + 1,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumFilterBar(OrdersState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab(
                    'All',
                    state.orders.length,
                    _selectedStatus == 'All',
                  ),
                  _buildTab(
                    'New',
                    state.orders
                        .where(
                          (o) =>
                              o.status.toLowerCase() == 'pending' ||
                              o.status.toLowerCase() == 'confirmed',
                        )
                        .length,
                    _selectedStatus == 'New',
                  ),
                  _buildTab(
                    'Completed',
                    state.orders
                        .where((o) => o.status.toLowerCase() == 'delivered')
                        .length,
                    _selectedStatus == 'Completed',
                  ),
                  _buildTab(
                    'Cancelled',
                    state.orders
                        .where((o) => o.status.toLowerCase() == 'cancelled')
                        .length,
                    _selectedStatus == 'Cancelled',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20.w),
          _buildSearchBox(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count, bool active) {
    return InkWell(
      onTap: () => setState(() => _selectedStatus = label),
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: active ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: active
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 250.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by Order ID...',
          hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11.h),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(80.r),
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            AppSpacing.v16,
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.v5,
            Text(
              'Try changing the filters or search query',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumOrderCard extends StatelessWidget {
  const _PremiumOrderCard({required this.order, required this.index});
  final OrderEntity order;
  final int index;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Status Indicator Strip
            Container(
              width: 6.w,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Order Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderCode,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            AppSpacing.v5,
                            Text(
                              DateFormat(
                                'MMM dd, yyyy • hh:mm a',
                              ).format(order.createdAt),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        _buildStatusBadge(order.status),
                      ],
                    ),
                    AppSpacing.v20,
                    const Divider(height: 1),
                    AppSpacing.v20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Preview
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ITEMS',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              AppSpacing.v10,
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children:
                                    order.items
                                        .take(3)
                                        .map((item) => _buildItemChip(item))
                                        .toList()
                                      ..addAll(
                                        order.items.length > 3
                                            ? [
                                                _buildMoreChip(
                                                  order.items.length - 3,
                                                ),
                                              ]
                                            : [],
                                      ),
                              ),
                              AppSpacing.v20,
                              _buildDetailRow(
                                Icons.location_on_outlined,
                                'Address',
                                order.shippingAddress ?? 'Not provided',
                              ),
                              _buildDetailRow(
                                Icons.phone_outlined,
                                'Phone',
                                order.phone ?? 'Not provided',
                              ),
                              if (order.latitude != null &&
                                  order.longitude != null)
                                _buildDetailRow(
                                  Icons.map_outlined,
                                  'Location',
                                  '${order.latitude}, ${order.longitude}',
                                  isLink: true,
                                  lat: order.latitude,
                                  lng: order.longitude,
                                ),
                            ],
                          ),
                        ),
                        // Status Management & Total
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'TOTAL AMOUNT',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              AppSpacing.v5,
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              AppSpacing.v5,
                              Text(
                                'PAYMENT: ${order.paymentMethod.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                              AppSpacing.v20,
                              Text(
                                'CHANGE STATUS',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              AppSpacing.v10,
                              _buildStatusSwitcher(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isLink = false,
    double? lat,
    double? lng,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary.withValues(alpha: 0.6)),
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: isLink && lat != null && lng != null
                  ? () => _launchMaps(lat, lng)
                  : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isLink ? Colors.blue : AppColors.textPrimary,
                  decoration: isLink ? TextDecoration.underline : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSwitcher(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        _buildStatusButton(context, 'confirmed', 'Confirm', Colors.blue),
        _buildStatusButton(context, 'preparing', 'Prepare', Colors.orange),
        _buildStatusButton(context, 'shipped', 'Ship', Colors.purple),
        _buildStatusButton(context, 'delivered', 'Deliver', Colors.green),
      ],
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String status,
    String label,
    Color color,
  ) {
    final bool isCurrent = order.status.toLowerCase() == status;
    return InkWell(
      onTap: isCurrent
          ? null
          : () => context.read<OrdersCubit>().updateStatus(order.id, status),
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isCurrent ? color : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: isCurrent ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildItemChip(OrderItemEntity item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            '${item.productName} x${item.quantity}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreChip(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '+$count more',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'delivered') return AppColors.success;
    if (s == 'pending') return AppColors.warning;
    if (s == 'preparing') return Colors.orange;
    if (s == 'confirmed') return Colors.blue;
    if (s == 'cancelled' || s == 'failed') return AppColors.error;
    if (s == 'shipped' || s == 'shipping') return AppColors.primary;
    return Colors.grey;
  }
}
