import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppTheme.textPrimaryColor,
          side: BorderSide(
            color: borderColor ?? AppTheme.borderColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacing16,
            horizontal: AppTheme.spacing24,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppTheme.textPrimaryColor,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppTheme.spacing8),
                  ],
                  Text(
                    label,
                    style: AppTheme.labelLarge.copyWith(
                      color: textColor ?? AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
