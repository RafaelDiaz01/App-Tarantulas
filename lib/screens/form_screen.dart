import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../models/usuario_model.dart';
import '../configurations/app_theme.dart';
import '../screens/encuestaScreen.dart';

final Color azulClaro = const Color(0xFF42A5F5);

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  // Controladores y valores
  final _localidadController = TextEditingController();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  String? _sexo;
  final _lenguaController = TextEditingController();
  final _grupoEtnicoController = TextEditingController();
  String? _nivelEstudios;
  final _fuenteTrabajoController = TextEditingController();
  final _tenenciaTierraController = TextEditingController();
  final _estadoCivilController = TextEditingController();
  final _lugarOrigenController = TextEditingController();
  final _numHijosController = TextEditingController();

  final int totalCampos = 12;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);

    // Escucha cambios para progreso
    _localidadController.addListener(_updateProgress);
    _nombreController.addListener(_updateProgress);
    _edadController.addListener(_updateProgress);
    _lenguaController.addListener(_updateProgress);
    _grupoEtnicoController.addListener(_updateProgress);
    _fuenteTrabajoController.addListener(_updateProgress);
    _estadoCivilController.addListener(_updateProgress);
    _lugarOrigenController.addListener(_updateProgress);
    _numHijosController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int camposLlenos = 0;
    if (_localidadController.text.isNotEmpty) camposLlenos++;
    if (_nombreController.text.isNotEmpty) camposLlenos++;
    if (_edadController.text.isNotEmpty) camposLlenos++;
    if (_sexo != null && _sexo!.isNotEmpty) camposLlenos++;
    if (_lenguaController.text.isNotEmpty) camposLlenos++;
    if (_grupoEtnicoController.text.isNotEmpty) camposLlenos++;
    if (_nivelEstudios != null && _nivelEstudios!.isNotEmpty) camposLlenos++;
    if (_fuenteTrabajoController.text.isNotEmpty) camposLlenos++;
    if (_tenenciaTierraController.text.isNotEmpty) camposLlenos++;
    if (_estadoCivilController.text.isNotEmpty) camposLlenos++;
    if (_lugarOrigenController.text.isNotEmpty) camposLlenos++;
    if (_numHijosController.text.isNotEmpty) camposLlenos++;

    double nuevoProgreso = camposLlenos / totalCampos;

    _animation = Tween<double>(
      begin: _animation.value,
      end: nuevoProgreso,
    ).animate(_controller);

    _controller
      ..reset()
      ..forward();
  }

  void _guardarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final box = await Hive.openBox<Usuario>('usuariosBox');
    final uuid = Uuid();

    final nuevoUsuario = Usuario(
      id: uuid.v4(),
      nombre: _nombreController.text,
      edad: int.tryParse(_edadController.text) ?? 0,
      sexo: _sexo!,
      lenguaMaterna: _lenguaController.text,
      grupoEtnico: _grupoEtnicoController.text,
      fuenteTrabajo: _fuenteTrabajoController.text,
      escolaridad: _nivelEstudios!,
      tenenciaTierra: _tenenciaTierraController.text,
      estadoCivil: _estadoCivilController.text,
      lugarOrigen: _lugarOrigenController.text,
      numeroHijos: int.tryParse(_numHijosController.text) ?? 0,
      localidad: _localidadController.text,
      fechaRegistro: DateTime.now(),
    );

    await box.add(nuevoUsuario);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado con éxito')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EncuestaScreen(usuario: nuevoUsuario),
        ),
      );
    }
  }

  Future<void> _generateAndSharePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Usuario', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 12),
              pw.Text('Nombre: ${_nombreController.text}'),
              pw.Text('Edad: ${_edadController.text}'),
              pw.Text('Sexo: $_sexo'),
              pw.Text('Estado Civil: ${_estadoCivilController.text}'),
              pw.Text('Localidad: ${_localidadController.text}'),
              pw.Text('Lugar de Origen: ${_lugarOrigenController.text}'),
              pw.Text('Escolaridad: $_nivelEstudios'),
              pw.Text('Fuente de Trabajo: ${_fuenteTrabajoController.text}'),
              pw.Text('Lengua Materna: ${_lenguaController.text}'),
              pw.Text('Grupo Étnico: ${_grupoEtnicoController.text}'),
              pw.Text('Tenencia de Tierra: ${_tenenciaTierraController.text}'),
              pw.Text('Número de Hijos: ${_numHijosController.text}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/reporte_usuario.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Te comparto el PDF del formulario.');
  }

  @override
  void dispose() {
    _controller.dispose();
    _localidadController.dispose();
    _nombreController.dispose();
    _edadController.dispose();
    _lenguaController.dispose();
    _grupoEtnicoController.dispose();
    _fuenteTrabajoController.dispose();
    _tenenciaTierraController.dispose();
    _estadoCivilController.dispose();
    _lugarOrigenController.dispose();
    _numHijosController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuraciones",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: AnimatedBuilder(
            animation: _animation,
            builder:
                (context, child) => LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionTitle('DATOS PERSONALES'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _edadController,
                        decoration: const InputDecoration(
                          labelText: 'Edad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sexo,
                        dropdownColor: Theme.of(context).colorScheme.background,
                        decoration: const InputDecoration(
                          labelText: 'Sexo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        validator: (v) => v == null ? 'Requerido' : null,
                        items:
                            ['Masculino', 'Femenino', 'Otro']
                                .map(
                                  (sexo) => DropdownMenuItem(
                                    value: sexo,
                                    child: Text(
                                      sexo,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _sexo = value;
                            _updateProgress();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // <-- Espaciado después de Sexo
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value:
                            _estadoCivilController.text.isEmpty
                                ? null
                                : _estadoCivilController.text,
                        dropdownColor: Theme.of(context).colorScheme.background,
                        decoration: const InputDecoration(
                          labelText: 'Estado civil',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        validator: (v) => v == null ? 'Requerido' : null,
                        items:
                            [
                                  'Soltero/a',
                                  'Casado/a',
                                  'Divorciado/a',
                                  'Viudo/a',
                                  'Unión civil o de hecho',
                                ]
                                .map(
                                  (estado) => DropdownMenuItem(
                                    value: estado,
                                    child: Text(
                                      estado,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _estadoCivilController.text = value!;
                            _updateProgress();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildSectionTitle('UBICACIÓN Y ORIGEN'),
                TextFormField(
                  controller: _localidadController,
                  decoration: const InputDecoration(
                    labelText: 'Localidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lugarOrigenController,
                  decoration: const InputDecoration(
                    labelText: 'Lugar de origen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('EDUCACIÓN Y TRABAJO'),
                DropdownButtonFormField<String>(
                  value: _nivelEstudios,
                  dropdownColor: Theme.of(context).colorScheme.background,
                  decoration: const InputDecoration(
                    labelText: 'Escolaridad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (v) => v == null ? 'Requerido' : null,
                  items:
                      [
                            'Primaria',
                            'Secundaria',
                            'Preparatoria',
                            'Universidad',
                            'Ninguno',
                          ]
                          .map(
                            (nivel) => DropdownMenuItem(
                              value: nivel,
                              child: Text(
                                nivel,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _nivelEstudios = value;
                      _updateProgress();
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fuenteTrabajoController,
                  decoration: const InputDecoration(
                    labelText: 'Fuente principal de trabajo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),

                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('CULTURA Y FAMILIA'),
                TextFormField(
                  controller: _lenguaController,
                  decoration: const InputDecoration(
                    labelText: 'Lengua materna',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _grupoEtnicoController,
                  decoration: const InputDecoration(
                    labelText: 'Grupo étnico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),

                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value:
                      _tenenciaTierraController.text.isEmpty
                          ? null
                          : _tenenciaTierraController.text,
                  dropdownColor: Theme.of(context).colorScheme.background,
                  decoration: const InputDecoration(
                    labelText: 'Tenencia de la tierra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (v) => v == null ? 'Requerido' : null,
                  items:
                      ['Comunal', 'Privada']
                          .map(
                            (opcion) => DropdownMenuItem(
                              value: opcion,
                              child: Text(
                                opcion,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _tenenciaTierraController.text = value!;
                      _updateProgress();
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _numHijosController,
                  decoration: const InputDecoration(
                    labelText: 'Número de hijos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _guardarUsuario,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _generateAndSharePDF,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generar y Compartir PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
