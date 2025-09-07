import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

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
      home: const SplashScreen(),
    );
  }
}

