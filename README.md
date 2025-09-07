# KivuRide - Tesla Robotaxi-Inspired Taxi App

A modern Flutter taxi ordering app with a Tesla Robotaxi-inspired dark theme design.

## Features

### ✅ Completed
- **Tesla Robotaxi-Inspired Dark Theme**: Complete dark mode design with gold accents
- **Splash Screen**: Animated splash screen with Tesla-inspired logo and loading animations
- **Authentication Screens**: 
  - Login screen with email/password authentication
  - Sign up screen with form validation
  - Smooth animations and transitions
- **Reusable Components**:
  - PrimaryButton with loading states
  - SecondaryButton with outlined style
  - CustomTextField with consistent styling
- **Typography System**: Inter font with consistent text styles
- **State Management**: Flutter Riverpod for state management

### 🎨 Design System
- **Colors**: Tesla-inspired color palette with dark backgrounds and gold accents
- **Typography**: Inter font family with consistent sizing and weights
- **Spacing**: 8pt grid system for consistent spacing
- **Animations**: Smooth transitions and loading states
- **Components**: Reusable UI components following Material Design 3

### 🏗️ Architecture
- **Feature-based structure**: Organized by features (auth, splash, etc.)
- **Shared components**: Reusable widgets in shared directory
- **Theme system**: Centralized theme configuration
- **Configuration**: App-wide configuration management

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
│   ├── config/          # App configuration
│   └── theme/           # Theme system
├── features/
│   ├── auth/            # Authentication screens
│   └── splash/          # Splash screen
├── shared/
│   └── widgets/         # Reusable components
└── main.dart           # App entry point
```

## Dependencies

- **flutter_riverpod**: State management
- **google_fonts**: Typography (Inter font)
- **lottie**: Animations (for future use)
- **package_info_plus**: App version information

## Design Inspiration

The app draws inspiration from Tesla's Robotaxi concept with:
- Dark, futuristic color scheme
- Clean, minimal interface
- Smooth animations and transitions
- Modern typography and spacing
- Goldish chocolate accent color (#B38A58)

## Next Steps

- [ ] Home screen with map integration
- [ ] Ride booking flow
- [ ] Driver tracking
- [ ] Payment integration
- [ ] User profile management
- [ ] Push notifications
- [ ] Real-time chat with drivers

## Contributing

This is a private project. Please contact the development team for contribution guidelines.