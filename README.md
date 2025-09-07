# KivuRide - Premium Taxi App

A modern Flutter taxi ordering app designed for Kigali, Rwanda with a sleek dark theme and premium user experience.

## Features

### ✅ Completed
- **Dark Theme Design**: Complete dark mode design with goldish chocolate accents (#B38A58)
- **Splash Screen**: Animated splash screen with app branding and loading animations
- **Authentication System**: 
  - Login screen with phone/email authentication and country code picker
  - Sign up screen with account type selection (Rider/Driver)
  - Forgot password and reset password screens
  - Form validation and error handling
- **User Interface**:
  - Bottom navigation with rider and driver home screens
  - Profile management with stats and account actions
  - Notifications screen with filtering and mark as read functionality
  - Recent activities screen with comprehensive activity tracking
  - Ride history with search and filter capabilities
- **Find Ride System**:
  - Interactive Google Maps with dark styling
  - Location input fields for departure and destination
  - Real-time cab markers showing available drivers
  - Map controls and user location services
- **Reusable Components**:
  - PrimaryButton with loading states
  - CustomTextField with consistent styling
  - ProfileAvatar, ProfileMenuItem, ProfileStatsCard
  - CustomBottomNavBar for navigation
- **Typography System**: Inter font with consistent text styles
- **State Management**: Flutter Riverpod for state management

### 🎨 Design System
- **Colors**: Dark theme with goldish chocolate primary color (#B38A58)
- **Typography**: Inter font family with consistent sizing and weights
- **Spacing**: 8pt grid system for consistent spacing
- **Animations**: Smooth transitions and loading states
- **Components**: Reusable UI components following Material Design 3

### 🏗️ Architecture
- **Feature-based structure**: Organized by features (auth, rider, driver, splash, etc.)
- **Shared components**: Reusable widgets in shared directory
- **Theme system**: Centralized theme configuration
- **Configuration**: App-wide configuration management
- **Mock data**: Realistic test data for development

## Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration and mock data
│   └── theme/           # Theme system and styling
├── features/
│   ├── auth/            # Authentication screens (login, signup, forgot password)
│   ├── rider/           # Rider-specific screens (home, find ride, history, profile)
│   ├── driver/          # Driver-specific screens (dashboard, rides, earnings, profile)
│   └── splash/          # Splash screen
├── shared/
│   ├── widgets/         # Reusable UI components
│   └── utils/           # Utility functions and formatters
└── main.dart           # App entry point with routing
```

## Dependencies

- **flutter_riverpod**: State management
- **google_fonts**: Typography (Inter font)
- **lottie**: Animations for splash screen
- **package_info_plus**: App version information
- **country_picker**: Country code selection for phone numbers
- **google_maps_flutter**: Interactive maps for ride finding
- **geolocator**: Location services
- **geocoding**: Address geocoding

## Mock Credentials

For testing purposes, use these credentials:

### Rider Account
- **Email**: rider@kivuride.rw
- **Phone**: +250788123456
- **Password**: Pass123

### Driver Account
- **Email**: driver@kivuride.rw
- **Phone**: +250788654321
- **Password**: Pass123

## Key Features

### 🚗 Find Ride
- Interactive Google Maps with dark styling
- Location input with departure and destination
- Real-time cab markers showing available drivers
- Map controls and zoom functionality
- Available rides counter

### 📱 User Experience
- Smooth animations and transitions
- Dark theme with goldish chocolate accents
- Consistent spacing and typography
- Responsive design for all screen sizes
- Intuitive navigation flow

### 🔐 Authentication
- Phone and email login options
- Country code picker for international numbers
- Account type selection (Rider/Driver)
- Password reset functionality
- Form validation and error handling

### 📊 Profile Management
- User statistics and ride history
- Account settings and preferences
- Support and help options
- Logout and delete account functionality

## Next Steps

- [ ] Ride selection and confirmation flow
- [ ] Real-time driver tracking
- [ ] Payment integration (Mobile Money, Cards)
- [ ] Push notifications for ride updates
- [ ] Real-time chat with drivers
- [ ] Driver earnings and analytics
- [ ] Ride rating and feedback system
- [ ] Offline mode support

## Contributing

This is a private project. Please contact the development team for contribution guidelines.