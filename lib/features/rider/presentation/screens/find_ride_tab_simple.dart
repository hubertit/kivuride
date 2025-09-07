import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

class FindRideTabSimple extends ConsumerStatefulWidget {
  const FindRideTabSimple({super.key});

  @override
  ConsumerState<FindRideTabSimple> createState() => _FindRideTabSimpleState();
}

class _FindRideTabSimpleState extends ConsumerState<FindRideTabSimple>
    with TickerProviderStateMixin {
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;

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
    _departureController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _searchRides() {
    if (_departureController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: 'Please enter both departure and destination'),
      );
      return;
    }

    // Navigate directly to ride selection screen
    Navigator.pushNamed(
      context,
      '/ride-selection',
      arguments: {
        'departure': _departureController.text,
        'destination': _destinationController.text,
        'rideType': '', // Will be selected on the ride selection screen
      },
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
          'Find Ride',
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
                // Location Input Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing12,
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
                      // Departure Field
                      CustomTextField(
                        label: 'From',
                        hint: 'Enter departure location',
                        controller: _departureController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location, color: AppTheme.primaryColor),
                          onPressed: () {
                            // TODO: Get current location
                            _departureController.text = 'Current Location';
                          },
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Destination Field
                      CustomTextField(
                        label: 'To',
                        hint: 'Enter destination',
                        controller: _destinationController,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: AppTheme.primaryColor),
                          onPressed: _searchRides,
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacing16),

                      // Search Button
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: 'Find Rides',
                          isLoading: _isLoading,
                          onPressed: _isLoading ? null : _searchRides,
                          icon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                ),

                // Map Placeholder Section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        Text(
                          'Map View',
                          style: AppTheme.titleMedium.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Text(
                          'Enter your locations above to find rides',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Available Rides Counter
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: AppTheme.spacing12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4 rides available',
                                    style: AppTheme.titleSmall.copyWith(
                                      color: AppTheme.textPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Tap to see details and select',
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
