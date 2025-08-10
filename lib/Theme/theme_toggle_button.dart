import 'package:flutter/material.dart';


class ThemeToggleButton extends StatelessWidget {
  
  final VoidCallback onToggleTheme;
  final Brightness currentBrightness;
  final Color iconColor;

  const ThemeToggleButton({
    super.key,
    required this.onToggleTheme,
    required this.currentBrightness,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleTheme,
      child: Icon(
     
        currentBrightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
        color: iconColor,
      ),
    );
  }
}
