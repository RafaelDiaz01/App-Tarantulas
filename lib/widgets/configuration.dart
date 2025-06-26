import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  final VoidCallback? onToggleTheme;

  const Configuration({super.key, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuraciones",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección 1: Cambiar tema
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: onToggleTheme,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cambiar tema",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      "Activa el modo claro u oscuro",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            // Sección 2: Otro ejemplo de sección
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: (){},
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Acerca de",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      "Información de la aplicación",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
