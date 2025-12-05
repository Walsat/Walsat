import 'package:flutter/material.dart';
import '../theme/modern_theme.dart';

/// 🎨 زر متدرج خيالي
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final IconData? icon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final double elevation;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.icon,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.elevation = 8.0,
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null && !widget.isLoading
          ? (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            }
          : null,
      onTapUp: widget.onPressed != null && !widget.isLoading
          ? (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height ?? 56,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? ModernTheme.primaryGradient,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (widget.gradient ?? ModernTheme.primaryGradient)
                    .colors
                    .first
                    .withOpacity(0.4),
                blurRadius: widget.elevation,
                offset: Offset(0, widget.elevation / 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              child: Container(
                padding: widget.padding ??
                    EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: widget.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 12),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔘 زر Outlined متطور
class ModernOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ModernOutlinedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: buttonColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: buttonColor, size: 22),
                  SizedBox(width: 12),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ✨ Floating Action Button خيالي
class ModernFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final String? label;
  final bool extended;

  const ModernFAB({
    Key? key,
    required this.icon,
    this.onPressed,
    this.gradient,
    this.label,
    this.extended = false,
  }) : super(key: key);

  @override
  State<ModernFAB> createState() => _ModernFABState();
}

class _ModernFABState extends State<ModernFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: Container(
            height: widget.extended ? 56 : 64,
            padding: widget.extended
                ? EdgeInsets.symmetric(horizontal: 20)
                : EdgeInsets.all(0),
            decoration: BoxDecoration(
              gradient: widget.gradient ?? ModernTheme.primaryGradient,
              borderRadius: BorderRadius.circular(widget.extended ? 28 : 32),
              boxShadow: [
                BoxShadow(
                  color: (widget.gradient ?? ModernTheme.primaryGradient)
                      .colors
                      .first
                      .withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.extended ? 28 : 32),
                child: Padding(
                  padding: widget.extended
                      ? EdgeInsets.symmetric(horizontal: 4)
                      : EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                      if (widget.extended && widget.label != null) ...[
                        SizedBox(width: 12),
                        Text(
                          widget.label!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎯 زر أيقونة دائري
class ModernIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final bool hasShadow;

  const ModernIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 48,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  State<ModernIconButton> createState() => _ModernIconButtonState();
}

class _ModernIconButtonState extends State<ModernIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            shape: BoxShape.circle,
            boxShadow: widget.hasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: widget.color ?? Theme.of(context).colorScheme.primary,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// 🎪 زر Chip عصري
class ModernChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;

  const ModernChip({
    Key? key,
    required this.label,
    this.icon,
    this.color,
    this.onTap,
    this.onDelete,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [chipColor, chipColor.withOpacity(0.8)],
                )
              : null,
          color: selected ? null : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : chipColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: chipColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : chipColor,
              ),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : chipColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (onDelete != null) ...[
              SizedBox(width: 6),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: selected ? Colors.white : chipColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 🚀 Modern Floating Action Button with Label
class ModernFloatingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Gradient? gradient;

  const ModernFloatingButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModernFAB(
      icon: icon,
      label: label,
      extended: true,
      onPressed: onPressed,
      gradient: gradient ?? ModernTheme.primaryGradient,
    );
  }
}

/// 🎨 Modern Gradient Button (Simplified wrapper)
class ModernGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final IconData? icon;

  const ModernGradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      text: text,
      onPressed: onPressed,
      gradient: gradient ?? ModernTheme.primaryGradient,
      icon: icon,
    );
  }
}
