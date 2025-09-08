import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class DriverRidesTab extends StatefulWidget {
  const DriverRidesTab({super.key});

  @override
  State<DriverRidesTab> createState() => _DriverRidesTabState();
}

class _DriverRidesTabState extends State<DriverRidesTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _selectedTabIndex = 0; // 0: Active, 1: History

  // Mock data for active rides
  List<Map<String, dynamic>> _activeRides = [
    {
      'id': '1',
      'riderName': 'John Doe',
      'riderPhone': '+250 788 123 456',
      'pickupLocation': 'Kigali City Center',
      'destination': 'Kigali International Airport',
      'distance': '12.5 km',
      'estimatedFare': 'RWF 2,500',
      'estimatedTime': '25 min',
      'status': 'picked_up', // 'accepted', 'picked_up', 'completed'
      'pickupTime': '14:30',
      'carType': 'Standard',
    },
  ];

  // Mock data for ride history
  List<Map<String, dynamic>> _rideHistory = [
    {
      'id': '2',
      'riderName': 'Jane Smith',
      'pickupLocation': 'Kimisagara',
      'destination': 'Nyabugogo Bus Station',
      'distance': '8.2 km',
      'fare': 'RWF 1,800',
      'duration': '18 min',
      'date': '2024-01-15',
      'time': '12:15',
      'rating': 5.0,
      'status': 'completed',
      'carType': 'Premium',
    },
    {
      'id': '3',
      'riderName': 'Peter K.',
      'pickupLocation': 'Remera',
      'destination': 'Kacyiru',
      'distance': '6.8 km',
      'fare': 'RWF 1,200',
      'duration': '15 min',
      'date': '2024-01-15',
      'time': '10:45',
      'rating': 4.0,
      'status': 'completed',
      'carType': 'Standard',
    },
    {
      'id': '4',
      'riderName': 'Mary A.',
      'pickupLocation': 'Gikondo',
      'destination': 'Kicukiro',
      'distance': '4.5 km',
      'fare': 'RWF 900',
      'duration': '12 min',
      'date': '2024-01-14',
      'time': '18:20',
      'rating': 5.0,
      'status': 'completed',
      'carType': 'Standard',
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

  void _updateRideStatus(String rideId, String newStatus) {
    setState(() {
      final rideIndex = _activeRides.indexWhere((ride) => ride['id'] == rideId);
      if (rideIndex != -1) {
        _activeRides[rideIndex]['status'] = newStatus;
        
        // If completed, move to history
        if (newStatus == 'completed') {
          final completedRide = _activeRides[rideIndex];
          completedRide['date'] = '2024-01-15';
          completedRide['time'] = '15:00';
          completedRide['rating'] = 5.0;
          _rideHistory.insert(0, completedRide);
          _activeRides.removeAt(rideIndex);
        }
      }
    });
    
    String message = '';
    switch (newStatus) {
      case 'picked_up':
        message = 'Rider picked up successfully!';
        break;
      case 'completed':
        message = 'Ride completed!';
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.successSnackBar(message: message),
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
          'Rides',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textPrimaryColor),
            onPressed: () {
              // TODO: Refresh rides data
              ScaffoldMessenger.of(context).showSnackBar(
                AppTheme.infoSnackBar(message: 'Rides refreshed'),
              );
            },
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
                // Tab Selector
                Container(
                  margin: const EdgeInsets.all(AppTheme.spacing12),
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          'Active Rides',
                          _selectedTabIndex == 0,
                          () => setState(() => _selectedTabIndex = 0),
                          _activeRides.length,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          'History',
                          _selectedTabIndex == 1,
                          () => setState(() => _selectedTabIndex = 1),
                          _rideHistory.length,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _selectedTabIndex == 0
                      ? _buildActiveRidesContent()
                      : _buildHistoryContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap, int count) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacing12,
          horizontal: AppTheme.spacing16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
              ),
              child: Text(
                '$count',
                style: AppTheme.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRidesContent() {
    if (_activeRides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              'No Active Rides',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Accepted ride requests will appear here',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
      itemCount: _activeRides.length,
      itemBuilder: (context, index) {
        final ride = _activeRides[index];
        return _buildActiveRideCard(ride);
      },
    );
  }

  Widget _buildHistoryContent() {
    if (_rideHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppTheme.textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              'No Ride History',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Completed rides will appear here',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
      itemCount: _rideHistory.length,
      itemBuilder: (context, index) {
        final ride = _rideHistory[index];
        return _buildHistoryRideCard(ride);
      },
    );
  }

  Widget _buildActiveRideCard(Map<String, dynamic> ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  ride['riderName'].split(' ').map((n) => n[0]).join(''),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride['riderName'],
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ride['riderPhone'],
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(ride['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Text(
                  _getStatusText(ride['status']),
                  style: AppTheme.bodySmall.copyWith(
                    color: _getStatusColor(ride['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing16),

          // Route
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  ride['pickupLocation'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing8),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  ride['destination'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing16),

          // Trip details
          Row(
            children: [
              _buildTripDetail(Icons.route, ride['distance']),
              const SizedBox(width: AppTheme.spacing16),
              _buildTripDetail(Icons.access_time, ride['estimatedTime']),
              const SizedBox(width: AppTheme.spacing16),
              _buildTripDetail(Icons.attach_money, ride['estimatedFare']),
            ],
          ),

          const SizedBox(height: AppTheme.spacing20),

          // Action buttons
          _buildActionButtons(ride),
        ],
      ),
    );
  }

  Widget _buildHistoryRideCard(Map<String, dynamic> ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppTheme.successColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ride['pickupLocation']} → ${ride['destination']}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ride['date']} at ${ride['time']}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ride['rating']}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      ride['fare'],
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTripDetail(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> ride) {
    final status = ride['status'];
    
    if (status == 'accepted') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _updateRideStatus(ride['id'], 'picked_up'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
              ),
              child: Text(
                'Picked Up',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (status == 'picked_up') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateRideStatus(ride['id'], 'completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
              ),
              child: Text(
                'Complete Ride',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppTheme.primaryColor;
      case 'picked_up':
        return AppTheme.warningColor;
      case 'completed':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'picked_up':
        return 'Picked Up';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}
