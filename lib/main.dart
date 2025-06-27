import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_tarantulas/screens/home_screen.dart';
import 'package:app_tarantulas/screens/encuestaScreen.dart';
import 'package:app_tarantulas/screens/resultados_screen.dart';
import 'package:app_tarantulas/configurations/app_theme.dart';
import 'package:app_tarantulas/models/usuario_model.dart';
import 'package:app_tarantulas/models/encuesta_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UsuarioAdapter());
  Hive.registerAdapter(EncuestaAdapter());

  await Hive.close();

  await Hive.deleteBoxFromDisk('usuarios');
  await Hive.deleteBoxFromDisk('encuestas');

  await Hive.openBox<Usuario>('usuarios');
  await Hive.openBox<Encuesta>('encuestas');

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
      theme: appThemeLight, // Tema claro
      darkTheme: appThemeDark, // Tema oscuro
      debugShowCheckedModeBanner: false,
      home: MyHomeScreen(
        title: 'Tliltocatl Schroederi',
        onToggleTheme: _toggleTheme,
      ),
      routes: {
        '/encuesta': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Usuario;
          return EncuestaScreen(usuario: args);
        },
        '/resultados': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Usuario;
          return ResultadosScreen(usuario: args);
        },
      },
    );
  }
}
