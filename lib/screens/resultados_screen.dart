import 'package:flutter/material.dart';
import 'package:app_tarantulas/models/usuario_model.dart';

class ResultadosScreen extends StatelessWidget {
  final Usuario usuario;

  const ResultadosScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final respuestas = usuario.respuestas ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de la Encuesta'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildUsuarioHeader(),
            const Divider(thickness: 2),
            ..._buildRespuestaTiles(respuestas),
          ],
        ),
      ),
    );
  }

  Widget _buildUsuarioHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Encuestado:', style: _sectionTitleStyle()),
        const SizedBox(height: 8),
        Text('Nombre: ${usuario.nombre}', style: _infoTextStyle()),
        Text('Edad: ${usuario.edad}', style: _infoTextStyle()),
        Text('Localidad: ${usuario.localidad}', style: _infoTextStyle()),
        const SizedBox(height: 16),
      ],
    );
  }

  List<Widget> _buildRespuestaTiles(Map<String, String> respuestas) {
    final List<Widget> tiles = [];
    respuestas.forEach((pregunta, respuesta) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pregunta, style: _questionTextStyle()),
              const SizedBox(height: 4),
              Text(respuesta, style: _answerTextStyle()),
            ],
          ),
        ),
      );
      tiles.add(const Divider());
    });
    return tiles;
  }

  TextStyle _sectionTitleStyle() => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  TextStyle _questionTextStyle() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle _answerTextStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      );

  TextStyle _infoTextStyle() => const TextStyle(
        fontSize: 16,
      );
}
