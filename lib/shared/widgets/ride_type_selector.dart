import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RideTypeSelector extends StatelessWidget {
  final String selectedRideType;
  final Function(String) onRideTypeSelected;

  const RideTypeSelector({
    super.key,
    required this.selectedRideType,
    required this.onRideTypeSelected,
  });

  // Ride type data
  static const List<Map<String, dynamic>> rideTypes = [
    {
      'id': 'standard',
      'name': 'Standard',
      'description': 'Affordable everyday rides',
      'icon': Icons.directions_car,
      'basePrice': 2500,
      'pricePerKm': 800,
      'features': ['AC', 'Clean car'],
      'color': AppTheme.primaryColor,
    },
    {
      'id': 'premium',
      'name': 'Premium',
      'description': 'Luxury vehicles with extras',
      'icon': Icons.directions_car_filled,
      'basePrice': 3500,
      'pricePerKm': 1200,
      'features': ['AC', 'WiFi', 'Charging', 'Premium car'],
      'color': AppTheme.warningColor,
    },
    {
      'id': 'xl',
      'name': 'XL',
      'description': 'Larger vehicles for groups',
      'icon': Icons.airport_shuttle,
      'basePrice': 4000,
      'pricePerKm': 1000,
      'features': ['AC', '6+ seats', 'Luggage space'],
      'color': AppTheme.infoColor,
    },
    {
      'id': 'bike',
      'name': 'Bike',
      'description': 'Quick and affordable',
      'icon': Icons.two_wheeler,
      'basePrice': 1500,
      'pricePerKm': 500,
      'features': ['Helmet provided', 'Quick pickup'],
      'color': AppTheme.successColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Ride Type',
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        
        // Ride type cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: rideTypes.map((rideType) {
              final isSelected = selectedRideType == rideType['id'];
              
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: AppTheme.spacing12),
                child: InkWell(
                  onTap: () => onRideTypeSelected(rideType['id']),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? rideType['color'].withOpacity(0.1)
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                      border: Border.all(
                        color: isSelected 
                            ? rideType['color']
                            : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and name
                        Row(
                          children: [
                            Icon(
                              rideType['icon'],
                              color: rideType['color'],
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Expanded(
                              child: Text(
                                rideType['name'],
                                style: AppTheme.titleSmall.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppTheme.spacing8),
                        
                        // Description
                        Text(
                          rideType['description'],
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing8),
                        
                        // Price
                        Text(
                          '${rideType['basePrice']} RWF',
                          style: AppTheme.bodyMedium.copyWith(
                            color: rideType['color'],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacing4),
                        
                        // Features
                        Wrap(
                          spacing: AppTheme.spacing4,
                          runSpacing: AppTheme.spacing2,
                          children: (rideType['features'] as List).take(2).map((feature) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing6,
                                vertical: AppTheme.spacing2,
                              ),
                              decoration: BoxDecoration(
                                color: rideType['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius6),
                              ),
                              child: Text(
                                feature,
                                style: AppTheme.bodySmall.copyWith(
                                  color: rideType['color'],
                                  fontSize: 10,
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
            }).toList(),
          ),
        ),
      ],
    );
  }
}
