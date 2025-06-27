import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo de la universidad
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage(
                'assets/images/unsij.png',
              ), // Cambia la ruta según tu logo
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Universidad de la Sierra Juárez",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Profesor a cargo: Dr. Alberto Martínez Barbosa",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Equipo de desarrollo:",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "• Sergio Elías Robles Ignacio\n• Kevin Rafael Díaz López\n• Rosendo Edén Mendoza Casarrubia",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Versión 1.0.0",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
