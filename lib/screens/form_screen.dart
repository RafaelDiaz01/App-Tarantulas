import 'package:flutter/material.dart';
import '../configurations/app_theme.dart'; // Importa tu tema

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Controladores y valores
  final _fechaController = TextEditingController();
  final _localidadController = TextEditingController();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  String? _sexo;

  // Total de campos requeridos para el progreso
  final int totalCampos = 5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);

    // Escucha cambios en los TextFields
    _fechaController.addListener(_updateProgress);
    _localidadController.addListener(_updateProgress);
    _nombreController.addListener(_updateProgress);
    _edadController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int camposLlenos = 0;

    if (_fechaController.text.isNotEmpty) camposLlenos++;
    if (_localidadController.text.isNotEmpty) camposLlenos++;
    if (_nombreController.text.isNotEmpty) camposLlenos++;
    if (_edadController.text.isNotEmpty) camposLlenos++;
    if (_sexo != null) camposLlenos++;

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
    super.dispose();
  }

  Widget buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: const Color.fromARGB(255, 211, 26, 26),
          valueColor: AlwaysStoppedAnimation<Color>(appColorScheme.primary),
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 400,
            decoration: BoxDecoration(
              color: appColorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: appColorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildProgressBar(),
                TextField(
                  controller: _fechaController,
                  decoration: InputDecoration(labelText: 'Fecha'),
                ),
                TextField(
                  controller: _localidadController,
                  decoration: InputDecoration(labelText: 'Localidad'),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _edadController,
                  decoration: InputDecoration(labelText: 'Edad'), // <-- Agregado "decoration:"
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: appColorScheme.background,
                  value: _sexo,
                  items: const [
                    DropdownMenuItem(
                      value: 'Masculino',
                      child: Text('Masculino', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Femenino',
                      child: Text('Femenino', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Otro',
                      child: Text('Otro', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sexo = value;
                      _updateProgress();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Sexo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
