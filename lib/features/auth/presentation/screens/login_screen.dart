import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/utils/phone_input_formatter.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isPhoneLogin = true; // Default to phone login
  
  // Country picker for phone login
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
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Get the identifier based on login method
      final identifier = _isPhoneLogin 
          ? '+${_selectedCountry.phoneCode}${_phoneController.text.trim()}'
          : _emailController.text.trim();
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.successSnackBar(
          message: 'Login successful! Welcome to KivuRide.',
        ),
      );
      
      // Navigate to home screen (placeholder)
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(
          message: 'Login failed. Please check your credentials.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _navigateToForgotPassword() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const ForgotPasswordScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Logo and Welcome Text
                        Column(
                          children: [
                            // Tesla-inspired logo
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryVariant,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.directions_car,
                                size: 40,
                                color: AppTheme.backgroundColor,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing24),
                            
                            Text(
                              'Welcome Back',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'Sign in to continue your journey',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Login Method Toggle
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                            border: Border.all(
                              color: AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPhoneLogin = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppTheme.spacing12,
                                      horizontal: AppTheme.spacing16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isPhoneLogin 
                                          ? AppTheme.primaryColor.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_outlined,
                                          color: _isPhoneLogin 
                                              ? AppTheme.primaryColor
                                              : AppTheme.textSecondaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: AppTheme.spacing8),
                                        Text(
                                          'Phone',
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: _isPhoneLogin 
                                                ? AppTheme.primaryColor
                                                : AppTheme.textSecondaryColor,
                                            fontWeight: _isPhoneLogin 
                                                ? FontWeight.w600 
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPhoneLogin = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppTheme.spacing12,
                                      horizontal: AppTheme.spacing16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !_isPhoneLogin 
                                          ? AppTheme.primaryColor.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: !_isPhoneLogin 
                                              ? AppTheme.primaryColor
                                              : AppTheme.textSecondaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: AppTheme.spacing8),
                                        Text(
                                          'Email',
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: !_isPhoneLogin 
                                                ? AppTheme.primaryColor
                                                : AppTheme.textSecondaryColor,
                                            fontWeight: !_isPhoneLogin 
                                                ? FontWeight.w600 
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Email or Phone Input Field
                        if (!_isPhoneLogin) ...[
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
                        ] else ...[
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
                        ],
                        
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Password Field
                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          textInputAction: TextInputAction.done,
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
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacing12),
                        
                        // Remember Me and Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: AppTheme.primaryColor,
                                  checkColor: AppTheme.backgroundColor,
                                ),
                                Text(
                                  'Remember me',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: _navigateToForgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing32),
                        
                        // Login Button
                        PrimaryButton(
                          label: 'Sign In',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _handleLogin,
                          icon: Icons.arrow_forward,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppTheme.dividerColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                              ),
                              child: Text(
                                'OR',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textTertiaryColor,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppTheme.dividerColor),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToSignUp,
                              child: Text(
                                'Sign Up',
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
