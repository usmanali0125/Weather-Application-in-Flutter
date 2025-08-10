import 'package:flutter/material.dart';

final LightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  colorScheme:const ColorScheme.light(
    primary: Color.fromARGB(26, 153, 147, 147),
    secondary: Colors.white,
    surface: Colors.white70,
    onPrimary: Colors.white70,
  ), 
); 

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 237, 233, 233),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(31, 0, 0, 0),
    secondary: Colors.black,
    surface: Colors.black38,
    onPrimary: Colors.black38,
  ), 
); 