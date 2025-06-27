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
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();

  bool _guardando = false;
  String _textoRespuesta = '';
  late AnimationController _controller;
  bool _mostrarComentario = false;

  String? _opcionConDetalleSeleccionada;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();

    _comentarioController.addListener(() => setState(() {}));
    _detalleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _respuestaAbiertaController.dispose();
    _comentarioController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  void _guardarRespuesta(String respuesta) {
    final pregunta = preguntasEncuesta[_currentIndex]['pregunta'] as String;
    _respuestas[pregunta] = respuesta;
  }

  bool _esAbierta() {
    final opciones = preguntasEncuesta[_currentIndex]['opciones'];
    return opciones == null || opciones.isEmpty;
  }

  bool _debeMostrarPregunta(int index) {
    final pregunta = preguntasEncuesta[index];

    if (!pregunta.containsKey('mostrarSiRespuesta')) {
      return true; // Sin condición, siempre mostrar
    }

    final condicion = pregunta['mostrarSiRespuesta'] as Map<String, dynamic>;
    final preguntaPrevia = condicion['preguntaPrevia'] as String;
    final valoresPermitidos = List<String>.from(condicion['valoresPermitidos']);

    final respuestaPrevia = _respuestas[preguntaPrevia];

    if (respuestaPrevia == null) {
      return false; // No respondida, no mostrar
    }

    return valoresPermitidos.contains(respuestaPrevia);
  }

  Future<void> _siguiente() async {
    if (_guardando) return;
    _guardando = true;

    if (_mostrarComentario) {
      final comentario = _comentarioController.text.trim();
      if (comentario.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor escribe un comentario')),
        );
        _guardando = false;
        return;
      }
      _respuestas['Comentario final'] = comentario;
      await _finalizarEncuesta();
      return;
    }

    if (_opcionConDetalleSeleccionada != null) {
      if (_detalleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor escribe un detalle')),
        );
        _guardando = false;
        return;
      }
      final respuesta =
          '$_opcionConDetalleSeleccionada: ${_detalleController.text.trim()}';
      _guardarRespuesta(respuesta);
      _detalleController.clear();
      _opcionConDetalleSeleccionada = null;
    } else if (_esAbierta()) {
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

    int siguienteIndex = _currentIndex + 1;
    while (siguienteIndex < preguntasEncuesta.length &&
        !_debeMostrarPregunta(siguienteIndex)) {
      siguienteIndex++;
    }

    if (siguienteIndex < preguntasEncuesta.length) {
      setState(() {
        _currentIndex = siguienteIndex;
        _controller.reset();
        _controller.forward();
      });
    } else {
      setState(() {
        _mostrarComentario = true;
      });
    }

    _guardando = false;
  }

  void _anterior() {
    if (_mostrarComentario) {
      setState(() {
        _mostrarComentario = false;
      });
      return;
    }

    int anteriorIndex = _currentIndex - 1;
    while (anteriorIndex >= 0 && !_debeMostrarPregunta(anteriorIndex)) {
      anteriorIndex--;
    }

    if (anteriorIndex >= 0) {
      setState(() {
        _currentIndex = anteriorIndex;
        _opcionConDetalleSeleccionada = null;
        _detalleController.clear();
        _respuestaAbiertaController.clear();
        _textoRespuesta = '';
      });
    }
  }

  Future<void> _finalizarEncuesta() async {
    final box = await Hive.openBox<Usuario>('usuarios');
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
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = !_mostrarComentario
        ? preguntasEncuesta[_currentIndex]
        : {'pregunta': '¿Quieres dejarnos un comentario final?'};
    final textoPregunta = pregunta['pregunta'] as String;
    final opciones = pregunta['opciones'] as List<String>?;

    final totalPreguntas = preguntasEncuesta.length + 1;
    final progreso = _mostrarComentario
        ? 1.0
        : (_currentIndex + 1) / totalPreguntas.toDouble();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: (_currentIndex > 0 || _mostrarComentario)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _anterior,
              )
            : null,
        title: Text(
          _mostrarComentario
              ? 'Comentario final'
              : 'Pregunta ${_currentIndex + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progreso,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.2),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 70),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.only(bottom: 30, top: 10),
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  textoPregunta,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50),

            if (_mostrarComentario) ...[
              TextField(
                controller: _comentarioController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu comentario aquí',
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _comentarioController.text.trim().isEmpty
                      ? null
                      : _siguiente,
                  child: const Text('Finalizar'),
                ),
              ),
            ] else if (_esAbierta()) ...[
              TextField(
                controller: _respuestaAbiertaController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta aquí',
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                onChanged: (valor) => setState(() {
                  _textoRespuesta = valor;
                }),
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
                        backgroundColor:
                            (_opcionConDetalleSeleccionada == opcion)
                                ? (isDark
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.3)
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1))
                                : null,
                      ),
                      onPressed: () {
                        final opcionLower = opcion.toLowerCase();
                        if (opcionLower.contains('¿cuál') ||
                            opcionLower.contains('especificar')) {
                          setState(() {
                            if (_opcionConDetalleSeleccionada == opcion) {
                              // Deseleccionar la opción si ya estaba seleccionada
                              _opcionConDetalleSeleccionada = null;
                              _detalleController.clear();
                            } else {
                              _opcionConDetalleSeleccionada = opcion;
                              _detalleController.clear();
                            }
                          });
                        } else {
                          setState(() {
                            _opcionConDetalleSeleccionada = null;
                            _detalleController.clear();
                          });
                          _guardarRespuesta(opcion);
                          _siguiente();
                        }
                      },
                      child: Text(
                        opcion,
                        style: TextStyle(
                          color: (_opcionConDetalleSeleccionada == opcion)
                              ? (isDark
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimary)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_opcionConDetalleSeleccionada != null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _detalleController,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu detalle aquí',
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _detalleController.text.trim().isEmpty
                        ? null
                        : _siguiente,
                    child: const Text('Siguiente'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
