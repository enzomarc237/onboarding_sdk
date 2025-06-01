# Onboarding SDK - Flutter Feature Tour Package

[![Pub Version](https://img.shields.io/pub/v/onboarding_sdk)](https://pub.dev/packages/onboarding_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package for creating interactive feature tours and onboarding experiences in your app. Guide users through your UI with customizable tooltips and highlights.

## Features

- 🎯 **Interactive Tours**: Create step-by-step guides for UI features
- 🖌️ **Customizable**: Style highlights and tooltips to match your app's theme
- 💾 **Persistence**: Remember completed tours using shared preferences
- 📱 **Responsive**: Works with any screen size and orientation
- 🔁 **Navigation**: Next/previous/skip controls for tour progression

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  onboarding_sdk: ^0.1.0
```

Run `flutter pub get`

## Usage

### Basic Setup

```dart
import 'package:onboarding_sdk/onboarding_sdk.dart';

final tourController = TourController(
  steps: [
    TourStep(
      key: myButtonKey,
      title: 'Action Button',
      description: 'Tap here to perform the main action',
    ),
    // Add more steps...
  ],
  tourId: 'main_tour',
);
```

### Starting a Tour

```dart
FloatingActionButton(
  onPressed: () => tourController.startTour(context),
  child: Icon(Icons.help),
);
```

### Customizing Appearance

```dart
TourStep(
  key: settingsKey,
  title: 'Settings Menu',
  description: 'Configure your app preferences here',
  overlayColor: Colors.black.withOpacity(0.6),
  highlightColor: Colors.blue,
  borderRadius: BorderRadius.circular(8),
);
```

## API Reference

### TourController

| Property        | Description                                 |
|-----------------|---------------------------------------------|
| `startTour()`   | Starts the tour from the first step         |
| `nextStep()`    | Advances to the next tour step              |
| `previousStep()`| Returns to the previous tour step           |
| `skipTour()`    | Skips the entire tour                       |
| `endTour()`     | Completes and ends the tour                 |

### TourStep

| Property         | Description                          | Default                |
|------------------|--------------------------------------|------------------------|
| `key`            | GlobalKey of target widget           | Required               |
| `title`          | Step title text                      | Required               |
| `description`    | Step description text                | Required               |
| `overlayColor`   | Background dim color                 | Colors.black54         |
| `highlightColor` | Highlight border color               | Colors.white           |
| `borderRadius`   | Border radius of highlight           | BorderRadius.circular(4)|

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new feature branch
3. Implement your changes
4. Add tests for your changes
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
