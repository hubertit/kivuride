import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/mock_credentials.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/widgets/profile_avatar.dart';
import '../../../../shared/widgets/profile_menu_item.dart';
import '../../../../shared/widgets/profile_stats_card.dart';

class RiderProfileTab extends ConsumerStatefulWidget {
  const RiderProfileTab({super.key});

  @override
  ConsumerState<RiderProfileTab> createState() => _RiderProfileTabState();
}

class _RiderProfileTabState extends ConsumerState<RiderProfileTab> {
  // Mock user data - in real app, this would come from state management
  final userData = MockCredentials.riderAccount;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textPrimaryColor),
            onPressed: () {
              _showSettings(context);
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
            children: [
              // Profile Header
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
                  children: [
                    ProfileAvatar(
                      name: userData['name'] as String,
                      subtitle: 'Rider',
                      showEditButton: true,
                      onEditPressed: () {
                        _editProfile(context);
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      userData['name'] as String,
                      style: AppTheme.titleLarge.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      userData['email'] as String,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing12,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            '4.8',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),

              // Stats Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Stats',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatsCard(
                      title: 'Total Rides',
                      value: '45',
                      icon: Icons.directions_car,
                      onTap: () {
                        // TODO: Navigate to ride history
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: ProfileStatsCard(
                      title: 'Member Since',
                      value: 'Jan 2024',
                      icon: Icons.calendar_today,
                      onTap: () {
                        // TODO: Show account details
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacing32),

              // Menu Items
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => _editProfile(context),
              ),

              ProfileMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage your payment options',
                onTap: () {
                  // TODO: Navigate to payment methods
                },
              ),

              ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Saved Places',
                subtitle: 'Your favorite locations',
                onTap: () {
                  // TODO: Navigate to saved places
                },
              ),

              ProfileMenuItem(
                icon: Icons.history,
                title: 'Ride History',
                subtitle: 'View all your past rides',
                onTap: () {
                  // TODO: Navigate to ride history
                },
              ),

              const SizedBox(height: AppTheme.spacing24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Support',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'Get help and support',
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),

              ProfileMenuItem(
                icon: Icons.contact_support_outlined,
                title: 'Contact Us',
                subtitle: 'Reach out to our support team',
                onTap: () {
                  // TODO: Navigate to contact us
                },
              ),

              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'About KivuRide',
                subtitle: 'App version and information',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),

              const SizedBox(height: AppTheme.spacing24),

              // Account Actions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Actions',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Logout Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Sign Out',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacing8),

              // Delete Account Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.2),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    child: const Icon(
                      Icons.delete_forever,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Delete Account',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.infoSnackBar(message: 'Edit profile feature coming soon!'),
    );
  }

  void _showSettings(BuildContext context) {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.infoSnackBar(message: 'Settings feature coming soon!'),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          title: Text(
            'Sign Out',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                // Logout using auth provider
                await ref.read(authProvider.notifier).logout();
                // Navigate back to login screen
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                'Sign Out',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          title: Text(
            'Delete Account',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. This will permanently delete your account and remove all your data from our servers.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Are you sure you want to delete your account?',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete account logic
                ScaffoldMessenger.of(context).showSnackBar(
                  AppTheme.warningSnackBar(message: 'Account deletion feature coming soon!'),
                );
              },
              child: Text(
                'Delete Account',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
