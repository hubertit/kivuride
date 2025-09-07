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
      'features': ['AC', 'Clean car'],
      'color': AppTheme.primaryColor,
    },
    {
      'id': 'premium',
      'name': 'Premium',
      'description': 'Luxury vehicles with extras',
      'icon': Icons.directions_car_filled,
      'features': ['AC', 'WiFi', 'Charging', 'Premium car'],
      'color': AppTheme.warningColor,
    },
    {
      'id': 'xl',
      'name': 'XL',
      'description': 'Larger vehicles for groups',
      'icon': Icons.airport_shuttle,
      'features': ['AC', '6+ seats', 'Luggage space'],
      'color': AppTheme.infoColor,
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
        
        // Ride type cards - compact horizontal layout
        Row(
          children: rideTypes.map((rideType) {
            final isSelected = selectedRideType == rideType['id'];
            
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: AppTheme.spacing8),
                child: InkWell(
                  onTap: () => onRideTypeSelected(rideType['id']),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? rideType['color'].withOpacity(0.1)
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      border: Border.all(
                        color: isSelected 
                            ? rideType['color']
                            : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Icon(
                          rideType['icon'],
                          color: rideType['color'],
                          size: 18,
                        ),
                        
                        const SizedBox(height: AppTheme.spacing4),
                        
                        // Name
                        Text(
                          rideType['name'],
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
