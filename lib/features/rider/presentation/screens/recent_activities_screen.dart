import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class RecentActivitiesScreen extends ConsumerStatefulWidget {
  const RecentActivitiesScreen({super.key});

  @override
  ConsumerState<RecentActivitiesScreen> createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends ConsumerState<RecentActivitiesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Rides', 'Payments', 'Account'];

  // Mock activities data
  final List<Map<String, dynamic>> _mockActivities = [
    {
      'id': '1',
      'title': 'Ride Completed',
      'description': 'Trip from Kigali Heights to Kacyiru completed successfully',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'icon': Icons.check_circle,
      'color': AppTheme.successColor,
      'amount': '3,200 RWF',
      'status': 'completed',
    },
    {
      'id': '2',
      'title': 'Payment Processed',
      'description': 'Mobile Money payment of 3,200 RWF processed',
      'type': 'payment',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 12)),
      'icon': Icons.payment,
      'color': AppTheme.primaryColor,
      'amount': '3,200 RWF',
      'status': 'success',
    },
    {
      'id': '3',
      'title': 'Driver Assigned',
      'description': 'Sarah Driver (Honda Civic - RAA 456B) assigned to your ride',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.directions_car,
      'color': AppTheme.infoColor,
      'amount': null,
      'status': 'assigned',
    },
    {
      'id': '4',
      'title': 'Ride Requested',
      'description': 'Ride request from Kigali Heights to Kacyiru submitted',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 5)),
      'icon': Icons.search,
      'color': AppTheme.warningColor,
      'amount': null,
      'status': 'requested',
    },
    {
      'id': '5',
      'title': 'Profile Updated',
      'description': 'Your profile information has been updated',
      'type': 'account',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.person,
      'color': AppTheme.primaryColor,
      'amount': null,
      'status': 'updated',
    },
    {
      'id': '6',
      'title': 'Ride Cancelled',
      'description': 'Ride from Kimisagara to Remera was cancelled',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.cancel,
      'color': AppTheme.errorColor,
      'amount': '0 RWF',
      'status': 'cancelled',
    },
    {
      'id': '7',
      'title': 'Payment Refunded',
      'description': 'Refund of 5,200 RWF processed to your Mobile Money account',
      'type': 'payment',
      'timestamp': DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      'icon': Icons.account_balance_wallet,
      'color': AppTheme.successColor,
      'amount': '5,200 RWF',
      'status': 'refunded',
    },
    {
      'id': '8',
      'title': 'Account Created',
      'description': 'Welcome to KivuRide! Your account has been created successfully',
      'type': 'account',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
      'icon': Icons.celebration,
      'color': AppTheme.primaryColor,
      'amount': null,
      'status': 'created',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConfig.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredActivities {
    if (_selectedFilter == 'All') {
      return _mockActivities;
    }
    
    return _mockActivities.where((activity) {
      return activity['type'] == _selectedFilter.toLowerCase();
    }).toList();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacing12),
          
          // Activity content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity['title'],
                        style: AppTheme.titleSmall.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (activity['amount'] != null)
                      Text(
                        activity['amount'],
                        style: AppTheme.bodyMedium.copyWith(
                          color: activity['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacing4),
                
                Text(
                  activity['description'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacing8),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: activity['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Text(
                        activity['status'].toString().toUpperCase(),
                        style: AppTheme.bodySmall.copyWith(
                          color: activity['color'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    Text(
                      _formatTimestamp(activity['timestamp']),
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Recent Activities',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Filter chips
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Container(
                          margin: const EdgeInsets.only(right: AppTheme.spacing8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                            checkmarkColor: AppTheme.primaryColor,
                            labelStyle: AppTheme.bodySmall.copyWith(
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : AppTheme.textSecondaryColor,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                            backgroundColor: AppTheme.backgroundColor,
                            side: BorderSide(
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : AppTheme.borderColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                // Activities list
                Expanded(
                  child: _filteredActivities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(height: AppTheme.spacing16),
                              Text(
                                'No recent activities',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                'Your activities will appear here',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.spacing12),
                          itemCount: _filteredActivities.length,
                          itemBuilder: (context, index) {
                            return _buildActivityCard(_filteredActivities[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
