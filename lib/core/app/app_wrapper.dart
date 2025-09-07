import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/rider/presentation/screens/rider_home_screen.dart';
import '../../features/driver/presentation/screens/driver_home_screen.dart';

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Show loading screen while checking authentication
    if (authState.isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
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
