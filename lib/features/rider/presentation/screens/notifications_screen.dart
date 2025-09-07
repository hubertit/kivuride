import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Rides', 'Promotions', 'Updates'];

  // Mock notifications data
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': '1',
      'title': 'Ride Completed',
      'message': 'Your ride from Kigali Heights to Kacyiru has been completed successfully.',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
      'icon': Icons.check_circle,
      'color': AppTheme.successColor,
    },
    {
      'id': '2',
      'title': 'Driver Assigned',
      'message': 'John Driver (Toyota Corolla - RAA 123A) is on the way to pick you up.',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
      'icon': Icons.directions_car,
      'color': AppTheme.primaryColor,
    },
    {
      'id': '3',
      'title': 'Special Offer',
      'message': 'Get 20% off your next 3 rides! Use code SAVE20 at checkout.',
      'type': 'promotion',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
      'icon': Icons.local_offer,
      'color': AppTheme.warningColor,
    },
    {
      'id': '4',
      'title': 'Payment Successful',
      'message': 'Payment of 4,500 RWF for your ride has been processed successfully.',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'isRead': true,
      'icon': Icons.payment,
      'color': AppTheme.successColor,
    },
    {
      'id': '5',
      'title': 'App Update Available',
      'message': 'New features and improvements are available. Update now for the best experience.',
      'type': 'update',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.system_update,
      'color': AppTheme.infoColor,
    },
    {
      'id': '6',
      'title': 'Ride Cancelled',
      'message': 'Your ride from Kimisagara to Remera has been cancelled. No charges applied.',
      'type': 'ride',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'icon': Icons.cancel,
      'color': AppTheme.errorColor,
    },
    {
      'id': '7',
      'title': 'Welcome to KivuRide!',
      'message': 'Thank you for joining KivuRide. Enjoy your premium ride experience in Kigali.',
      'type': 'update',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
      'isRead': true,
      'icon': Icons.waving_hand,
      'color': AppTheme.primaryColor,
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

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _mockNotifications;
    }
    
    return _mockNotifications.where((notification) {
      return notification['type'] == _selectedFilter.toLowerCase();
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

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _mockNotifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _mockNotifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _mockNotifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.successSnackBar(message: 'All notifications marked as read'),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.surfaceColor : AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(
          color: isRead ? AppTheme.borderColor : AppTheme.primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification['id']),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              ),
              child: Icon(
                notification['icon'],
                color: notification['color'],
                size: 20,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacing12),
            
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: AppTheme.titleSmall.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacing4),
                  
                  Text(
                    notification['message'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacing8),
                  
                  Text(
                    _formatTimestamp(notification['timestamp']),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _mockNotifications.where((n) => !n['isRead']).length;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifications',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
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
                
                // Notifications list
                Expanded(
                  child: _filteredNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 64,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(height: AppTheme.spacing16),
                              Text(
                                'No notifications',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                'You\'re all caught up!',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.spacing12),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationCard(_filteredNotifications[index]);
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
