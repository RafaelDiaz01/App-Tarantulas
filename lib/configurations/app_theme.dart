// Archivo para las configuraciones del tema de la aplicación
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Sirve para definir el tema de la aplicacion.
final appColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 1, 58, 99),
  surface: const Color.fromARGB(255, 1, 58, 99),
);

// Varible final que define el estilo que se le dara a los textos de la aplicacion.
final appTextTheme = GoogleFonts.inconsolataTextTheme().copyWith(
  bodySmall: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 14),
  bodyMedium: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 16),
  bodyLarge: GoogleFonts.inconsolata(fontWeight: FontWeight.normal, fontSize: 18),
  titleLarge: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 60),
  titleMedium: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 25),
  titleSmall: GoogleFonts.inconsolata(fontWeight: FontWeight.bold, fontSize: 20),
);

final appTextName = GoogleFonts.michromaTextTheme().copyWith(
  titleLarge: GoogleFonts.michroma(fontWeight: FontWeight.bold, fontSize: 55)
);

final appTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: appColorScheme.surface,
  colorScheme: appColorScheme,
  textTheme: appTextTheme,
);

final appThemeLight = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color.fromARGB(255, 169, 214, 229),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  textTheme: appTextTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
);

final appThemeDark = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 1, 73, 124),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  textTheme: appTextTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);
