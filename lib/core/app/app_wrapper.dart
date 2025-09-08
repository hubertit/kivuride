import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/rider/presentation/screens/rider_home_screen.dart';
import '../../features/driver/presentation/screens/driver_home_screen.dart';
import '../../shared/widgets/skeleton_loader.dart';

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Show loading screen while checking authentication (with timeout)
    if (authState.isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo Skeleton
                const SkeletonAvatar(size: 80.0),
                const SizedBox(height: AppTheme.spacing24),
                
                // App Name Skeleton
                const SkeletonText(width: 200.0, height: 24.0),
                const SizedBox(height: AppTheme.spacing8),
                
                // Subtitle Skeleton
                const SkeletonText(width: 150.0, height: 16.0),
                const SizedBox(height: AppTheme.spacing32),
                
                // Loading indicator
                const CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: AppTheme.spacing16),
                
                Text(
                  'Loading KivuRide...',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Route based on authentication status
    if (authState.isLoggedIn) {
      final accountType = authState.userData?['accountType'];
      
      if (accountType == 'rider') {
        // Route riders to Find Ride screen (index 1 in the bottom nav)
        return const RiderHomeScreen(initialIndex: 1);
      } else if (accountType == 'driver') {
        return const DriverHomeScreen();
      }
    }

    // Not logged in - show login screen
    return const LoginScreen();
  }
}
