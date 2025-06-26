// Archivo para las configuraciones del tema de la aplicación
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Sirve para definir el tema de la aplicacion.
final appColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 26, 111, 209),
  surface: const Color.fromARGB(255, 26, 111, 209),
);

// Varible final que define el estilo que se le dara a los textos de la aplicacion.
final appTextTheme = GoogleFonts.inconsolataTextTheme().copyWith(
  bodySmall: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 14),
  bodyMedium: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 16),
  bodyLarge: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 18),
  titleLarge: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 80),
  titleMedium: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 25),
  titleSmall: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 20),
);

final appTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: appColorScheme.surface,
  colorScheme: appColorScheme,
  textTheme: appTextTheme,
);
