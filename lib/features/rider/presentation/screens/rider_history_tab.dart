import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class RiderHistoryTab extends ConsumerStatefulWidget {
  const RiderHistoryTab({super.key});

  @override
  ConsumerState<RiderHistoryTab> createState() => _RiderHistoryTabState();
}

class _RiderHistoryTabState extends ConsumerState<RiderHistoryTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'This Week', 'This Month', 'This Year'];

  // Mock trip data for Kigali locations
  final List<Map<String, dynamic>> _mockTrips = [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'from': 'Kigali International Airport',
      'to': 'Kigali City Center',
      'driver': 'John Driver',
      'driverRating': 4.8,
      'car': 'Toyota Corolla',
      'plate': 'RAA 123A',
      'distance': '12.5 km',
      'duration': '25 min',
      'cost': 4500,
      'status': 'completed',
      'paymentMethod': 'Mobile Money',
      'tripRating': 5,
      'route': 'KG 2 St → KN 4 Ave → KN 1 Rd',
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'from': 'Kigali Heights',
      'to': 'Kacyiru',
      'driver': 'Sarah Driver',
      'driverRating': 4.9,
      'car': 'Honda Civic',
      'plate': 'RAA 456B',
      'distance': '8.2 km',
      'duration': '18 min',
      'cost': 3200,
      'status': 'completed',
      'paymentMethod': 'Cash',
      'tripRating': 4,
      'route': 'KG 7 Ave → KG 2 St → KG 1 St',
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'from': 'Kimisagara',
      'to': 'Remera',
      'driver': 'Mike Driver',
      'driverRating': 4.7,
      'car': 'Nissan Altima',
      'plate': 'RAA 789C',
      'distance': '15.8 km',
      'duration': '35 min',
      'cost': 5200,
      'status': 'completed',
      'paymentMethod': 'Mobile Money',
      'tripRating': 5,
      'route': 'KG 2 St → KG 7 Ave → KG 1 St',
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'from': 'Nyamirambo',
      'to': 'Kigali Convention Centre',
      'driver': 'Emma Driver',
      'driverRating': 4.9,
      'car': 'Toyota Camry',
      'plate': 'RAA 012D',
      'distance': '6.5 km',
      'duration': '22 min',
      'cost': 2800,
      'status': 'completed',
      'paymentMethod': 'Card',
      'tripRating': 4,
      'route': 'KG 2 St → KN 4 Ave → KG 1 St',
    },
    {
      'id': '5',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'from': 'Gikondo',
      'to': 'Kigali Heights',
      'driver': 'David Driver',
      'driverRating': 4.6,
      'car': 'Hyundai Elantra',
      'plate': 'RAA 345E',
      'distance': '9.3 km',
      'duration': '20 min',
      'cost': 3600,
      'status': 'completed',
      'paymentMethod': 'Mobile Money',
      'tripRating': 4,
      'route': 'KG 2 St → KG 7 Ave → KG 1 St',
    },
    {
      'id': '6',
      'date': DateTime.now().subtract(const Duration(days: 14)),
      'from': 'Kacyiru',
      'to': 'Kimisagara',
      'driver': 'Grace Driver',
      'driverRating': 4.8,
      'car': 'Toyota RAV4',
      'plate': 'RAA 678F',
      'distance': '11.2 km',
      'duration': '28 min',
      'cost': 4200,
      'status': 'completed',
      'paymentMethod': 'Cash',
      'tripRating': 5,
      'route': 'KG 1 St → KG 2 St → KG 7 Ave',
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
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTrips {
    var trips = _mockTrips;
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      trips = trips.where((trip) {
        return trip['from'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
               trip['to'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
               trip['driver'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }
    
    // Filter by time period
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Week':
        trips = trips.where((trip) {
          final tripDate = trip['date'] as DateTime;
          return now.difference(tripDate).inDays <= 7;
        }).toList();
        break;
      case 'This Month':
        trips = trips.where((trip) {
          final tripDate = trip['date'] as DateTime;
          return now.difference(tripDate).inDays <= 30;
        }).toList();
        break;
      case 'This Year':
        trips = trips.where((trip) {
          final tripDate = trip['date'] as DateTime;
          return now.difference(tripDate).inDays <= 365;
        }).toList();
        break;
    }
    
    // Sort by date (newest first)
    trips.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    return trips;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(trip['date']),
                style: AppTheme.titleSmall.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Text(
                  'Completed',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing12),
          
          // Route information
          Row(
            children: [
              // From location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: Text(
                            trip['from'],
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: Text(
                            trip['to'],
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Trip details
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${trip['cost']} RWF',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _formatTime(trip['date']),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing12),
          
          // Driver information
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            child: Row(
              children: [
                // Driver avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  ),
                  child: Center(
                    child: Text(
                      trip['driver'].toString().split(' ').map((e) => e[0]).join(),
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacing12),
                
                // Driver details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['driver'],
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${trip['car']} • ${trip['plate']}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppTheme.warningColor,
                      size: 16,
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      trip['driverRating'].toString(),
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacing12),
          
          // Trip stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Distance', trip['distance']),
              _buildStatItem('Duration', trip['duration']),
              _buildStatItem('Payment', trip['paymentMethod']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
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
          'Ride History',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.textPrimaryColor),
            onPressed: () {
              _showFilterBottomSheet(context);
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
                // Search and filter section
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
                  child: Column(
                    children: [
                      // Search field
                      TextField(
                        controller: _searchController,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search trips, drivers, or locations...',
                          hintStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppTheme.textSecondaryColor,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppTheme.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            borderSide: BorderSide(color: AppTheme.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            borderSide: BorderSide(color: AppTheme.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Filter chips
                      SingleChildScrollView(
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
                    ],
                  ),
                ),
                
                // Trips list
                Expanded(
                  child: _filteredTrips.isEmpty
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
                                'No trips found',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                'Try adjusting your search or filter',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.spacing12),
                          itemCount: _filteredTrips.length,
                          itemBuilder: (context, index) {
                            return _buildTripCard(_filteredTrips[index]);
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadius16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Trips',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),
            ..._filters.map((filter) => ListTile(
              title: Text(
                filter,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              trailing: _selectedFilter == filter
                  ? Icon(Icons.check, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }
}
