class MockCredentials {
  // Mock Rider Account
  static const Map<String, dynamic> riderAccount = {
    'name': 'John Rider',
    'email': 'rider@kivuride.com',
    'phone': '+250788123456',
    'password': 'rider123',
    'accountType': 'rider',
    'userId': 'rider_001',
    'profile': {
      'rating': 4.8,
      'totalRides': 45,
      'memberSince': '2024-01-15',
      'preferredPayment': 'Mobile Money',
    }
  };

  // Mock Driver Account
  static const Map<String, dynamic> driverAccount = {
    'name': 'Sarah Driver',
    'email': 'driver@kivuride.com',
    'phone': '+250788654321',
    'password': 'driver123',
    'accountType': 'driver',
    'userId': 'driver_001',
    'profile': {
      'rating': 4.9,
      'totalRides': 156,
      'memberSince': '2023-11-20',
      'vehicleInfo': {
        'make': 'Toyota',
        'model': 'Corolla',
        'year': 2022,
        'color': 'White',
        'plateNumber': 'RAA 123A',
      },
      'licenseNumber': 'DL123456789',
    }
  };

  // Additional Test Accounts
  static const Map<String, dynamic> testRider = {
    'name': 'Test User',
    'email': 'test@kivuride.com',
    'phone': '+250788999999',
    'password': 'test123',
    'accountType': 'rider',
    'userId': 'rider_002',
  };

  static const Map<String, dynamic> testDriver = {
    'name': 'Test Driver',
    'email': 'testdriver@kivuride.com',
    'phone': '+250788888888',
    'password': 'test123',
    'accountType': 'driver',
    'userId': 'driver_002',
  };

  // Get all mock accounts
  static List<Map<String, dynamic>> getAllAccounts() {
    return [riderAccount, driverAccount, testRider, testDriver];
  }

  // Get accounts by type
  static List<Map<String, dynamic>> getAccountsByType(String accountType) {
    return getAllAccounts().where((account) => account['accountType'] == accountType).toList();
  }

  // Validate login credentials
  static Map<String, dynamic>? validateLogin(String identifier, String password) {
    final accounts = getAllAccounts();
    
    for (final account in accounts) {
      final email = account['email'] as String;
      final phone = account['phone'] as String;
      final accountPassword = account['password'] as String;
      
      if ((identifier == email || identifier == phone) && password == accountPassword) {
        return account;
      }
    }
    
    return null;
  }
}
