import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../rider/presentation/screens/rider_home_screen.dart';
import '../../../driver/presentation/screens/driver_home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressOpacity;
  
  String _appVersionText = 'Version ${AppConfig.appVersion}';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAppVersion();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _progressOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersionText = 'Version ${info.version} (${info.buildNumber})';
      });
    } catch (_) {
      // Ignore version fetch errors
    }
  }

  Future<void> _startSplashSequence() async {
    // Start logo animation
    _logoController.forward();
    
    // Start text animation after logo starts
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 300));
    _progressController.forward();
    
    // Wait for splash duration and check auth status
    await Future.delayed(const Duration(milliseconds: AppConfig.splashDuration));
    
    if (!mounted) return;
    
    // Check authentication status and navigate accordingly
    _navigateBasedOnAuthStatus();
  }

  void _navigateBasedOnAuthStatus() {
    final authState = ref.read(authProvider);
    
    if (authState.isLoading) {
      // Still loading, wait a bit more
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _navigateBasedOnAuthStatus();
      });
      return;
    }
    
    if (authState.isLoggedIn && authState.userData != null) {
      // User is logged in, navigate to appropriate home screen
      final accountType = authState.userData!['accountType'] as String?;
      
      if (accountType == 'rider') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RiderHomeScreen()),
        );
      } else if (accountType == 'driver') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
        );
      } else {
        // Unknown account type, go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // User is not logged in, go to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.surfaceColor,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Top spacer
            const Spacer(flex: 2),
            
            // Logo and App Name
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Opacity(
                    opacity: _logoOpacity.value,
                    child: Column(
                      children: [
                        // Tesla-inspired logo placeholder
                        Container(
                          width: 120,
                          height: 120,
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
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            size: 60,
                            color: AppTheme.backgroundColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // App Name
                        AnimatedBuilder(
                          animation: _textController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textOpacity.value,
                              child: Column(
                                children: [
                                  Text(
                                    AppConfig.appName,
                                    style: AppTheme.headlineLarge.copyWith(
                                      color: AppTheme.textPrimaryColor,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: AppTheme.spacing8),
                                  Text(
                                    'Your Premium Ride Experience',
                                    style: AppTheme.bodyLarge.copyWith(
                                      color: AppTheme.textSecondaryColor,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Middle spacer
            const Spacer(flex: 2),
            
            // Loading indicator
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Opacity(
                  opacity: _progressOpacity.value,
                  child: Column(
                    children: [
                      // Custom progress indicator
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return Container(
                                  width: 200 * _progressController.value,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor,
                                        AppTheme.primaryVariant,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'Initializing...',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textTertiaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Bottom spacer
            const Spacer(flex: 1),
            
            // Footer
            Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.spacing24,
                right: AppTheme.spacing24,
                bottom: AppTheme.spacing24,
                top: AppTheme.spacing16,
              ),
              child: Column(
                children: [
                  Text(
                    '© ${DateTime.now().year} KivuRide',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textTertiaryColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    _appVersionText,
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}