import 'package:flutter/material.dart';
import 'package:app_tarantulas/screens/home_screen.dart';
import 'package:app_tarantulas/configurations/app_theme.dart';
//import 'package:app_tarantulas/screens/form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tarantulas',
      themeMode: ThemeMode.dark, // Modo oscuro por defecto
      theme: appTheme,
      debugShowCheckedModeBanner: false, // Desactiva el banner de debug
      home: const MyHomeScreen(title: 'Tliltocatl Schroederi'),
      //home: const FormScreen(),
    );
  }
}
