import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String identifier;
  final bool isPhone;
  
  const ResetPasswordScreen({
    super.key, 
    required this.identifier,
    required this.isPhone,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConfig.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.successSnackBar(
          message: 'Your password has been reset successfully! You can now sign in.',
        ),
      );
      
      // Navigate back to login screen
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(
          message: 'Failed to reset password. Please try again.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Reset Password',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing24,
          ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Column(
                          children: [
                            Text(
                              'Enter Reset Code',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'Enter the code sent to your ${widget.isPhone ? 'phone' : 'email'} and your new password.',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                                vertical: AppTheme.spacing8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.identifier,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Reset Code Field
                        CustomTextField(
                          label: 'Reset Code',
                          hint: 'Enter 6-digit code',
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 6,
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            color: AppTheme.textSecondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the reset code';
                            }
                            if (value.length != 6) {
                              return 'Please enter the 6-digit code';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // New Password Field
                        CustomTextField(
                          label: 'New Password',
                          hint: 'Enter your new password',
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppTheme.textSecondaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSecondaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: _validatePassword,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Confirm Password Field
                        CustomTextField(
                          label: 'Confirm New Password',
                          hint: 'Confirm your new password',
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppTheme.textSecondaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSecondaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Reset Password Button
                        PrimaryButton(
                          label: 'Reset Password',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _resetPassword,
                          icon: Icons.lock_reset,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Back to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Remember your password? ',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
