import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A skeleton loading widget that provides a shimmer effect
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.borderRadius8),
        color: widget.baseColor ?? AppTheme.surfaceColor,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.borderRadius8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  widget.baseColor ?? AppTheme.surfaceColor,
                  widget.highlightColor ?? AppTheme.surfaceColor.withOpacity(0.3),
                  widget.baseColor ?? AppTheme.surfaceColor,
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Predefined skeleton loaders for common UI patterns
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;

  const SkeletonCard({
    super.key,
    this.width,
    this.height = 120.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final EdgeInsets? margin;

  const SkeletonAvatar({
    super.key,
    this.size = 40.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      margin: margin,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

class SkeletonButton extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;

  const SkeletonButton({
    super.key,
    this.width,
    this.height = 48.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
    );
  }
}

/// A skeleton for list items
class SkeletonListItem extends StatelessWidget {
  final EdgeInsets? margin;

  const SkeletonListItem({
    super.key,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      child: const Row(
        children: [
          SkeletonAvatar(size: 48.0),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: double.infinity, height: 16.0),
                SizedBox(height: AppTheme.spacing8),
                SkeletonText(width: 120.0, height: 14.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A skeleton for ride cards
class SkeletonRideCard extends StatelessWidget {
  final EdgeInsets? margin;

  const SkeletonRideCard({
    super.key,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonAvatar(size: 40.0),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 120.0, height: 16.0),
                    SizedBox(height: AppTheme.spacing4),
                    SkeletonText(width: 80.0, height: 14.0),
                  ],
                ),
              ),
              SkeletonText(width: 60.0, height: 16.0),
            ],
          ),
          SizedBox(height: AppTheme.spacing16),
          SkeletonText(width: double.infinity, height: 14.0),
          SizedBox(height: AppTheme.spacing8),
          SkeletonText(width: 200.0, height: 14.0),
          SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              SkeletonButton(width: 100.0, height: 36.0),
              SizedBox(width: AppTheme.spacing12),
              SkeletonButton(width: 80.0, height: 36.0),
            ],
          ),
        ],
      ),
    );
  }
}
