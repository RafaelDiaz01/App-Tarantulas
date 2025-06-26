// Pantalla principal de la aplicaciónimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animación de fondo (ajusta opacity si es necesario)
          Opacity(
            opacity: 0.3,
            child: Center(
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.6, // 60% del ancho de pantalla
                height:
                    MediaQuery.of(context).size.height *
                    0.4, // 40% del alto de pantalla
                child: Lottie.asset(
                  'assets/animations/tarantulas.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          ),
          // Contenido encima (botones, texto, etc.)
          Center(child: Text("¡Encuesta de Tarántulas!")),
        ],
      ),
    );
  }
}
