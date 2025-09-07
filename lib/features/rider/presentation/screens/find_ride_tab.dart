import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/ride_type_selector.dart';

class FindRideTab extends ConsumerStatefulWidget {
  const FindRideTab({super.key});

  @override
  ConsumerState<FindRideTab> createState() => _FindRideTabState();
}

class _FindRideTabState extends ConsumerState<FindRideTab>
    with TickerProviderStateMixin {
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(-1.9441, 30.0619); // Kigali, Rwanda
  Set<Marker> _markers = {};
  bool _isLoading = false;
  String _selectedRideType = '';

  // Mock cab locations around Kigali
  final List<Map<String, dynamic>> _mockCabs = [
    {
      'id': '1',
      'position': const LatLng(-1.9441, 30.0619),
      'name': 'John Driver',
      'rating': 4.8,
      'car': 'Toyota Corolla',
      'plate': 'RAA 123A',
    },
    {
      'id': '2',
      'position': const LatLng(-1.9400, 30.0650),
      'name': 'Sarah Driver',
      'rating': 4.9,
      'car': 'Honda Civic',
      'plate': 'RAA 456B',
    },
    {
      'id': '3',
      'position': const LatLng(-1.9480, 30.0580),
      'name': 'Mike Driver',
      'rating': 4.7,
      'car': 'Nissan Altima',
      'plate': 'RAA 789C',
    },
    {
      'id': '4',
      'position': const LatLng(-1.9360, 30.0700),
      'name': 'Emma Driver',
      'rating': 4.9,
      'car': 'Toyota Camry',
      'plate': 'RAA 012D',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
    _addCabMarkers();
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

  void _addCabMarkers() {
    _markers.clear();
    for (var cab in _mockCabs) {
      _markers.add(
        Marker(
          markerId: MarkerId(cab['id']),
          position: cab['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: cab['name'],
            snippet: '${cab['car']} • ${cab['rating']} ⭐',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _searchRides() {
    if (_departureController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: 'Please enter both departure and destination'),
      );
      return;
    }

    if (_selectedRideType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: 'Please select a ride type first'),
      );
      return;
    }

    // Simulate search
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: AppTheme.textPrimaryColor),
            onPressed: () {
              // TODO: Get current location
              ScaffoldMessenger.of(context).showSnackBar(
                AppTheme.infoSnackBar(message: 'Getting your current location...'),
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
                      // Ride Type Selector
                      RideTypeSelector(
                        selectedRideType: _selectedRideType,
                        onRideTypeSelected: (rideType) {
                          setState(() {
                            _selectedRideType = rideType;
                          });
                        },
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Departure Field
                      CustomTextField(
                        label: 'From',
                        hint: 'Enter departure location',
                        controller: _departureController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Container(
                          width: 12,
                          height: 12,
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
                          width: 12,
                          height: 12,
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
                
                // Map Section
                Expanded(
                  child: Stack(
                    children: [
                      // Google Map
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 14.0,
                        ),
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        style: _getMapStyle(),
                      ),
                      
                      // Map Controls
                      Positioned(
                        top: AppTheme.spacing16,
                        right: AppTheme.spacing16,
                        child: Column(
                          children: [
                            // Zoom In
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, color: AppTheme.textPrimaryColor),
                                onPressed: () {
                                  _mapController?.animateCamera(
                                    CameraUpdate.zoomIn(),
                                  );
                                },
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacing8),
                            
                            // Zoom Out
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.remove, color: AppTheme.textPrimaryColor),
                                onPressed: () {
                                  _mapController?.animateCamera(
                                    CameraUpdate.zoomOut(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Available Rides Counter
                      Positioned(
                        bottom: AppTheme.spacing16,
                        left: AppTheme.spacing16,
                        right: AppTheme.spacing16,
                        child: InkWell(
                          onTap: () {
                            if (_departureController.text.isEmpty || _destinationController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppTheme.errorSnackBar(message: 'Please enter both departure and destination first'),
                              );
                              return;
                            }
                            
                            Navigator.pushNamed(
                              context,
                              '/ride-selection',
                              arguments: {
                                'departure': _departureController.text,
                                'destination': _destinationController.text,
                                'rideType': _selectedRideType,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacing16),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                              border: Border.all(color: AppTheme.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: AppTheme.spacing12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_mockCabs.length} rides available',
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
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.textSecondaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMapStyle() {
    // Dark map style for Tesla Robotaxi aesthetic
    return '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#181818"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1b1b1b"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#2c2c2c"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8a8a8a"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#373737"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3c3c3c"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#4e4e4e"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#000000"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3d3d3d"
          }
        ]
      }
    ]
    ''';
  }
}
