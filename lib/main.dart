import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_tarantulas/screens/home_screen.dart';
import 'package:app_tarantulas/configurations/app_theme.dart';
import 'package:app_tarantulas/models/usuario_model.dart'; // importa el modelo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();

  // Registra el adapter
  Hive.registerAdapter(UsuarioAdapter());

  // Abre la caja para guardar usuarios
  await Hive.openBox<Usuario>('usuarios');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tarantulas',
      themeMode: _themeMode,
      theme: appTheme.copyWith(brightness: Brightness.light), // Tema claro
      darkTheme: appTheme.copyWith(brightness: Brightness.dark), // Tema oscuro
      debugShowCheckedModeBanner: false,
      home: MyHomeScreen(
        title: 'Tliltocatl Schroederi',
        onToggleTheme: _toggleTheme, // Pasamos la función al home
      ),
    );
  }
}

