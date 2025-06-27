import 'package:flutter/material.dart';
import 'package:app_tarantulas/utils/constantes.dart';
import 'package:app_tarantulas/models/usuario_model.dart';
import 'package:hive/hive.dart';

class EncuestaScreen extends StatefulWidget {
  final Usuario usuario;

  const EncuestaScreen({super.key, required this.usuario});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  int _currentIndex = 0;
  final Map<String, String> _respuestas = {};
  final TextEditingController _respuestaAbiertaController = TextEditingController();
  bool _guardando = false;
  String _textoRespuesta = '';

  @override
  void dispose() {
    _respuestaAbiertaController.dispose();
    super.dispose();
  }

  void _guardarRespuesta(String respuesta) {
    final pregunta = preguntasEncuesta[_currentIndex]['pregunta'] as String;
    _respuestas[pregunta] = respuesta;
  }

  Future<void> _siguiente() async {
    if (_guardando) return;
    _guardando = true;

    if (_esAbierta()) {
      final texto = _respuestaAbiertaController.text.trim();
      if (texto.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor escribe una respuesta')),
        );
        _guardando = false;
        return;
      }
      _guardarRespuesta(texto);
      _respuestaAbiertaController.clear();
      _textoRespuesta = '';
    }

    if (_currentIndex < preguntasEncuesta.length - 1) {
      setState(() => _currentIndex++);
      _guardando = false;
    } else {
      await _finalizarEncuesta();
    }
  }

  bool _esAbierta() {
    final opciones = preguntasEncuesta[_currentIndex]['opciones'];
    return opciones == null || opciones.isEmpty;
  }

  Future<void> _finalizarEncuesta() async {
    final box = await Hive.openBox<Usuario>('usuariosBox');
    final index = box.values.toList().indexWhere((u) => u.id == widget.usuario.id);

    if (index != -1) {
      final actualizado = widget.usuario.copyWith(respuestas: _respuestas);
      await box.putAt(index, actualizado);

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/resultados',
        arguments: actualizado,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la encuesta')),
      );
      Navigator.pop(context);
    }
    _guardando = false;
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntasEncuesta[_currentIndex];
    final textoPregunta = pregunta['pregunta'] as String;
    final opciones = pregunta['opciones'] as List<String>?;

    return Scaffold(
      appBar: AppBar(title: Text('Pregunta ${_currentIndex + 1}')),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [Colors.deepPurple, Colors.deepPurpleAccent]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textoPregunta,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (_esAbierta()) ...[
              TextField(
                controller: _respuestaAbiertaController,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu respuesta aquí',
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (valor) {
                  setState(() {
                    _textoRespuesta = valor;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _textoRespuesta.trim().isEmpty ? null : _siguiente,
                child: const Text('Siguiente'),
              ),
            ] else ...[
              ...opciones!.map(
                (opcion) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      _guardarRespuesta(opcion);
                      _siguiente();
                    },
                    child: Text(opcion),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
