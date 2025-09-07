import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/primary_button.dart';

class RideSelectionScreen extends ConsumerStatefulWidget {
  final String departure;
  final String destination;
  
  const RideSelectionScreen({
    super.key,
    required this.departure,
    required this.destination,
  });

  @override
  ConsumerState<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends ConsumerState<RideSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _selectedRideIndex = -1;
  bool _isLoading = false;

  // Mock available rides data
  final List<Map<String, dynamic>> _availableRides = [
    {
      'id': '1',
      'driver': 'John Driver',
      'rating': 4.8,
      'car': 'Toyota Corolla',
      'plate': 'RAA 123A',
      'color': 'White',
      'year': '2022',
      'estimatedTime': '3 min',
      'estimatedDistance': '1.2 km',
      'basePrice': 2500,
      'pricePerKm': 800,
      'totalPrice': 3500,
      'features': ['AC', 'WiFi', 'Charging'],
      'photo': null,
    },
    {
      'id': '2',
      'driver': 'Sarah Driver',
      'rating': 4.9,
      'car': 'Honda Civic',
      'plate': 'RAA 456B',
      'color': 'Black',
      'year': '2023',
      'estimatedTime': '5 min',
      'estimatedDistance': '1.8 km',
      'basePrice': 2500,
      'pricePerKm': 800,
      'totalPrice': 4000,
      'features': ['AC', 'WiFi'],
      'photo': null,
    },
    {
      'id': '3',
      'driver': 'Mike Driver',
      'rating': 4.7,
      'car': 'Nissan Altima',
      'plate': 'RAA 789C',
      'color': 'Silver',
      'year': '2021',
      'estimatedTime': '7 min',
      'estimatedDistance': '2.1 km',
      'basePrice': 2500,
      'pricePerKm': 800,
      'totalPrice': 4200,
      'features': ['AC'],
      'photo': null,
    },
    {
      'id': '4',
      'driver': 'Emma Driver',
      'rating': 4.9,
      'car': 'Toyota Camry',
      'plate': 'RAA 012D',
      'color': 'Blue',
      'year': '2023',
      'estimatedTime': '4 min',
      'estimatedDistance': '1.5 km',
      'basePrice': 2500,
      'pricePerKm': 800,
      'totalPrice': 3700,
      'features': ['AC', 'WiFi', 'Charging', 'Premium'],
      'photo': null,
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

  void _selectRide(int index) {
    setState(() {
      _selectedRideIndex = index;
    });
  }

  void _confirmRide() {
    if (_selectedRideIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: 'Please select a ride first'),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate ride confirmation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(message: 'Ride confirmed! Driver is on the way.'),
        );
        Navigator.pop(context);
      }
    });
  }

  Widget _buildRideCard(Map<String, dynamic> ride, int index) {
    final isSelected = _selectedRideIndex == index;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
          width: isSelected ? 2 : 1,
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
        onTap: () => _selectRide(index),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with driver info and price
              Row(
                children: [
                  // Driver avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    child: Center(
                      child: Text(
                        ride['driver'].toString().split(' ').map((e) => e[0]).join(),
                        style: AppTheme.titleMedium.copyWith(
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
                          ride['driver'],
                          style: AppTheme.titleSmall.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${ride['car']} • ${ride['plate']}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.warningColor,
                              size: 16,
                            ),
                            const SizedBox(width: AppTheme.spacing4),
                            Text(
                              ride['rating'].toString(),
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
                  
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${ride['totalPrice']} RWF',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Est. ${ride['estimatedTime']}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing12),
              
              // Car details
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: AppTheme.textSecondaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    '${ride['color']} ${ride['car']} ${ride['year']}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${ride['estimatedDistance']} away',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing12),
              
              // Features
              if (ride['features'].isNotEmpty)
                Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing4,
                  children: (ride['features'] as List).map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Text(
                        feature,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
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
          'Select Ride',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Route information
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  margin: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    children: [
                      // From location
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
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              widget.departure,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing8),
                      
                      // To location
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
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              widget.destination,
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
                
                // Available rides count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                  child: Row(
                    children: [
                      Text(
                        '${_availableRides.length} rides available',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Select one to continue',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacing16),
                
                // Rides list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                    itemCount: _availableRides.length,
                    itemBuilder: (context, index) {
                      return _buildRideCard(_availableRides[index], index);
                    },
                  ),
                ),
                
                // Confirm button
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                      top: BorderSide(color: AppTheme.borderColor),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: _selectedRideIndex == -1 
                            ? 'Select a ride to continue'
                            : 'Confirm Ride with ${_availableRides[_selectedRideIndex]['driver']}',
                        isLoading: _isLoading,
                        onPressed: _selectedRideIndex == -1 ? null : _confirmRide,
                        icon: Icons.check_circle,
                      ),
                    ),
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
