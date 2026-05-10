import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.order, required this.index});
  final OrderEntity order;
  final int index;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.order.status);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _hovered
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.04),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
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
                          Text(
                            widget.order.orderCode,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          _StatusBadge(status: widget.order.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat('MMM dd, yyyy • hh:mm a').format(widget.order.createdAt),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Divider(color: Colors.white.withOpacity(0.06)),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionLabel(label: 'Items'),
                                SizedBox(height: 8.h),
                                Wrap(
                                  spacing: 6.w,
                                  runSpacing: 6.h,
                                  children: [
                                    ...widget.order.items.take(3).map((item) => _ItemChip(item: item)),
                                    if (widget.order.items.length > 3)
                                      _MoreChip(count: widget.order.items.length - 3),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                _DetailRow(
                                  icon: Icons.location_on_outlined,
                                  label: 'Address',
                                  value: widget.order.shippingAddress ?? 'Not provided',
                                ),
                                _DetailRow(
                                  icon: Icons.phone_outlined,
                                  label: 'Phone',
                                  value: widget.order.phone ?? 'Not provided',
                                ),
                                if (widget.order.latitude != null && widget.order.longitude != null)
                                  _DetailRow(
                                    icon: Icons.map_outlined,
                                    label: 'Location',
                                    value: '${widget.order.latitude}, ${widget.order.longitude}',
                                    isLink: true,
                                    lat: widget.order.latitude,
                                    lng: widget.order.longitude,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const _SectionLabel(label: 'Total Amount'),
                                SizedBox(height: 6.h),
                                Text(
                                  '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.order.paymentMethod.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF34D399),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                const _SectionLabel(label: 'Change Status'),
                                SizedBox(height: 10.h),
                                _StatusSwitcher(order: widget.order),
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
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return const Color(0xFF34D399);
      case 'pending': return const Color(0xFFFBBF24);
      case 'preparing': return const Color(0xFFF97316);
      case 'confirmed': return const Color(0xFF60A5FA);
      case 'cancelled':
      case 'failed': return const Color(0xFFF87171);
      case 'shipped':
      case 'shipping': return const Color(0xFFA78BFA);
      default: return Colors.white.withOpacity(0.2);
    }
  }
}

class _StatusSwitcher extends StatelessWidget {
  const _StatusSwitcher({required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        _StatusBtn(order: order, status: 'confirmed', label: 'Confirm', color: const Color(0xFF60A5FA)),
        _StatusBtn(order: order, status: 'preparing', label: 'Prepare', color: const Color(0xFFF97316)),
        _StatusBtn(order: order, status: 'shipped', label: 'Ship', color: const Color(0xFFA78BFA)),
        _StatusBtn(order: order, status: 'delivered', label: 'Deliver', color: const Color(0xFF34D399)),
      ],
    );
  }
}

class _StatusBtn extends StatefulWidget {
  const _StatusBtn({required this.order, required this.status, required this.label, required this.color});
  final OrderEntity order;
  final String status;
  final String label;
  final Color color;

  @override
  State<_StatusBtn> createState() => _StatusBtnState();
}

class _StatusBtnState extends State<_StatusBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isCurrent = widget.order.status.toLowerCase() == widget.status;
    return MouseRegion(
      cursor: isCurrent ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: isCurrent ? null : () => context.read<OrdersCubit>().updateStatus(widget.order.id, widget.status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isCurrent ? widget.color.withOpacity(0.15) : _hovered ? widget.color.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isCurrent ? widget.color.withOpacity(0.4) : widget.color.withOpacity(0.15)),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
              color: isCurrent ? widget.color : widget.color.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.25), letterSpacing: 2));
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  Color get _color {
    switch (status.toLowerCase()) {
      case 'delivered': return const Color(0xFF34D399);
      case 'pending': return const Color(0xFFFBBF24);
      case 'preparing': return const Color(0xFFF97316);
      case 'confirmed': return const Color(0xFF60A5FA);
      case 'cancelled':
      case 'failed': return const Color(0xFFF87171);
      case 'shipped':
      case 'shipping': return const Color(0xFFA78BFA);
      default: return Colors.white.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r), border: Border.all(color: _color.withOpacity(0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 5, decoration: BoxDecoration(color: _color, shape: BoxShape.circle)),
          SizedBox(width: 6.w),
          Text(status.toUpperCase(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: _color, letterSpacing: 0.8)),
        ],
      ),
    );
  }
}

class _ItemChip extends StatelessWidget {
  const _ItemChip({required this.item});
  final OrderItemEntity item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 12, color: Colors.white.withOpacity(0.3)),
          SizedBox(width: 6.w),
          Text('${item.productName} x${item.quantity}', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _MoreChip extends StatelessWidget {
  const _MoreChip({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(20.r)),
      child: Text('+$count more', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.25))),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value, this.isLink = false, this.lat, this.lng});
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.white.withOpacity(0.2)),
          SizedBox(width: 8.w),
          Text('$label: ', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.25))),
          Expanded(
            child: GestureDetector(
              onTap: isLink && lat != null ? () async {
                final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                if (await canLaunchUrl(url)) await launchUrl(url);
              } : null,
              child: Text(
                value,
                style: TextStyle(fontSize: 11.sp, color: isLink ? const Color(0xFF60A5FA) : Colors.white.withOpacity(0.6), decoration: isLink ? TextDecoration.underline : null),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
