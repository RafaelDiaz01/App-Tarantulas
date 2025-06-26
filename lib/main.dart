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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tarantulas',
      themeMode: ThemeMode.dark,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const MyHomeScreen(title: 'Tliltocatl Schroederi'),
    );
  }
}
