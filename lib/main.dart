import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/app/simple_app_wrapper.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/rider/presentation/screens/notifications_screen.dart';
import 'features/rider/presentation/screens/recent_activities_screen.dart';
import 'features/rider/presentation/screens/ride_selection_screen.dart';
import 'features/rider/presentation/screens/payment_selection_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KivuRideApp(),
    ),
  );
}

class KivuRideApp extends StatelessWidget {
  const KivuRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const SimpleAppWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/recent-activities': (context) => const RecentActivitiesScreen(),
        '/ride-selection': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return RideSelectionScreen(
            departure: args['departure']!,
            destination: args['destination']!,
            rideType: args['rideType']!,
          );
        },
        '/payment-selection': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PaymentSelectionScreen(
            departure: args['departure'] as String,
            destination: args['destination'] as String,
            rideType: args['rideType'] as String,
            driverName: args['driverName'] as String,
            carModel: args['carModel'] as String,
            plateNumber: args['plateNumber'] as String,
            totalPrice: args['totalPrice'] as int,
          );
        },
      },
    );
  }
}

