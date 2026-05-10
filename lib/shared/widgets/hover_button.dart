import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  const HoverButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = 10,
    this.active = false,
    this.activeColor,
  });
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final bool active;
  final Color? activeColor;
  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _hovered = false;
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final bg = widget.active
        ? (widget.activeColor ?? Colors.white.withOpacity(0.07))
        : _hovered
        ? Colors.white.withOpacity(0.05)
        : Colors.transparent;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
