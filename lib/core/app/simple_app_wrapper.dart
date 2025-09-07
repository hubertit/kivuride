import 'package:flutter/material.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class SimpleAppWrapper extends StatelessWidget {
  const SimpleAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Show splash screen first, then it will navigate to login
    return const SplashScreen();
  }
}
