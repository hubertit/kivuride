import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DriverProfileTab extends StatelessWidget {
  const DriverProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 64,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Driver Profile',
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Manage your driver account and vehicle information',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
