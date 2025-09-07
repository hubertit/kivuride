import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/utils/phone_input_formatter.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  
  // Country picker for phone registration
  Country _selectedCountry = Country(
    phoneCode: '250',
    countryCode: 'RW',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Rwanda',
    example: '250123456789',
    displayName: 'Rwanda (RW) [+250]',
    displayNameNoCountryCode: 'Rwanda (RW)',
    e164Key: '250-RW-0',
  );

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: AppTheme.backgroundColor,
        textStyle: Theme.of(context).textTheme.bodyLarge!,
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.borderColor,
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.warningSnackBar(
          message: 'Please accept the terms and conditions.',
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Get form data
      final accountData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': '+${_selectedCountry.phoneCode}${_phoneController.text.trim()}',
        'password': _passwordController.text,
        'accountType': 'rider', // All registrations are for riders
      };
      
      // TODO: Send accountData to API
      print('Account data: $accountData');
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.successSnackBar(
          message: 'Rider account created successfully! Welcome to KivuRide.',
        ),
      );
      
      // Navigate to login screen
      Navigator.of(context).pop();
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(
          message: 'Sign up failed. Please try again.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          'Create Rider Account',
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
                        // Welcome Text
                        Column(
                          children: [
                            Text(
                              'Join KivuRide',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'Create your account to start riding',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Full Name Field
                        CustomTextField(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppTheme.textSecondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Email Field
                        CustomTextField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppTheme.textSecondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Phone Field with Country Code
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Country Code Picker
                              InkWell(
                                onTap: _showCountryPicker,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                                child: Container(
                                  height: 56, // Match TextFormField height
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor,
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                                    border: Border.all(
                                      color: AppTheme.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedCountry.flagEmoji,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(width: AppTheme.spacing4),
                                      Text(
                                        '+${_selectedCountry.phoneCode}',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(width: AppTheme.spacing4),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: AppTheme.textSecondaryColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing8),
                              // Phone Number Input
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    PhoneInputFormatter(),
                                  ],
                                  style: AppTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: '788606765',
                                    prefixIcon: const Icon(
                                      Icons.phone_outlined,
                                      color: AppTheme.textSecondaryColor,
                                    ),
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: AppTheme.spacing16,
                                      horizontal: AppTheme.spacing16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (value.length < 10) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Password Field
                        CustomTextField(
                          label: 'Password',
                          hint: 'Create a password',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Confirm Password Field
                        CustomTextField(
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
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
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Terms and Conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: AppTheme.primaryColor,
                              checkColor: AppTheme.backgroundColor,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Sign Up Button
                        PrimaryButton(
                          label: 'Create Rider Account',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleSignUp,
                          icon: Icons.person_add,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
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
                        
                        const SizedBox(height: AppTheme.spacing32),
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
