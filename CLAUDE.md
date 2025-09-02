# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

株主優待マップ (Shareholder Benefit Map) - A Flutter application for Japanese shareholders to find stores where they can use their shareholder benefit vouchers. The app displays vouchers, available stores, and provides map functionality.

## Project Status

- **Repository**: Fully implemented Flutter application
- **Language/Framework**: Flutter/Dart
- **Build System**: Flutter SDK
- **Dependencies**: Configured with Google Maps, location services, and state management

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for release
flutter build apk
flutter build ios

# Static analysis
flutter analyze

# Run tests (when tests are added)
flutter test
```

## Architecture

- `lib/main.dart` - App entry point with Provider setup and MaterialApp configuration
- `lib/models/` - Data models (ShareholderBenefit, Store)
- `lib/screens/` - Screen widgets (HomeScreen, StoreListScreen, MapScreen, StoreMapScreen)
- `lib/widgets/` - Reusable UI components (BenefitCard, StoreCard)
- `lib/services/` - Business logic and state management (BenefitService)
- `assets/` - Images and data files
- Platform-specific configuration in `android/` and `ios/` directories

## Key Features

1. **Home Screen**: Lists shareholder benefits with search functionality
2. **Store List Screen**: Shows stores for selected benefit with prefecture filtering
3. **Map Integration**: Google Maps integration for store locations
4. **Search & Filter**: Search by company name, benefit type, or stock code
5. **Japanese Localization**: Full Japanese interface and content

## Dependencies

- `google_maps_flutter`: Map display and markers
- `provider`: State management
- `geolocator`: Location services
- `permission_handler`: Location permissions
- `flutter_localizations`: Japanese localization

## Notes

- Google Maps API key required for map functionality
- Location permissions configured for both Android and iOS
- Sample data includes major Japanese companies (Aeon, Skylark, Mitsukoshi, Yamada)
- UI follows Material Design with Japanese text and conventions