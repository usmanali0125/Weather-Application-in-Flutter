import 'package:flutter/material.dart';

class WeatherTheme {
  static ThemeData getTheme(String condition, bool isDark) {
    
    if (isDark) {
      return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black, 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Colors.white, 
          onPrimary: Colors.white,
          surface: Colors.grey[800], 
          onSurface: Colors.white70, 
        ),


        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87, 
          foregroundColor: Colors.white, 
        ),
        scaffoldBackgroundColor: Colors.black, 
      );
    }

    
    final normalized = condition.toLowerCase();

    if (normalized.contains('sunny') || normalized.contains('clear')) {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow.shade200, 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange, 
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.black, 
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.yellow.shade200, 
      );
    } else if (normalized.contains('rain') || normalized.contains('shower')) {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue.shade100,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.blue.shade100,
      );
    }
    
    
     else if (normalized.contains('cloud')) {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey.shade300,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey.shade300,
      );
    } 
    
    
    
    else if (normalized.contains('snow')) {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      );
    }
    
    
     else {
      
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
      );
    }
  }
}
