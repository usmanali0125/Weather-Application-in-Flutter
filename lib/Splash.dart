import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import 'package:weatherapp/StartingScreen.dart';

class SplashScreen extends StatelessWidget {
  final Function(String) onWeatherConditionChanged;
  final VoidCallback onToggleTheme;

  const SplashScreen({
    super.key,
    required this.onWeatherConditionChanged,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: Lottie.asset('assets/splash.json', fit: BoxFit.cover),

      splashIconSize: MediaQuery.of(context).size.width * 0.5,
      nextScreen: StartingScreen(
        onWeatherConditionChanged: onWeatherConditionChanged,
        onToggleTheme: onToggleTheme,
      ),


      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
      animationDuration: Duration(milliseconds: 1500),
      
    );
  }
}
