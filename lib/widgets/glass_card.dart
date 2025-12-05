import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/modern_theme.dart';

/// 🔮 بطاقة زجاجية مبهرة - Glassmorphism
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? color;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.color,
    this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (color ?? Colors.white).withOpacity(0.3),
                      (color ?? Colors.white).withOpacity(0.1),
                    ],
                  ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius ?? BorderRadius.circular(20),
                child: Padding(
                  padding: padding ?? EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ✨ بطاقة Neumorphic ثلاثية الأبعاد
class NeumorphicCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;

  const NeumorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  State<NeumorphicCard> createState() => _NeumorphicCardState();
}

class _NeumorphicCardState extends State<NeumorphicCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        margin: widget.margin ?? EdgeInsets.all(8),
        padding: widget.padding ?? EdgeInsets.all(16),
        decoration: ModernTheme.neumorphicDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius,
          isPressed: _pressed,
        ),
        child: widget.child,
      ),
    );
  }
}

/// 🌊 بطاقة متدرجة مع أنيميشن
class GradientCard extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enableHoverEffect;

  const GradientCard({
    Key? key,
    required this.child,
    required this.gradient,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.enableHoverEffect = true,
  }) : super(key: key);

  @override
  State<GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
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
      onTapDown: (_) {
        if (widget.enableHoverEffect) {
          setState(() => _isPressed = true);
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (widget.enableHoverEffect) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
        widget.onTap?.call();
      },
      onTapCancel: () {
        if (widget.enableHoverEffect) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin ?? EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              splashColor: Colors.white.withOpacity(0.1),
              highlightColor: Colors.white.withOpacity(0.05),
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 💫 بطاقة مع Shimmer Loading
class ShimmerCard extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 100,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, -0.3),
              end: Alignment(1.0 - _controller.value * 2, 0.3),
              colors: [
                Color(0xFFE7E7E7),
                Color(0xFFF4F4F4),
                Color(0xFFE7E7E7),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// 🎯 بطاقة وثيقة حديثة
class ModernDocumentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? status;
  final Color statusColor;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;

  const ModernDocumentCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.status,
    this.statusColor = const Color(0xFF667eea),
    this.onTap,
    this.leading,
    this.trailing,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
          if (status != null || actions != null) ...[
            SizedBox(height: 12),
            Row(
              children: [
                if (status != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      status!,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                if (actions != null) ...actions!,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
