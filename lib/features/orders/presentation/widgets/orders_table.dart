import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key});

  static const List<Map<String, dynamic>> dummyOrders = [
    {'id': '#ORD0001', 'product': 'Wireless Bluetooth Headphones', 'icon': Icons.headphones, 'date': '01-01-2025', 'price': '49.99', 'payment': 'Paid', 'status': 'Delivered'},
    {'id': '#ORD0002', 'product': "Men's T-Shirt", 'icon': Icons.checkroom, 'date': '01-01-2025', 'price': '14.99', 'payment': 'Unpaid', 'status': 'Pending'},
    {'id': '#ORD0003', 'product': "Men's Leather Wallet", 'icon': Icons.wallet, 'date': '01-01-2025', 'price': '49.99', 'payment': 'Paid', 'status': 'Delivered'},
    {'id': '#ORD0004', 'product': 'Memory Foam Pillow', 'icon': Icons.bed, 'date': '01-01-2025', 'price': '39.99', 'payment': 'Paid', 'status': 'Shipped'},
    {'id': '#ORD0005', 'product': 'Adjustable Dumbbells', 'icon': Icons.fitness_center, 'date': '01-01-2025', 'price': '14.99', 'payment': 'Unpaid', 'status': 'Pending'},
    {'id': '#ORD0006', 'product': 'Coffee Maker', 'icon': Icons.coffee_maker, 'date': '01-01-2025', 'price': '79.99', 'payment': 'Unpaid', 'status': 'Cancelled'},
    {'id': '#ORD0007', 'product': 'Smart Fitness Tracker', 'icon': Icons.watch, 'date': '02-01-2025', 'price': '99.99', 'payment': 'Paid', 'status': 'Delivered'},
    {'id': '#ORD0008', 'product': 'Yoga Mat', 'icon': Icons.accessibility_new, 'date': '02-01-2025', 'price': '25.00', 'payment': 'Paid', 'status': 'Delivered'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // Tabs and Actions Row
            Row(
              children: [
                _buildTab('All order', '(240)', true),
                _buildTab('Completed', null, false),
                _buildTab('Pending', null, false),
                _buildTab('Canceled', null, false),
                const Spacer(),
                SizedBox(
                  width: 200.w,
                  height: 36.h,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search order report',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                _buildIconBtn(Icons.filter_list),
                SizedBox(width: 8.w),
                _buildIconBtn(Icons.swap_vert),
                SizedBox(width: 8.w),
                _buildIconBtn(Icons.more_horiz),
              ],
            ),
            AppSpacing.v20,
            // Table Header
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              child: Row(
                children: [
                  _buildHeaderCell('No.', flex: 1),
                  _buildHeaderCell('Order Id', flex: 2),
                  _buildHeaderCell('Product', flex: 4),
                  _buildHeaderCell('Date', flex: 2),
                  _buildHeaderCell('Price', flex: 2),
                  _buildHeaderCell('Payment', flex: 2),
                  _buildHeaderCell('Status', flex: 2),
                ],
              ),
            ),
            // Table Body
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyOrders.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (_, index) => _OrderRow(index: index + 1, order: dummyOrders[index]),
            ),
            AppSpacing.v25,
            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Previous'),
                  style: _btnStyle,
                ),
                Row(
                  children: [
                    _buildPageNum('1', active: true),
                    _buildPageNum('2'),
                    _buildPageNum('3'),
                    _buildPageNum('4'),
                    _buildPageNum('5'),
                    _buildPageNum('....'),
                    _buildPageNum('24'),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Next'),
                  style: _btnStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle get _btnStyle => OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      );

  Widget _buildTab(String label, String? count, bool active) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          if (count != null) ...[
            SizedBox(width: 4.w),
            Text(
              count,
              style: TextStyle(
                fontSize: 13.sp,
                color: active ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 18, color: AppColors.textSecondary),
    );
  }

  Widget _buildHeaderCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPageNum(String num, {bool active = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        border: Border.all(color: active ? AppColors.primary : const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      alignment: Alignment.center,
      child: Text(
        num,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.index, required this.order});
  final int index;
  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(value: false, onChanged: (v) {}, side: const BorderSide(color: Color(0xFFD1D5DB))),
                ),
                SizedBox(width: 12.w),
                Text('$index', style: _cellStyle),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(order['id'], style: _cellStyle.copyWith(fontWeight: FontWeight.w700))),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Icon(order['icon'] as IconData, size: 16, color: AppColors.textSecondary),
                ),
                SizedBox(width: 12.w),
                Text(order['product'] as String, style: _cellStyle),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(order['date'] as String, style: _cellStyle)),
          Expanded(flex: 2, child: Text(order['price'] as String, style: _cellStyle.copyWith(fontWeight: FontWeight.w700))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: order['payment'] == 'Paid' ? AppColors.success : AppColors.error,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(order['payment'] as String, style: _cellStyle),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildStatusBadge(order['status'] as String),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    Color bgColor;

    switch (status) {
      case 'Delivered':
        color = AppColors.success;
        icon = Icons.check_circle_outline;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      case 'Pending':
        color = AppColors.warning;
        icon = Icons.access_time;
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        break;
      case 'Shipped':
        color = AppColors.primary;
        icon = Icons.local_shipping_outlined;
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        break;
      case 'Cancelled':
        color = AppColors.error;
        icon = Icons.cancel_outlined;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.help_outline;
        bgColor = AppColors.background;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 6.w),
          Text(
            status,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  TextStyle get _cellStyle => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
}
