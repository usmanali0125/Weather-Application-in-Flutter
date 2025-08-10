import 'package:flutter/material.dart';
import 'package:weatherapp/home.dart';

class StartingScreen extends StatelessWidget {
 
  final Function(String) onWeatherConditionChanged;
  final VoidCallback onToggleTheme;

  const StartingScreen({
    super.key,
    required this.onWeatherConditionChanged,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Discover The\nWeather In Your City",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,                     
                      height: 1.2,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ClipOval(
                  child: Image.asset("assets/logo.jpeg", height: 300),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Go and check your weather maps and \n precipitations forecast",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherAppHomeScreen(
 
                          onWeatherConditionChanged: onWeatherConditionChanged,
                          onToggleTheme: onToggleTheme,
                          
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
