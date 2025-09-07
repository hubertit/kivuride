import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      focusNode: focusNode,
      style: AppTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: maxLength != null ? null : '',
        labelStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondaryColor,
        ),
        hintStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textHintColor,
        ),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacing16,
          horizontal: AppTheme.spacing16,
        ),
      ),
    );
  }
}
