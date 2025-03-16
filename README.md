# Faith Draw

<img src="assets/faith draw1.png" height=500 width=400 alt="faith draw app" />

- A Flutter application that allows users to draw and save their favorite Bible characters.

## Overview

Draw App is a simple drawing application built with Flutter that provides a creative platform for users to sketch Bible characters. The app includes features for drawing, saving, and managing drawings.

## Features

- Drawing Canvas: Create drawings with a customizable canvas
- Save Drawings: Persist your artwork using Hive local storage
- Multiple Screens: Navigate between splash, home, and drawing screens

## Project Structure

The application follows a feature-based architecture:

- Splash: Initial loading screen
- Home: Main navigation hub to view saved drawings and create new ones
- Draw: Canvas interface for creating drawings

## Technical Details

- State Management: Uses Flutter's built-in state management
- Local Storage: Implements Hive for local data persistence
- Custom Models:
  - Stroke: Represents a drawing stroke
  - CustomOffset: Custom implementation of point coordinates

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

## Installation

- Clone the repository

```
git clone https://github.com/yourusername/draw_app.git
```

- Navigate to the project directory: cd draw_app

## Install dependencies

- flutter pub get

- Run the app
  flutter run

## Supported Platforms

Android

## License

This project is licensed under the MIT License - see the LICENSE file for details.
