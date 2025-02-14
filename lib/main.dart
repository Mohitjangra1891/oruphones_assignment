import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oruphones_assignment/src/app.dart';

void updateSystemUIOverlay() {
  final brightness = PlatformDispatcher.instance.platformBrightness;
  final isDarkTheme = brightness == Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: isDarkTheme ? Colors.black : Colors.white,
      systemNavigationBarColor: isDarkTheme ? Colors.black : Colors.white,
      statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
    ),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial setup for system UI overlay style
  updateSystemUIOverlay();

  // Listen for platform brightness changes and update dynamically
  PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
    updateSystemUIOverlay();
  };
  runApp(
    const ProviderScope(child: App()),
  );
}
