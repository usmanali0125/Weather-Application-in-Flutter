import 'package:flutter/material.dart';
import 'package:weatherapp/Splash.dart';
import 'package:weatherapp/theme/weather_theme.dart';


void main() {
  runApp(
    const MyApp()
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  String weatherCondition = "Clear"; 
 
  bool isDarkMode = false; 

  
  void updateWeatherCondition(String newCondition) { 
    setState(() {
      weatherCondition = newCondition;
    });
  }

  
  void toggleThemeOverride() { 
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
  
  
    final   dynamicTheme = WeatherTheme.getTheme(weatherCondition, isDarkMode);

    return MaterialApp(
      theme: dynamicTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
       
        onWeatherConditionChanged: updateWeatherCondition, 
        onToggleTheme: toggleThemeOverride, 
      ),
    );
  }
}
