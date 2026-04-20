import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'no': '1.', 'id': '#6545', 'date': '01 Oct | 11:29 am', 'status': 'Paid', 'amount': r'$64'},
      {'no': '2.', 'id': '#5412', 'date': '01 Oct | 11:29 am', 'status': 'Pending', 'amount': r'$557'},
      {'no': '3.', 'id': '#6622', 'date': '01 Oct | 11:29 am', 'status': 'Paid', 'amount': r'$156'},
      {'no': '4.', 'id': '#6462', 'date': '01 Oct | 11:29 am', 'status': 'Paid', 'amount': r'$265'},
      {'no': '5.', 'id': '#6462', 'date': '01 Oct | 11:29 am', 'status': 'Paid', 'amount': r'$265'},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction', style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
              ],
            ),
            AppSpacing.v20,
            Table(
              columnWidths: const {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeader('No'),
                    _buildHeader('Id Customer'),
                    _buildHeader('Order Date'),
                    _buildHeader('Status'),
                    _buildHeader('Amount'),
                  ],
                ),
                ...transactions.map((t) => TableRow(
                      children: [
                        _buildCell(t['no']!),
                        _buildCell(t['id']!),
                        _buildCell(t['date']!),
                        _buildStatusCell(t['status']!),
                        _buildAmountCell(t['amount']!),
                      ],
                    )),
              ],
            ),
            AppSpacing.v20,
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    final isPaid = status == 'Paid';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPaid ? AppColors.success : AppColors.warning,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            status,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCell(String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        amount,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
