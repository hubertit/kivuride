import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Authentication state provider
class AuthState {
  final bool isLoggedIn;
  final Map<String, dynamic>? userData;
  final bool isLoading;

  const AuthState({
    required this.isLoggedIn,
    this.userData,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    Map<String, dynamic>? userData,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isLoggedIn: false, isLoading: true)) {
    _checkAuthStatus();
  }

  // Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    try {
      state = state.copyWith(isLoading: true);
      
      // Add timeout to prevent infinite loading
      final result = await Future.any([
        _performAuthCheck(),
        Future.delayed(const Duration(seconds: 5), () => throw TimeoutException('Auth check timeout')),
      ]);
      
      state = result;
    } catch (e) {
      // If auth check fails, default to not logged in
      state = const AuthState(isLoggedIn: false, isLoading: false);
    }
  }

  Future<AuthState> _performAuthCheck() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    Map<String, dynamic>? userData;
    
    if (isLoggedIn) {
      userData = await AuthService.getCurrentUser();
    }
    
    return AuthState(
      isLoggedIn: isLoggedIn,
      userData: userData,
      isLoading: false,
    );
  }

  // Login user
  Future<void> login(Map<String, dynamic> userData) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await AuthService.saveUserSession(userData);
      state = state.copyWith(
        isLoggedIn: true,
        userData: userData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await AuthService.clearUserSession();
      state = const AuthState(isLoggedIn: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      await AuthService.updateUserData(userData);
      state = state.copyWith(userData: userData);
    } catch (e) {
      rethrow;
    }
  }

  // Get user account type
  String? get userAccountType => state.userData?['accountType'];

  // Get user name
  String? get userName => state.userData?['name'];

  // Get user email
  String? get userEmail => state.userData?['email'];

  // Get user phone
  String? get userPhone => state.userData?['phone'];
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience providers
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final currentUserProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(authProvider).userData;
});

final userAccountTypeProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userData?['accountType'];
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
