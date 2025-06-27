import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../models/usuario_model.dart';
import '../configurations/app_theme.dart';

final Color azulClaro = const Color(0xFF42A5F5);

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen>
    with SingleTickerProviderStateMixin {
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
      Navigator.pop(context);
    }
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
          color: appColorScheme.primary,
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
        backgroundColor: appColorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => LinearProgressIndicator(
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
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _edadController,
                        decoration: const InputDecoration(labelText: 'Edad'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sexo,
                        dropdownColor: appColorScheme.background,
                        decoration: const InputDecoration(labelText: 'Sexo'),
                        validator: (v) => v == null ? 'Requerido' : null,
                        items: ['Masculino', 'Femenino', 'Otro']
                            .map(
                              (sexo) => DropdownMenuItem(
                                value: sexo,
                                child: Text(sexo, style: TextStyle(color: azulClaro)),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _estadoCivilController,
                        decoration: const InputDecoration(labelText: 'Estado civil'),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('UBICACIÓN Y ORIGEN'),
                TextFormField(
                  controller: _localidadController,
                  decoration: const InputDecoration(labelText: 'Localidad'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _lugarOrigenController,
                  decoration: const InputDecoration(labelText: 'Lugar de origen'),
                  validator: (v) => v!.isEmpty ? 'Requerido': null,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('EDUCACIÓN Y TRABAJO'),
                DropdownButtonFormField<String>(
                  value: _nivelEstudios,
                  dropdownColor: appColorScheme.background,
                  decoration: const InputDecoration(labelText: 'Escolaridad'),
                  validator: (v) => v == null ? 'Requerido' : null,
                  items: [
                    'Primaria',
                    'Secundaria',
                    'Preparatoria',
                    'Universidad',
                    'Ninguno',
                  ].map((nivel) => DropdownMenuItem(value: nivel, child: Text(nivel))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _nivelEstudios = value;
                      _updateProgress();
                    });
                  },
                ),
                TextFormField(
                  controller: _fuenteTrabajoController,
                  decoration: const InputDecoration(labelText: 'Fuente principal de trabajo'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('CULTURA Y FAMILIA'),
                TextFormField(
                  controller: _lenguaController,
                  decoration: const InputDecoration(labelText: 'Lengua materna'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _grupoEtnicoController,
                  decoration: const InputDecoration(labelText: 'Grupo étnico'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _tenenciaTierraController.text.isEmpty ? null : _tenenciaTierraController.text,
                  dropdownColor: appColorScheme.background,
                  decoration: const InputDecoration(labelText: 'Tenencia de la tierra'),
                  validator: (v) => v == null ? 'Requerido' :null,
                  items: ['Comunal', 'Privada'] .map((opcion) => DropdownMenuItem(value: opcion, child: Text(opcion, style: TextStyle(color: azulClaro)))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _tenenciaTierraController.text = value!;
                      _updateProgress();
                    });
                  },
                ),
                TextFormField(
                  controller: _numHijosController,
                  decoration: const InputDecoration(labelText: 'Número de hijos'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Requerido': null,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _guardarUsuario,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
