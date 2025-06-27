import 'package:flutter/material.dart';
import '../configurations/app_theme.dart'; // Importa los temas  

// Define el color azul claro que quieres usar (puedes usar uno del tema o definir uno aquí)
final Color azulClaro = const Color(0xFF42A5F5); // Azul claro, puedes cambiarlo

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Controladores y valores
  final _fechaController = TextEditingController();
  final _localidadController = TextEditingController();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  String? _sexo;
  final _lenguaController = TextEditingController();
  final _grupoEtnicoController = TextEditingController();
  final _nivelEstudiosController = TextEditingController();
  final _fuenteTrabajoController = TextEditingController();
  final _escolaridadController = TextEditingController();
  final _tenenciaTierraController = TextEditingController();
  final _estadoCivilController = TextEditingController();
  final _lugarOrigenController = TextEditingController();
  final _numHijosController = TextEditingController();

  // Total de campos requeridos para el progreso
  final int totalCampos = 13;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _fechaController.addListener(_updateProgress);
    _localidadController.addListener(_updateProgress);
    _nombreController.addListener(_updateProgress);
    _edadController.addListener(_updateProgress);
    _lenguaController.addListener(_updateProgress);
    _grupoEtnicoController.addListener(_updateProgress);
    _nivelEstudiosController.addListener(_updateProgress);
    _fuenteTrabajoController.addListener(_updateProgress);
    _escolaridadController.addListener(_updateProgress);
    _tenenciaTierraController.addListener(_updateProgress);
    _estadoCivilController.addListener(_updateProgress);
    _lugarOrigenController.addListener(_updateProgress);
    _numHijosController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int camposLlenos = 0;

    if (_fechaController.text.isNotEmpty) camposLlenos++;
    if (_localidadController.text.isNotEmpty) camposLlenos++;
    if (_nombreController.text.isNotEmpty) camposLlenos++;
    if (_edadController.text.isNotEmpty) camposLlenos++;
    if (_sexo != null && _sexo!.isNotEmpty) camposLlenos++;
    if (_lenguaController.text.isNotEmpty) camposLlenos++;
    if (_grupoEtnicoController.text.isNotEmpty) camposLlenos++;
    if (_nivelEstudiosController.text.isNotEmpty) camposLlenos++;
    if (_fuenteTrabajoController.text.isNotEmpty) camposLlenos++;
    if (_escolaridadController.text.isNotEmpty) camposLlenos++;
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

  @override
  void dispose() {
    _controller.dispose();
    _fechaController.dispose();
    _localidadController.dispose();
    _nombreController.dispose();
    _edadController.dispose();
    _lenguaController.dispose();
    _grupoEtnicoController.dispose();
    _nivelEstudiosController.dispose();
    _fuenteTrabajoController.dispose();
    _escolaridadController.dispose();
    _tenenciaTierraController.dispose();
    _estadoCivilController.dispose();
    _lugarOrigenController.dispose();
    _numHijosController.dispose();
    super.dispose();
  }

  Widget buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AnimatedBuilder(
        animation: _animation,
        builder:
            (context, child) => LinearProgressIndicator(
              value: _animation.value,
              backgroundColor: const Color.fromARGB(255, 211, 26, 26),
              valueColor: AlwaysStoppedAnimation<Color>(appColorScheme.primary),
            ),
      ),
    );
  }

  // Helper para los títulos de sección
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
        title: const Text('Formulario'),
        backgroundColor: appColorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: AnimatedBuilder(
            animation: _animation,
            builder:
                (context, child) => LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //buildProgressBar(),
              _buildSectionTitle('DATOS PERSONALES'),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _edadController,
                      decoration: InputDecoration(labelText: 'Edad'),
                      keyboardType: TextInputType.number,
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
                      decoration: InputDecoration(labelText: 'Sexo'),
                      items:
                          ['Masculino', 'Femenino', 'Otro']
                              .map(
                                (sexo) => DropdownMenuItem(
                                  value: sexo,
                                  child: Text(
                                    sexo,
                                    style: TextStyle(
                                      color: azulClaro,
                                    ), // Cambia el color aquí
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
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _estadoCivilController,
                      decoration: InputDecoration(labelText: 'Estado civil'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('UBICACIÓN Y ORIGEN'),
              TextField(
                controller: _localidadController,
                decoration: InputDecoration(labelText: 'Localidad'),
              ),
              TextField(
                controller: _lugarOrigenController,
                decoration: InputDecoration(labelText: 'Lugar de origen'),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('EDUCACIÓN Y TRABAJO'),
              DropdownButtonFormField<String>(
                value:
                    _nivelEstudiosController.text.isEmpty
                        ? null
                        : _nivelEstudiosController.text,
                dropdownColor: appColorScheme.background,
                decoration: InputDecoration(labelText: 'Escolaridad'),
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
                            child: Text(nivel),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _nivelEstudiosController.text = value!;
                    _updateProgress();
                  });
                },
              ),
              TextField(
                controller: _fuenteTrabajoController,
                decoration: InputDecoration(
                  labelText: 'Fuente principal de trabajo',
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('CULTURA Y FAMILIA'),
              TextField(
                controller: _lenguaController,
                decoration: InputDecoration(labelText: 'Lengua materna'),
              ),
              TextField(
                controller: _grupoEtnicoController,
                decoration: InputDecoration(labelText: 'Grupo étnico'),
              ),
              DropdownButtonFormField<String>(
                value:
                    _tenenciaTierraController.text.isEmpty
                        ? null
                        : _tenenciaTierraController.text,
                dropdownColor: appColorScheme.background,

                decoration: InputDecoration(
                  labelText: 'Tenencia de la tierra (comunal, privada)',
                ),
                items:
                    ['Comunal', 'Privada']
                        .map(
                          (opcion) => DropdownMenuItem(
                            value: opcion,
                            child: Text(
                              opcion,
                              style: TextStyle(color: azulClaro), // Mismo color
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
              TextField(
                controller: _numHijosController,
                decoration: InputDecoration(labelText: 'Número de hijos'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('FECHA DE LLENADO'),
              TextField(
                controller: _fechaController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _fechaController.text =
                        pickedDate.toIso8601String().split('T').first;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Selecciona la fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
