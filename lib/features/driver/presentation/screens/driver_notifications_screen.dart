import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class DriverNotificationsScreen extends StatefulWidget {
  const DriverNotificationsScreen({super.key});

  @override
  State<DriverNotificationsScreen> createState() => _DriverNotificationsScreenState();
}

class _DriverNotificationsScreenState extends State<DriverNotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock notifications data
  List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'ride_request',
      'title': 'New Ride Request',
      'message': 'John Doe requested a ride from Kigali City Center to Airport',
      'time': '2 minutes ago',
      'isRead': false,
      'priority': 'high',
      'data': {
        'riderName': 'John Doe',
        'pickupLocation': 'Kigali City Center',
        'destination': 'Kigali International Airport',
        'estimatedFare': 'RWF 2,500',
      },
    },
    {
      'id': '2',
      'type': 'earnings',
      'title': 'Earnings Update',
      'message': 'You earned RWF 1,800 from your ride to Nyabugogo',
      'time': '1 hour ago',
      'isRead': false,
      'priority': 'medium',
      'data': {
        'amount': 'RWF 1,800',
        'rideId': 'RIDE-123',
      },
    },
    {
      'id': '3',
      'type': 'bonus',
      'title': 'Weekly Bonus',
      'message': 'Congratulations! You received a RWF 5,000 bonus for being a top driver this week',
      'time': '3 hours ago',
      'isRead': true,
      'priority': 'high',
      'data': {
        'amount': 'RWF 5,000',
        'reason': 'Top driver of the week',
      },
    },
    {
      'id': '4',
      'type': 'system',
      'title': 'App Update Available',
      'message': 'A new version of KivuRide is available with improved features',
      'time': '1 day ago',
      'isRead': true,
      'priority': 'low',
      'data': {
        'version': '1.1.0',
        'features': ['Improved navigation', 'Better ride tracking'],
      },
    },
    {
      'id': '5',
      'type': 'promotion',
      'title': 'Weekend Promotion',
      'message': 'Earn 20% extra on all rides this weekend!',
      'time': '2 days ago',
      'isRead': true,
      'priority': 'medium',
      'data': {
        'discount': '20%',
        'period': 'Weekend',
      },
    },
    {
      'id': '6',
      'type': 'ride_completed',
      'title': 'Ride Completed',
      'message': 'Your ride with Jane Smith has been completed successfully',
      'time': '3 days ago',
      'isRead': true,
      'priority': 'low',
      'data': {
        'riderName': 'Jane Smith',
        'rating': 5.0,
        'fare': 'RWF 1,200',
      },
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
      begin: const Offset(0, 0.1),
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

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.successSnackBar(message: 'All notifications marked as read'),
    );
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.infoSnackBar(message: 'Notification deleted'),
    );
  }

  int get _unreadCount => _notifications.where((n) => !n['isRead']).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'Notifications',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: AppTheme.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark All Read',
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
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing12,
                      vertical: AppTheme.spacing16,
                    ),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'No Notifications',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'You\'re all caught up! New notifications will appear here.',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    final priority = notification['priority'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.surfaceColor : AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(
          color: isRead ? AppTheme.borderColor : AppTheme.primaryColor.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification['id']),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: _getNotificationColor(type),
                  size: 20,
                ),
              ),

              const SizedBox(width: AppTheme.spacing12),

              // Notification Content
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
                        if (priority == 'high' && !isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
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

                    Row(
                      children: [
                        Text(
                          notification['time'],
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (type == 'ride_request' && !isRead)
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // TODO: Navigate to ride request
                                  _markAsRead(notification['id']);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing12,
                                    vertical: AppTheme.spacing4,
                                  ),
                                ),
                                child: Text(
                                  'View',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacing8),
                            ],
                          ),
                        IconButton(
                          onPressed: () => _deleteNotification(notification['id']),
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppTheme.textTertiaryColor,
                            size: 18,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'ride_request':
        return Icons.directions_car;
      case 'earnings':
        return Icons.attach_money;
      case 'bonus':
        return Icons.card_giftcard;
      case 'system':
        return Icons.system_update;
      case 'promotion':
        return Icons.local_offer;
      case 'ride_completed':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'ride_request':
        return AppTheme.primaryColor;
      case 'earnings':
        return AppTheme.successColor;
      case 'bonus':
        return AppTheme.warningColor;
      case 'system':
        return AppTheme.infoColor;
      case 'promotion':
        return AppTheme.primaryColor;
      case 'ride_completed':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
}
