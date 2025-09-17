import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

class FindRideTab extends ConsumerStatefulWidget {
  const FindRideTab({super.key});

  @override
  ConsumerState<FindRideTab> createState() => _FindRideTabState();
}

class _FindRideTabState extends ConsumerState<FindRideTab> {
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  
  // Google Maps controller
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _isLoadingLocation = false;
  Position? _currentPosition;
  String _currentLocationName = '';
  
  // Location search
  List<Placemark> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  final FocusNode _departureFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();
  
  // Always use dark mode

  // Map camera position
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9441, 30.0619), // Kigali center
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndName();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _departureFocusNode.addListener(() {
      if (_departureFocusNode.hasFocus) {
        setState(() {
          _showSearchResults = true;
        });
      }
    });
    
    _destinationFocusNode.addListener(() {
      if (_destinationFocusNode.hasFocus) {
        setState(() {
          _showSearchResults = true;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });
    print('🗺️ Map created successfully!');
  }

  Future<void> _getCurrentLocationAndName() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError('Location services are disabled.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError('Location permissions are permanently denied.');
        return;
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      // Get location name using geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String locationName = '';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        locationName = _formatLocationName(place);
      }

      setState(() {
        _currentPosition = position;
        _currentLocationName = locationName;
        _departureController.text = locationName.isNotEmpty ? locationName : 'Current Location';
        _isLoadingLocation = false;
      });

      // Update map camera to current location
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: AppConfig.defaultZoomLevel,
            ),
          ),
        );
      }

    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showLocationError('Failed to get location: ${e.toString()}');
    }
  }

  Future<void> _getCurrentLocation() async {
    await _getCurrentLocationAndName();
  }

  String _formatLocationName(Placemark place) {
    List<String> parts = [];
    
    if (place.street != null && place.street!.isNotEmpty) {
      parts.add(place.street!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }
    
    return parts.join(', ');
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // First try to find from predefined Kigali locations
      List<Placemark> kigaliResults = _searchKigaliLocations(query);
      
      if (kigaliResults.isNotEmpty) {
        setState(() {
          _searchResults = kigaliResults.take(5).toList(); // Limit to 5 results
          _showSearchResults = true;
          _isSearching = false;
        });
        return;
      }

      // If no predefined results, try geocoding with Kigali context
      String searchQuery = query.toLowerCase().contains('kigali') 
          ? query 
          : '$query, Kigali, Rwanda';
      
      List<Location> locations = await locationFromAddress(searchQuery);
      List<Placemark> placemarks = [];
      
      for (Location location in locations) {
        List<Placemark> placemarkList = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        placemarks.addAll(placemarkList);
      }

      // Filter results to ensure they're in Kigali area
      List<Placemark> filteredResults = placemarks.where((place) {
        return place.administrativeArea?.toLowerCase().contains('kigali') == true ||
               place.country?.toLowerCase().contains('rwanda') == true;
      }).toList();

      setState(() {
        _searchResults = filteredResults.take(5).toList(); // Limit to 5 results
        _showSearchResults = true;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      print('Search error: $e');
    }
  }

  List<Placemark> _searchKigaliLocations(String query) {
    final queryLower = query.toLowerCase().trim();
    final kigaliLocations = _getKigaliLocations();
    
    // Split query into words for better matching
    final queryWords = queryLower.split(' ').where((word) => word.isNotEmpty).toList();
    
    return kigaliLocations.where((location) {
      final name = location['name']?.toLowerCase() ?? '';
      final area = location['area']?.toLowerCase() ?? '';
      final description = location['description']?.toLowerCase() ?? '';
      final street = location['street']?.toLowerCase() ?? '';
      
      // Exact match (highest priority)
      if (name.contains(queryLower) || area.contains(queryLower)) {
        return true;
      }
      
      // Word-by-word matching for better results
      bool matchesAllWords = queryWords.every((word) => 
        name.contains(word) || 
        area.contains(word) || 
        description.contains(word) ||
        street.contains(word)
      );
      
      if (matchesAllWords) {
        return true;
      }
      
      // Partial word matching
      bool matchesAnyWord = queryWords.any((word) => 
        name.contains(word) || 
        area.contains(word) || 
        description.contains(word) ||
        street.contains(word)
      );
      
      return matchesAnyWord;
    }).map((location) => Placemark(
      name: location['name'],
      street: location['street'],
      locality: location['area'],
      administrativeArea: 'Kigali',
      country: 'Rwanda',
      postalCode: location['postalCode'],
      subLocality: location['area'],
    )).toList();
  }

  List<Map<String, String>> _getKigaliLocations() {
    return [
      // Government & Institutions
      {'name': 'Kigali International Airport', 'area': 'Kanombe', 'street': 'Airport Road', 'description': 'Main international airport', 'postalCode': '00000'},
      {'name': 'Kigali Convention Centre', 'area': 'Kimihurura', 'street': 'KG 2 Roundabout', 'description': 'Convention center and events venue', 'postalCode': '00000'},
      {'name': 'Parliament of Rwanda', 'area': 'Kimihurura', 'street': 'KG 2 Roundabout', 'description': 'National parliament building', 'postalCode': '00000'},
      {'name': 'Ministry of Health', 'area': 'Kimihurura', 'street': 'KG 2 Roundabout', 'description': 'Government health ministry', 'postalCode': '00000'},
      {'name': 'Rwanda Revenue Authority', 'area': 'Kimihurura', 'street': 'KG 2 Roundabout', 'description': 'Tax and revenue authority', 'postalCode': '00000'},
      
      // Universities & Education
      {'name': 'University of Rwanda', 'area': 'Huye', 'street': 'University Road', 'description': 'Main university campus', 'postalCode': '00000'},
      {'name': 'Kigali Institute of Science and Technology', 'area': 'Kacyiru', 'street': 'KG 7 St', 'description': 'Technical university', 'postalCode': '00000'},
      {'name': 'University of Kigali', 'area': 'Kacyiru', 'street': 'KG 7 St', 'description': 'Private university', 'postalCode': '00000'},
      {'name': 'Akilah Institute', 'area': 'Kacyiru', 'street': 'KG 7 St', 'description': 'Women\'s leadership institute', 'postalCode': '00000'},
      
      // Shopping & Commercial
      {'name': 'Kigali City Tower', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Major shopping and office complex', 'postalCode': '00000'},
      {'name': 'Kigali Heights', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Shopping mall and offices', 'postalCode': '00000'},
      {'name': 'Simba Supermarket', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Popular supermarket chain', 'postalCode': '00000'},
      {'name': 'Nakumatt', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Shopping center', 'postalCode': '00000'},
      {'name': 'Kimisagara Market', 'area': 'Kimisagara', 'street': 'Market Street', 'description': 'Traditional market', 'postalCode': '00000'},
      {'name': 'Nyabugogo Market', 'area': 'Nyabugogo', 'street': 'Market Street', 'description': 'Bus station and market', 'postalCode': '00000'},
      
      // Hotels & Accommodation
      {'name': 'Kigali Marriott Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Luxury hotel Marriott', 'postalCode': '00000'},
      {'name': 'Marriott Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Luxury hotel Marriott', 'postalCode': '00000'},
      {'name': 'Radisson Blu Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Business hotel Radisson', 'postalCode': '00000'},
      {'name': 'Radisson Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Business hotel Radisson', 'postalCode': '00000'},
      {'name': 'Hotel des Mille Collines', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Historic hotel Mille Collines', 'postalCode': '00000'},
      {'name': 'Mille Collines Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Historic hotel Mille Collines', 'postalCode': '00000'},
      {'name': 'Kigali Serena Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Luxury hotel Serena', 'postalCode': '00000'},
      {'name': 'Serena Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Luxury hotel Serena', 'postalCode': '00000'},
      {'name': 'Ubumwe Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Business hotel Ubumwe', 'postalCode': '00000'},
      {'name': 'Kigali Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Business hotel', 'postalCode': '00000'},
      {'name': 'Hotel Rwanda', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Historic hotel', 'postalCode': '00000'},
      {'name': 'Kigali Business Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Business hotel', 'postalCode': '00000'},
      {'name': 'Kigali City Hotel', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'City hotel', 'postalCode': '00000'},
      
      // Hospitals & Healthcare
      {'name': 'King Faisal Hospital', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Major hospital', 'postalCode': '00000'},
      {'name': 'Kigali University Teaching Hospital', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Teaching hospital', 'postalCode': '00000'},
      {'name': 'Rwanda Military Hospital', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Military hospital', 'postalCode': '00000'},
      {'name': 'Kigali Central Hospital', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Central hospital', 'postalCode': '00000'},
      
      // Banks & Financial
      {'name': 'Bank of Kigali', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Main bank headquarters', 'postalCode': '00000'},
      {'name': 'Ecobank Rwanda', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'International bank', 'postalCode': '00000'},
      {'name': 'Equity Bank Rwanda', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Commercial bank', 'postalCode': '00000'},
      {'name': 'Rwanda Development Bank', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Development bank', 'postalCode': '00000'},
      
      // Embassies & International
      {'name': 'US Embassy', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'United States embassy', 'postalCode': '00000'},
      {'name': 'British High Commission', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'British diplomatic mission', 'postalCode': '00000'},
      {'name': 'French Embassy', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'French diplomatic mission', 'postalCode': '00000'},
      {'name': 'German Embassy', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'German diplomatic mission', 'postalCode': '00000'},
      
      // Residential Areas
      {'name': 'Kacyiru', 'area': 'Kacyiru', 'street': 'KG 7 St', 'description': 'Government district', 'postalCode': '00000'},
      {'name': 'Kimisagara', 'area': 'Kimisagara', 'street': 'KG 2 Roundabout', 'description': 'Central business district', 'postalCode': '00000'},
      {'name': 'Nyabugogo', 'area': 'Nyabugogo', 'street': 'Bus Station Road', 'description': 'Transport hub', 'postalCode': '00000'},
      {'name': 'Remera', 'area': 'Remera', 'street': 'KG 17 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Gikondo', 'area': 'Gikondo', 'street': 'KG 2 St', 'description': 'Industrial area', 'postalCode': '00000'},
      {'name': 'Kicukiro', 'area': 'Kicukiro', 'street': 'KG 2 St', 'description': 'Residential district', 'postalCode': '00000'},
      {'name': 'Nyarutarama', 'area': 'Nyarutarama', 'street': 'KG 7 St', 'description': 'Upscale residential area', 'postalCode': '00000'},
      {'name': 'Kibagabaga', 'area': 'Kibagabaga', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Kimironko', 'area': 'Kimironko', 'street': 'KG 17 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Gisozi', 'area': 'Gisozi', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Kinyinya', 'area': 'Kinyinya', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Rusororo', 'area': 'Rusororo', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Bumbogo', 'area': 'Bumbogo', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      {'name': 'Rwampara', 'area': 'Rwampara', 'street': 'KG 7 St', 'description': 'Residential area', 'postalCode': '00000'},
      
      // Landmarks & Tourist Attractions
      {'name': 'Kigali Genocide Memorial', 'area': 'Gisozi', 'street': 'KG 7 St', 'description': 'Genocide memorial center', 'postalCode': '00000'},
      {'name': 'Camp Kigali Memorial', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Memorial site', 'postalCode': '00000'},
      {'name': 'Presidential Palace Museum', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Former presidential palace', 'postalCode': '00000'},
      {'name': 'Inema Arts Center', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Art gallery and cultural center', 'postalCode': '00000'},
      {'name': 'Kigali Cultural Village', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Cultural heritage site', 'postalCode': '00000'},
      
      // Sports & Recreation
      {'name': 'Amahoro Stadium', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'National stadium', 'postalCode': '00000'},
      {'name': 'Kigali Golf Club', 'area': 'Nyarutarama', 'street': 'KG 7 St', 'description': 'Golf course', 'postalCode': '00000'},
      {'name': 'Kigali Arena', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Sports arena', 'postalCode': '00000'},
      
      // Transport Hubs
      {'name': 'Nyabugogo Bus Station', 'area': 'Nyabugogo', 'street': 'Bus Station Road', 'description': 'Main bus terminal', 'postalCode': '00000'},
      {'name': 'Kigali Central Bus Station', 'area': 'Kimisagara', 'street': 'KG 2 Roundabout', 'description': 'Central bus station', 'postalCode': '00000'},
      {'name': 'Kigali Railway Station', 'area': 'Nyabugogo', 'street': 'Railway Road', 'description': 'Train station', 'postalCode': '00000'},
      
      // Tech & Innovation
      {'name': 'Kigali Innovation City', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Tech innovation hub', 'postalCode': '00000'},
      {'name': 'Norrsken House', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Entrepreneurship hub', 'postalCode': '00000'},
      {'name': 'KLab', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Tech incubator', 'postalCode': '00000'},
      
      // Restaurants & Entertainment
      {'name': 'Heaven Restaurant', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Popular restaurant Heaven', 'postalCode': '00000'},
      {'name': 'Heaven', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Popular restaurant Heaven', 'postalCode': '00000'},
      {'name': 'Sole Luna', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Italian restaurant Sole Luna', 'postalCode': '00000'},
      {'name': 'Khana Khazana', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Indian restaurant Khana Khazana', 'postalCode': '00000'},
      {'name': 'Repub Lounge', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Bar and lounge Repub', 'postalCode': '00000'},
      {'name': 'Repub', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Bar and lounge Repub', 'postalCode': '00000'},
      {'name': 'Bourbon Coffee', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Coffee shop Bourbon', 'postalCode': '00000'},
      {'name': 'Bourbon', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Coffee shop Bourbon', 'postalCode': '00000'},
      {'name': 'Café de Kigali', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Coffee shop café', 'postalCode': '00000'},
      {'name': 'Kigali Coffee', 'area': 'Kimihurura', 'street': 'KG 2 St', 'description': 'Coffee shop', 'postalCode': '00000'},
      
      // Religious Sites
      {'name': 'Kigali Cathedral', 'area': 'Kimisagara', 'street': 'KG 2 Roundabout', 'description': 'Catholic cathedral', 'postalCode': '00000'},
      {'name': 'Kigali Central Mosque', 'area': 'Kimisagara', 'street': 'KG 2 Roundabout', 'description': 'Main mosque', 'postalCode': '00000'},
      {'name': 'Kigali Anglican Church', 'area': 'Kacyiru', 'street': 'KG 7 St', 'description': 'Anglican church', 'postalCode': '00000'},
    ];
  }

  void _selectLocation(Placemark placemark, bool isDeparture) {
    String locationName = _formatLocationName(placemark);
    
    if (isDeparture) {
      _departureController.text = locationName;
      _departureFocusNode.unfocus();
    } else {
      _destinationController.text = locationName;
      _destinationFocusNode.unfocus();
    }
    
    setState(() {
      _showSearchResults = false;
      _searchResults = [];
    });
  }

  void _showLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: message),
      );
    }
  }

  void _onFindRidePressed() {
    if (_departureController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(
          message: 'Please enter both departure and destination',
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      AppTheme.successSnackBar(
        message: 'Finding rides from ${_departureController.text} to ${_destinationController.text}',
      ),
    );
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _departureFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Stack(
        children: [
          // Google Maps
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: true,
            style: _darkMapStyle,
          ),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF333333), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
          ),
        ],
      ),
            child: Column(
              children: [
                  // Departure field
                  CustomTextField(
                    controller: _departureController,
                    hint: 'Where are you?',
                    focusNode: _departureFocusNode,
                    prefixIcon: const Icon(Icons.my_location),
                    suffixIcon: IconButton(
                      icon: _isLoadingLocation 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, color: AppTheme.primaryColor),
                      onPressed: _getCurrentLocation,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchLocations(value);
                      } else {
                        setState(() {
                          _showSearchResults = false;
                          _searchResults = [];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Destination field
                      CustomTextField(
                    controller: _destinationController,
                    hint: 'Where do you want to go?',
                    focusNode: _destinationFocusNode,
                    prefixIcon: const Icon(Icons.location_on),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchLocations(value);
                      } else {
                        setState(() {
                          _showSearchResults = false;
                          _searchResults = [];
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Find ride button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: PrimaryButton(
              label: 'Find Ride',
              onPressed: _onFindRidePressed,
              isLoading: false,
            ),
          ),


          // Search results dropdown
          if (_showSearchResults && _searchResults.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 140,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF333333), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                    children: [
                    if (_isSearching)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Searching locations...', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    if (!_isSearching)
                      for (var placemark in _searchResults)
                        ListTile(
                          leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                          title: Text(
                            placemark.name ?? _formatLocationName(placemark),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                              if (placemark.street != null && placemark.street!.isNotEmpty)
                                      Text(
                                  placemark.street!,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                '${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                          trailing: const Icon(
                                  Icons.arrow_forward_ios,
                            color: Colors.grey,
                                  size: 16,
                          ),
                          onTap: () {
                            bool isDeparture = _departureFocusNode.hasFocus;
                            _selectLocation(placemark, isDeparture);
                          },
                      ),
                    ],
                  ),
                ),
            ),

          // Debug info
          if (AppConfig.isDevelopment)
            Positioned(
              top: MediaQuery.of(context).padding.top + 200,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Map Status: ${_isMapReady ? "Ready" : "Loading..."} | Location: ${_currentPosition != null ? "Found" : "Not found"}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        ],
      ),
    );
  }

  // Dark mode map style
  static const String _darkMapStyle = '''
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
