// Archivo que contiene la pantalla del formulario del usuario

import 'package:flutter/material.dart';

//Fecha
//Localidad
//Nombre
//Edad
//Sexo
//Lengua materna
//Grupo etnico
//Nivel de estudios
//Cual es tu principal fuente de trabajo
//Escolaridad
//Tenencia de la tierra(comunal,privada)
//Estado civil
//Lugar de origen 
//Numero de hijos(si aplica)


class FormScreen extends StatefulWidget{
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Fecha'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Localidad'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(labelText: 'Sexo'),
            ),
            // Agregar más campos según sea necesario
          ],
        ),
      ),
    );
  }
}