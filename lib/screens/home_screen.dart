import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:app_tarantulas/widgets/configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_tarantulas/screens/form_screen.dart'; // Asegúrate de que la ruta sea correcta

class MyHomeScreen extends StatelessWidget {
  final String title;
  final VoidCallback? onToggleTheme;

  const MyHomeScreen({super.key, required this.title, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Configuration(onToggleTheme: onToggleTheme),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Protege a las tarántulas',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Universidad de la Sierra Juárez',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 60),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Lottie.asset(
                                'assets/animations/tarantula.json',
                                fit: BoxFit.contain,
                                repeat: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Contesta esta breve encuesta y contribuye a la preservación de las tarántulas",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FormScreen(),
                              ),
                            );
                          },
                          icon: const Icon(FontAwesomeIcons.spider),
                          label: const Text('Iniciar encuesta'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
