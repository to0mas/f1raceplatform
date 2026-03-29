import 'package:flutter/material.dart'; //nastavení barev a stylů pro aplikaci

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,

  primaryColor: Color(0xFFE10600),//červená barva pro hlavní prvky

  scaffoldBackgroundColor: Color(0xFF0B0B0D),//scaffold pozadí


  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE10600),
    secondary: Color(0xFFFFD700),
    surface: Color(0xFF1A1A1A),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Color(0xFF888888)),
  ),
);