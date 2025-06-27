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

class _EncuestaScreenState extends State<EncuestaScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final Map<String, String> _respuestas = {};
  final TextEditingController _respuestaAbiertaController =
      TextEditingController();
  bool _guardando = false;
  String _textoRespuesta = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      _controller.reset();
      _controller.forward();
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
    final index = box.values.toList().indexWhere(
      (u) => u.id == widget.usuario.id,
    );

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
      appBar: AppBar(
        title: Text(
          'Pregunta ${_currentIndex + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / preguntasEncuesta.length,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 4,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 70),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.only(bottom: 30, top: 10),
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  textoPregunta,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 100),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _textoRespuesta.trim().isEmpty ? null : _siguiente,
                  child: const Text('Siguiente'),
                ),
              ),
            ] else ...[
              ...opciones!.map(
                (opcion) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        _guardarRespuesta(opcion);
                        _siguiente();
                      },
                      child: Text(
                        opcion,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
