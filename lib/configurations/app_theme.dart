// Archivo para las configuraciones del tema de la aplicación
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Sirve para definir el tema de la aplicacion.
final appColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 20, 33, 61),
  surface: const Color.fromARGB(255, 20, 33, 61),
);

// Varible final que define el estilo que se le dara a los textos de la aplicacion.
final appTextTheme = GoogleFonts.robotoTextTheme().copyWith(
  bodyMedium: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16),
  bodyLarge: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 18),
  titleLarge: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 20),
  titleMedium: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
  titleSmall: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16),
);

final appTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: appColorScheme.surface,
  colorScheme: appColorScheme,
  textTheme: appTextTheme,
);
