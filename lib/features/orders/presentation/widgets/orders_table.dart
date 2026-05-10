import 'package:dashboard_ecommerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/widgets/hover_button.dart';
import 'order_card.dart';

class OrdersTable extends StatefulWidget {
  const OrdersTable({super.key});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  String _selectedStatus = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isLoading && state.orders.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(100.r),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }

        var filteredOrders = _selectedStatus == 'All'
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

        if (_searchQuery.isNotEmpty) {
          filteredOrders = filteredOrders
              .where(
                (o) => o.orderCode.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterBar(state),
            AppSpacing.v25,
            if (filteredOrders.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                separatorBuilder: (_, _) => AppSpacing.v12,
                itemBuilder: (context, index) =>
                    OrderCard(order: filteredOrders[index], index: index + 1),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilterBar(OrdersState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildTab('All', state.orders.length),
                  SizedBox(width: 8.w),
                  _buildTab(
                    'New',
                    state.orders
                        .where(
                          (o) =>
                              o.status.toLowerCase() == 'pending' ||
                              o.status.toLowerCase() == 'confirmed',
                        )
                        .length,
                  ),
                  SizedBox(width: 8.w),
                  _buildTab(
                    'Completed',
                    state.orders
                        .where((o) => o.status.toLowerCase() == 'delivered')
                        .length,
                  ),
                  SizedBox(width: 8.w),
                  _buildTab(
                    'Cancelled',
                    state.orders
                        .where((o) => o.status.toLowerCase() == 'cancelled')
                        .length,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          _buildSearchBox(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    final active = _selectedStatus == label;
    return HoverButton(
      onTap: () => setState(() => _selectedStatus = label),
      borderRadius: 12.r,
      active: active,
      activeColor: Colors.white.withOpacity(0.06),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? Colors.white : Colors.white.withOpacity(0.3),
              ),
            ),
            if (count > 0 || active) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 240.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search orders...',
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.2),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              Icons.search_rounded,
              size: 18.sp,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
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
              size: 48,
              color: Colors.white.withOpacity(0.1),
            ),
            AppSpacing.v16,
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            AppSpacing.v5,
            Text(
              'Try changing the filters or search query',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
