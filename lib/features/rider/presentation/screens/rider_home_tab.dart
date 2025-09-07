import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RiderHomeTab extends StatelessWidget {
  final VoidCallback? onNavigateToFindRide;
  
  const RiderHomeTab({super.key, this.onNavigateToFindRide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'KivuRide',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Ready for your next ride?',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.search,
                      title: 'Find Ride',
                      subtitle: 'Book a ride',
                      onTap: () {
                        if (onNavigateToFindRide != null) {
                          onNavigateToFindRide!();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.history,
                      title: 'Recent Rides',
                      subtitle: 'View history',
                      onTap: () {
                        Navigator.pushNamed(context, '/recent-activities');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Recent Activity
              Text(
                'Recent Activity',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/recent-activities');
                },
                borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 48,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'No recent rides',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Your ride history will appear here',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      Text(
                        'Tap to view all activities',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              title,
              style: AppTheme.titleSmall.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
