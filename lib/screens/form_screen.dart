import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../models/usuario_model.dart';
import '../configurations/app_theme.dart';
import '../screens/encuestaScreen.dart';

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
    _tenenciaTierraController.addListener(_updateProgress);
    _estadoCivilController.addListener(_updateProgress);
    _lugarOrigenController.addListener(_updateProgress);
    _numHijosController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int llenos = 0;
    if (_localidadController.text.isNotEmpty) llenos++;
    if (_nombreController.text.isNotEmpty) llenos++;
    if (_edadController.text.isNotEmpty) llenos++;
    if (_sexo != null) llenos++;
    if (_lenguaController.text.isNotEmpty) llenos++;
    if (_grupoEtnicoController.text.isNotEmpty) llenos++;
    if (_nivelEstudios != null) llenos++;
    if (_fuenteTrabajoController.text.isNotEmpty) llenos++;
    if (_tenenciaTierraController.text.isNotEmpty) llenos++;
    if (_estadoCivilController.text.isNotEmpty) llenos++;
    if (_lugarOrigenController.text.isNotEmpty) llenos++;
    if (_numHijosController.text.isNotEmpty) llenos++;

    final progreso = llenos / totalCampos;
    _animation = Tween<double>(begin: _animation.value, end: progreso)
        .animate(_controller);
    _controller
      ..reset()
      ..forward();
  }

  Future<void> _guardarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    // Abre la misma caja 'usuarios' que en main.dart
    final box = await Hive.openBox<Usuario>('usuarios');
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
      respuestas: {}, // iniciamos vacío
    );

    await box.add(nuevoUsuario);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario guardado con éxito')),
    );

    // Navega a la encuesta con el usuario recién creado
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EncuestaScreen(usuario: nuevoUsuario),
      ),
    );
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

  Widget _buildSectionTitle(String title) => Padding(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => LinearProgressIndicator(
              value: _animation.value,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).colorScheme.onPrimary),
              minHeight: 4,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (v) => v == null ? 'Requerido' : null,
                items: ['Masculino', 'Femenino', 'Otro']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _sexo = v;
                    _updateProgress();
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estadoCivilController.text.isEmpty
                    ? null
                    : _estadoCivilController.text,
                decoration: const InputDecoration(
                  labelText: 'Estado civil',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (v) => v == null ? 'Requerido' : null,
                items: [
                  'Soltero/a',
                  'Casado/a',
                  'Divorciado/a',
                  'Viudo/a',
                  'Unión civil o de hecho',
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _estadoCivilController.text = v!;
                    _updateProgress();
                  });
                },
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
                decoration: const InputDecoration(
                  labelText: 'Escolaridad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (v) => v == null ? 'Requerido' : null,
                items: [
                  'Primaria',
                  'Secundaria',
                  'Preparatoria',
                  'Universidad',
                  'Ninguno',
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _nivelEstudios = v;
                    _updateProgress();
                  });
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tenenciaTierraController.text.isEmpty
                    ? null
                    : _tenenciaTierraController.text,
                decoration: const InputDecoration(
                  labelText: 'Tenencia de la tierra',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (v) => v == null ? 'Requerido' : null,
                items: ['Comunal', 'Privada']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _tenenciaTierraController.text = v!;
                    _updateProgress();
                  });
                },
              ),
              const SizedBox(height: 16),
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
                label: const Text('Guardar y continuar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
