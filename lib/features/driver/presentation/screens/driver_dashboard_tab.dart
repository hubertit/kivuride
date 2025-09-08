import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DriverDashboardTab extends StatefulWidget {
  const DriverDashboardTab({super.key});

  @override
  State<DriverDashboardTab> createState() => _DriverDashboardTabState();
}

class _DriverDashboardTabState extends State<DriverDashboardTab> {
  bool _isOnline = true;
  List<Map<String, dynamic>> _rideRequests = [
    {
      'id': '1',
      'riderName': 'John Doe',
      'pickupLocation': 'Kigali City Center',
      'destination': 'Kigali International Airport',
      'distance': '12.5 km',
      'estimatedFare': 'RWF 2,500',
      'estimatedTime': '25 min',
      'riderRating': 4.8,
      'carType': 'Standard',
    },
    {
      'id': '2',
      'riderName': 'Jane Smith',
      'pickupLocation': 'Kimisagara',
      'destination': 'Nyabugogo Bus Station',
      'distance': '8.2 km',
      'estimatedFare': 'RWF 1,800',
      'estimatedTime': '18 min',
      'riderRating': 4.9,
      'carType': 'Premium',
    },
  ];

  void _acceptRideRequest(String requestId) {
    setState(() {
      _rideRequests.removeWhere((request) => request['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.successSnackBar(message: 'Ride request accepted!'),
    );
  }

  void _rejectRideRequest(String requestId) {
    setState(() {
      _rideRequests.removeWhere((request) => request['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.infoSnackBar(message: 'Ride request rejected'),
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
          'Driver Dashboard',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimaryColor),
            onPressed: () {
              // TODO: Navigate to notifications
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
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isOnline
                        ? [
                            AppTheme.successColor.withOpacity(0.1),
                            AppTheme.successColor.withOpacity(0.05),
                          ]
                        : [
                            AppTheme.errorColor.withOpacity(0.1),
                            AppTheme.errorColor.withOpacity(0.05),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                  border: Border.all(
                    color: _isOnline
                        ? AppTheme.successColor.withOpacity(0.2)
                        : AppTheme.errorColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing8),
                          decoration: BoxDecoration(
                            color: _isOnline
                                ? AppTheme.successColor.withOpacity(0.2)
                                : AppTheme.errorColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                          ),
                          child: Icon(
                            _isOnline ? Icons.check_circle : Icons.cancel,
                            color: _isOnline ? AppTheme.successColor : AppTheme.errorColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isOnline ? 'Online' : 'Offline',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _isOnline ? 'Ready to accept rides' : 'Not accepting rides',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isOnline,
                          onChanged: (value) {
                            setState(() {
                              _isOnline = value;
                            });
                          },
                          activeColor: AppTheme.successColor,
                          inactiveThumbColor: AppTheme.errorColor,
                          inactiveTrackColor: AppTheme.errorColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Quick Stats
              Text(
                'Today\'s Stats',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.directions_car,
                      title: 'Rides',
                      value: '0',
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.attach_money,
                      title: 'Earnings',
                      value: 'RWF 0',
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Ride Requests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ride Requests',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_rideRequests.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      ),
                      child: Text(
                        '${_rideRequests.length}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              if (_rideRequests.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing24),
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
                        color: AppTheme.textSecondaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'No ride requests',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Stay online to receive ride requests',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ..._rideRequests.map((request) => _buildRideRequestCard(request)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
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
            color: color,
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            value,
            style: AppTheme.titleLarge.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideRequestCard(Map<String, dynamic> request) {
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
          // Header with rider name and rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  request['riderName'].split(' ').map((n) => n[0]).join(''),
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
                      request['riderName'],
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.warningColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${request['riderRating']}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
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
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Text(
                  request['carType'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing16),
          
          // Route information
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
                  request['pickupLocation'],
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
                  request['destination'],
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
              _buildTripDetail(Icons.route, request['distance']),
              const SizedBox(width: AppTheme.spacing16),
              _buildTripDetail(Icons.access_time, request['estimatedTime']),
              const SizedBox(width: AppTheme.spacing16),
              _buildTripDetail(Icons.attach_money, request['estimatedFare']),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rejectRideRequest(request['id']),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.errorColor),
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptRideRequest(request['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
}
