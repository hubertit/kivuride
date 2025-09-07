import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

class SimpleAppWrapper extends StatelessWidget {
  const SimpleAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, just show the login screen directly
    // This bypasses the auth provider to avoid loading issues
    return const LoginScreen();
  }
}
