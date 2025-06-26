// Pantalla principal de la aplicaciónimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 163, 17),
        title: Text("Tarantulas", style: TextStyle(fontSize: 30)),
        actions: [
          IconButton.outlined(
            onPressed: () {
              // Navigator.of(
              //   context,
              // ).push(MaterialPageRoute(builder: (context) => AddPlaceScreen()));
            },
            icon: Icon(Icons.info_outline, size: 30, color: Colors.black),
            tooltip: "Créditos", 
          ),
        ],
      ),
      body: Center(child: Text("Pantalla de inicio")),
    );
  }
}
